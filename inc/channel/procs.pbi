; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

Procedure.i prvBuffer( *self.tPkt )
  assert( *self\buf )
  ProcedureReturn *self\buf ;< READ-ONLY
EndProcedure

Procedure.i prvLength( *self.tPkt )
  ProcedureReturn *self\len
EndProcedure

Procedure prvSetLength( *self.tPkt, len.i )
  assert( len <= *self\size )
  *self\len = len
EndProcedure

Procedure prvPush( *self.tPkt, byte.a )
  assert( *self\len <= *self\size )
  PokeA( *self\buf+*self\len, byte )
  *self\len+1 ;< postinc
EndProcedure

Procedure.a prvPop( *self.tPkt )
  assert( *self\len > 0 )
  *self\len-1 ;< predec
  ProcedureReturn PeekA( *self\buf+*self\len )
EndProcedure

Procedure prvReset( *self.tPkt )
  prvSetLength( *self, 0 )
EndProcedure

Procedure.i prvPktFree( *self.tPkt )
  assert( *self\buf )
  FreeMemory( *self\buf ) : *self\buf=0
  FreeMemory( *self ) : *self=0
  ProcedureReturn *self
EndProcedure

Procedure.i NewPkt( size.i )
  Protected.tPkt *self=0 : assert( size )
  If size
    *self = AllocateMemory( SizeOf(tPkt) ) : assert( *self )
    If *self
      *self\vtbl = ?iPktClass
      *self\buf  = AllocateMemory( size ) : assert( *self\buf )
      *self\size = size
      *self\len  = 0
    EndIf
  EndIf
  ProcedureReturn *self
EndProcedure

; -----------------------------------------------------------------------------

Procedure.i prvChkEncode( *dst.tOverlay, *src.tOverlay, srclen.i )
  Protected.i dstidx=0, srcidx=0, chksum.a=0
  *dst\bytes[dstidx]=$aa : dstidx+1             ;< STX
  While srcidx < srclen
    Select *src\bytes[srcidx]
      Case $aa
        *dst\bytes[dstidx]=$bb : dstidx+1
        *dst\bytes[dstidx]=$55 : dstidx+1
      Case $bb
        *dst\bytes[dstidx]=$bb : dstidx+1
        *dst\bytes[dstidx]=$44 : dstidx+1
      Case $cc
        *dst\bytes[dstidx]=$bb : dstidx+1
        *dst\bytes[dstidx]=$33 : dstidx+1
      Default
        *dst\bytes[dstidx]=*src\bytes[srcidx] : dstidx+1
    EndSelect
    chksum + *src\bytes[srcidx] : srcidx+1
  Wend
  Select chksum
    Case $aa
      *dst\bytes[dstidx]=$bb : dstidx+1
      *dst\bytes[dstidx]=$55 : dstidx+1
    Case $bb
      *dst\bytes[dstidx]=$bb : dstidx+1
      *dst\bytes[dstidx]=$44 : dstidx+1
    Case $cc
      *dst\bytes[dstidx]=$bb : dstidx+1
      *dst\bytes[dstidx]=$33 : dstidx+1
    Default
      *dst\bytes[dstidx]=chksum : dstidx+1
  EndSelect
  *dst\bytes[dstidx]=$cc : dstidx+1             ;< ETX
  ProcedureReturn dstidx
EndProcedure

Procedure.i prvSend( *self.tChannel, *pkt.iPkt )
  assert( *pkt )
  Protected.i retval=0
  If *pkt\Length() < #TXRX_BUFSIZE
    LockMutex( *self\tx\mutex ) ;< *self\tx\buf is not threadsafe!
    *self\tx\len = prvChkEncode( @*self\tx\buf, *pkt\Buffer(), *pkt\Length() )
    assert( *self\tx\len >= *pkt\Length() )
    retval = *self\dev\Send( @*self\tx\buf, *self\tx\len, @*self\tx\len )
    If retval
      *self\counts\tx\packets + 1
      *self\counts\tx\bytes + *self\tx\len
      *self\counts\tx\overhead + (*self\tx\len-*pkt\Length())
    EndIf
    UnlockMutex( *self\tx\mutex )
  Else
    Debug "*pkt\Length() exceeds #TXRX_BUFSIZE"
  EndIf
  ProcedureReturn retval
EndProcedure

Procedure.i prvCounters( *self.tChannel, *counts.tCounters )
  If *counts
    CopyStructure( @*self\counts, *counts, tCounters )
    ProcedureReturn ~0
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure prvEvtHandler( *self.tChannel, evt.i, *arg )
  ; filter from our own thread in case we need
  ; to intercept reply pkts for an exchange()
;  Select evt
  *self\evtHandler( *self, evt, *arg ) ; TODO: just pass through for now
EndProcedure

Procedure prvThread( *self.tChannel )
  assert( *self )
  Protected *pkt.iPktQueue=0, prevbyte.a=0, chksum.i=0

  prvEvtHandler( *self, #CHANEVT_START, ElapsedMilliseconds() )
  While Not TryLockMutex(*self\mutex) And 
         *self\dev\Receive(@*self\rx\buf, #TXRX_BUFSIZE, @*self\rx\len)
    *self\counts\rx\bytes + *self\rx\len
    Protected.i idx=0
    While idx < *self\rx\len
      Protected.a byte = *self\rx\buf[idx]
      If *pkt
        Select byte
          Case $55,$44,$33
            If prevbyte = $bb
              byte ! $ff
              Select byte
                Case $aa,$bb,$cc  ;< good
                  chksum + byte
                  *pkt\Push( byte )
                Default           ;< oops
                  *self\counts\rx\escape + 1
              EndSelect
            Else ;< nothing special
              chksum + byte
              *pkt\Push( byte )
            EndIf
          Case $aa ;< technically an error
            *self\counts\rx\overhead + 1
            *self\counts\rx\framing + 1
            *pkt\Reset()
            chksum = 0
          Case $bb ;< skip
            *self\counts\rx\overhead + 1
          Case $cc
            *self\counts\rx\overhead + 2  ;< chk is considered overhead
            chksum - prevbyte             ;< back out the chksum itself
            If (chksum & $ff) = *pkt\Pop()
              *self\counts\rx\packets + 1
              prvEvtHandler( *self, #CHANEVT_ORPHANPKT, *pkt )
            Else
              *self\counts\rx\chksum + 1
            EndIf
            *pkt = *pkt\Free() : assert( *pkt=0 )
          Default
            chksum + byte
            *pkt\Push( byte )
        EndSelect
      Else
        If byte = $aa
          chksum = 0
          *pkt = NewPkt( 8*1024 ) : assert( *pkt )
          *self\counts\rx\overhead + 1
        EndIf
      EndIf
      prevbyte = byte : idx + 1
    Wend
  Wend
  prvEvtHandler( *self, #CHANEVT_STOP, ElapsedMilliseconds() )
EndProcedure

Procedure.i prvExchange( *self.tChannel, *pkt.iPkt, timeout.i=20 )
  ; a little more sophisticated than simply passing
  ; raw pkts ... in here we're aware of structure because we
  ; use the tag field to 'pair' an exchange
  ProcedureReturn 0
EndProcedure

Procedure.i prvChannelFree( *self.tChannel, *counts.tCounters=0 )
  assert( *self\mutex )
  UnlockMutex( *self\mutex )    ;< signal thread to die
  assert( *self\thread )
  If Not WaitThread( *self\thread, 1000 )
    KillThread( *self\thread )  ;< times up!
  EndIf
  FreeMutex( *self\mutex )
  assert( *self\tx\mutex )
  If Not TryLockMutex( *self\tx\mutex )
    Delay(40)                 ;< one more try
    If Not TryLockMutex( *self\tx\mutex )
      Debug "TX Buffer Locked!"
    EndIf
  EndIf
  FreeMutex( *self\tx\mutex ) ;< sorry, gotta go
  *self\dev = *self\dev\Free() : assert( *self\dev=0 )
  prvCounters( *self, *counts ) ;< grab final stats on way out if desired
  ClearStructure( *self, tChannel )
  FreeMemory( *self ) : *self=0
  ProcedureReturn *self
EndProcedure

Procedure.i NewChannel( *device.Device::iDevice, evtHandler.tChannelEvent )
  Protected *self.tChannel=0
  If *device And evtHandler
    *self = AllocateMemory( SizeOf(tChannel) )
    *self\vtbl = ?iChannelClass
    *self\evtHandler = evtHandler
    *self\dev = *device
    *self\mutex = CreateMutex() : assert( *self\mutex )
    LockMutex( *self\mutex )
    *self\tx\mutex = CreateMutex()
    *self\thread = CreateThread( @prvThread(), *self )
    assert( *self\thread )
  EndIf
  ProcedureReturn *self
EndProcedure