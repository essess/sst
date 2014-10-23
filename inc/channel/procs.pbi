; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

Procedure.a prvGenTag()
  ; $80 -> $ff are reserved for Exchange()
  Static.a tag = $ff : tag + 1
  If tag < $80 : tag = $80 : EndIf
  ProcedureReturn tag
EndProcedure

Procedure.i prvChkEncode( *dst.tPkt, *src.tPkt, srclen.i )
  
  Protected.i dstidx=0, srcidx=0, chksum.a=0
  *dst\buf[dstidx]=$aa : dstidx+1             ;< STX
  While srcidx < srclen
    Select *src\buf[srcidx]
      Case $aa
        *dst\buf[dstidx]=$bb : dstidx+1
        *dst\buf[dstidx]=$55 : dstidx+1
      Case $bb
        *dst\buf[dstidx]=$bb : dstidx+1
        *dst\buf[dstidx]=$44 : dstidx+1
      Case $cc
        *dst\buf[dstidx]=$bb : dstidx+1
        *dst\buf[dstidx]=$33 : dstidx+1
      Default
        *dst\buf[dstidx]=*src\buf[srcidx] : dstidx+1
    EndSelect
    assert( dstidx <= #BUFSIZE )
    chksum + *src\buf[srcidx] : srcidx+1
  Wend
  Select chksum
    Case $aa
      *dst\buf[dstidx]=$bb : dstidx+1
      *dst\buf[dstidx]=$55 : dstidx+1
    Case $bb
      *dst\buf[dstidx]=$bb : dstidx+1
      *dst\buf[dstidx]=$44 : dstidx+1
    Case $cc
      *dst\buf[dstidx]=$bb : dstidx+1
      *dst\buf[dstidx]=$33 : dstidx+1
    Default
      *dst\buf[dstidx]=chksum : dstidx+1
  EndSelect
  *dst\buf[dstidx]=$cc : dstidx+1             ;< ETX
  assert( dstidx <= #BUFSIZE )
  ProcedureReturn dstidx
EndProcedure

Procedure.i prvSend( *self.tChannel, *pkt.tPkt )
  Protected.tPkt tx
  tx\len = prvChkEncode( @tx\buf, @*pkt\buf, *pkt\len )
  assert( tx\len >= *pkt\len )
  assert( tx\len <= #BUFSIZE )
  If *self\dev\Send( @tx\buf, tx\len, @tx\len )
    *self\counts\tx\packets + 1
    *self\counts\tx\bytes + tx\len
    *self\counts\tx\overhead + (tx\len-*pkt\len)
    ProcedureReturn ~0
  EndIf
  ProcedureReturn 0  
EndProcedure

Procedure.i prvGuardedSend( *self.tChannel, *pkt.tPkt )
  assert( *pkt )
  assert( *pkt\len <= #BUFSIZE )
  LockMutex( *self\txmutex )
  Protected.i retval = prvSend( *self, *pkt )
  UnlockMutex( *self\txmutex )
  ProcedureReturn retval
EndProcedure

Procedure.i prvExchange( *self.tChannel, *pkt.tPkt, timeout.i=20 )
  assert( *pkt )
  assert( *pkt\len <= #BUFSIZE )
  assert( PktHasTag(*pkt) )
  assert( timeout>0 And timeout<3000 )
  assert( *self\pkt=0 )
  LockMutex( *self\txmutex )
  PktTag(*pkt) = prvGenTag() : assert( PktTag(*pkt) >= $80 )
  Protected.i retval=0
  *self\pkt = *pkt
  If prvSend( *self, *pkt )
    Protected.i time = timeout
    While time>0 And *self\pkt
      Delay(1) : time-1
    Wend
    If Not *self\pkt
      retval=~0 ;< this is the ultimate indicator of matched reply
      Debug "Exchange[$"+RSet(Hex(PktTag(*pkt)),2,"0")+"] Time: "+Str(timeout-time)+"ms"
      *self\counts\good_exchanges+1
    EndIf
  EndIf
  *self\pkt = 0
  UnlockMutex( *self\txmutex )
  If Not retval
    *self\counts\failed_exchanges+1
  EndIf
  ProcedureReturn retval
EndProcedure

Procedure.i prvCounters( *self.tChannel, *counts.tCounters )
  If *counts
    CopyMemory( @*self\counts, *counts, SizeOf(tCounters) )
    ProcedureReturn ~0
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure prvEvtHandler( *self.tChannel, evt.i, *arg )
  If evt = #CHANEVT_ORPHANPKT
    Protected *pkt.tPkt = *arg
    assert( *pkt\len <= #BUFSIZE )
    If *self\pkt And PktHasTag(*pkt) And PktTag(*pkt)=PktTag(*self\pkt) ;< match ?
      CopyMemory( *pkt, *self\pkt, *pkt\len )
      *self\pkt\len = *pkt\len
      *self\pkt = 0
      ProcedureReturn
    Else
      *self\counts\orphans + 1 ;< spurious/async, aka an orphan
    EndIf
  EndIf
  *self\evtHandler( *self, evt, *arg )
EndProcedure

Procedure prvThread( *self.tChannel )
  assert( *self )
  Protected *pkt.tPkt=0, esc.i=0, chksum.i=0, rx.tPkt
  prvEvtHandler( *self, #CHANEVT_START, ElapsedMilliseconds() )
  While Not *self\die And *self\dev\Receive(@rx\buf, #BUFSIZE, @rx\len)
    *self\counts\rx\bytes + rx\len
    Protected.i idx=0
    While idx < rx\len
      assert( idx < #BUFSIZE )
      Protected.a byte = rx\buf[idx]
      If *pkt
        If esc
          byte ! $ff
          If byte <> $aa And byte <> $bb And byte <> $cc
            *self\counts\rx\escape + 1
          EndIf
          chksum + byte
          *pkt\buf[*pkt\len] = byte
          *pkt\len + 1
          esc = 0
        Else
          Select byte
            Case $bb
              *self\counts\rx\overhead + 1
              esc = ~0 ;< next byte is special
            Case $cc
              *self\counts\rx\overhead + 2      ;< chk is considered overhead
              *pkt\len - 1 : chksum - *pkt\buf[*pkt\len]  ;< backup & backout
              If (chksum & $ff) = *pkt\buf[*pkt\len]
                *self\counts\rx\packets + 1
                prvEvtHandler( *self, #CHANEVT_ORPHANPKT, *pkt )
              Else
                *self\counts\rx\chksum + 1
              EndIf
              *pkt = FreePkt( *pkt ) : assert( *pkt=0 )
            Case $aa
              *self\counts\rx\overhead + 1
              *self\counts\rx\framing + 1
              *pkt\len = 0 : chksum = 0
            Default
              chksum + byte
              *pkt\buf[*pkt\len] = byte
              *pkt\len + 1
          EndSelect
        EndIf
      Else
        If byte = $aa
          chksum = 0
          *pkt = NewPkt() : assert( *pkt )
          *self\counts\rx\overhead + 1
        EndIf
      EndIf
      idx + 1
    Wend
  Wend
  prvEvtHandler( *self, #CHANEVT_STOP, ElapsedMilliseconds() )
EndProcedure

Procedure.i prvChannelFree( *self.tChannel, *counts.tCounters=0 )
  *self\die = ~0
  assert( *self\thread )
  If Not WaitThread( *self\thread, 500 )
    KillThread( *self\thread )  ;< times up!
  EndIf
  assert( *self\pkt=0 )
  FreeMutex( *self\txmutex ) : *self\txmutex=0
  *self\dev = *self\dev\Free() : assert( *self\dev=0 )
  prvCounters( *self, *counts ) ;< grab final stats on way out if desired
  
CompilerIf #PB_Compiler_Debugger
  Protected counts.tCounters
  prvCounters( *self, @counts )
  Debug "Counts:"
  Debug "RX Framing Errors: "+Str(counts\rx\framing)
  Debug "RX Escaping Errors: "+Str(counts\rx\escape)
  Debug "RX Checksum Errors: "+Str(counts\rx\chksum)
  Debug "RX Packets: "+Str(counts\rx\packets)
  Debug "RX Bytes: "+Str(counts\rx\bytes)
  Debug "RX Overhead: "+Str(counts\rx\overhead)
  Debug "TX Packets: "+Str(counts\tx\packets)
  Debug "TX Bytes: "+Str(counts\tx\bytes)
  Debug "TX Overhead: "+Str(counts\tx\overhead)
  Debug "Orphans: "+Str(counts\orphans)
  Debug "Good Exchanges: "+Str(counts\good_exchanges)
  Debug "Failed Exchanges: "+Str(counts\failed_exchanges)
CompilerEndIf

  FillMemory( *self, SizeOf(tChannel) )
  FreeMemory( *self ) : *self=0
  ProcedureReturn *self
EndProcedure

Procedure.i NewChannel( *d.iDevice, *evtHandler.tChannelEvent )
  Protected *self.tChannel=0
  If *d And *evtHandler
    *self = AllocateMemory( SizeOf(tChannel) )
    *self\vtbl = ?iChannelClass
    *self\evtHandler = *evtHandler
    *self\dev = *d
    *self\txmutex = CreateMutex() : assert( *self\txmutex )
    *self\die = 0
    *self\pkt = 0
    *self\thread = CreateThread( @prvThread(), *self )
    assert( *self\thread )
  EndIf
  ProcedureReturn *self
EndProcedure