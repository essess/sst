; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

Procedure.i NewPkt( *pkt.tPkt=0 )
  Protected.tPkt *newpkt = AllocateMemory( SizeOf(tPkt) )
  assert( *newpkt )
  If *pkt
    CopyStructure( *pkt, *newpkt, tPkt )
  Else
    *newpkt\len=0
  EndIf
  ProcedureReturn *newpkt
EndProcedure

Procedure.i FreePkt( *pkt.tPkt )
  assert( *pkt )
  *pkt\len=0
  FreeMemory( *pkt ) : *pkt=0
  ProcedureReturn *pkt
EndProcedure

Procedure.i prvChkEncode( *dst, *src.tPkt )
  Protected.i srcidx=0, txcnt=0
  Protected.a chksum=0
  PokeB( *dst, $aa ) : *dst+1 : txcnt+1         ;< STX
  While srcidx < *src\len
    Select *src\buf[srcidx]
      Case $aa
        PokeB( *dst, $bb ) : *dst+1 : txcnt+1
        PokeB( *dst, $55 ) : *dst+1 : txcnt+1
      Case $bb
        PokeB( *dst, $bb ) : *dst+1 : txcnt+1
        PokeB( *dst, $44 ) : *dst+1 : txcnt+1
      Case $cc
        PokeB( *dst, $bb ) : *dst+1 : txcnt+1
        PokeB( *dst, $33 ) : *dst+1 : txcnt+1
      Default
        PokeB( *dst, *src\buf[srcidx] )
        *dst+1 : txcnt+1
    EndSelect
    chksum + *src\buf[srcidx] : srcidx+1
  Wend
  Select chksum
    Case $aa
      PokeB( *dst, $bb ) : *dst+1 : txcnt+1
      PokeB( *dst, $55 ) : *dst+1 : txcnt+1
    Case $bb
      PokeB( *dst, $bb ) : *dst+1 : txcnt+1
      PokeB( *dst, $44 ) : *dst+1 : txcnt+1
    Case $cc
      PokeB( *dst, $bb ) : *dst+1 : txcnt+1
      PokeB( *dst, $33 ) : *dst+1 : txcnt+1
    Default
      PokeB( *dst, chksum )
      *dst+1 : txcnt+1
  EndSelect
  PokeB( *dst, $cc ) : *dst+1 : txcnt+1         ;< ETX
  ProcedureReturn txcnt
EndProcedure

Procedure.i prvSend( *self.tChannel, *pkt.tPkt )
  assert( *pkt )
  *self\tx\len = prvChkEncode( @*self\tx\buf, *pkt )
  assert( *self\tx\len >= *pkt\len )
  If *self\dev\Send( @*self\tx\buf, *self\tx\len, @*self\tx\len )
    *self\counts\tx\packets + 1
    *self\counts\tx\bytes + *self\tx\len
    *self\counts\tx\overhead + (*self\tx\len-*pkt\len)
    ProcedureReturn ~0
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure.i prvCounters( *self.tChannel, *counts.tCounters )
  If *counts
    CopyStructure( @*self\counts, *counts, tCounters )
    ProcedureReturn ~0
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure prvThread( *self.tChannel )
  assert( *self )
  Protected *pkt.tPkt=0, prevbyte.a=0, chksum.i=0

  *self\evtHandler( *self, #CHANEVT_START, ElapsedMilliseconds() )
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
                  *pkt\buf[*pkt\len] = byte
                  *pkt\len + 1
                Default           ;< oops
                  *self\counts\rx\escape + 1
              EndSelect
            Else ;< nothing special
              chksum + byte
              *pkt\buf[*pkt\len] = byte
              *pkt\len + 1
            EndIf
          Case $aa ;< technically an error
            *self\counts\rx\overhead + 1
            *self\counts\rx\framing + 1
            *pkt\len = 0
            chksum = 0
          Case $bb ;< skip
            *self\counts\rx\overhead + 1
          Case $cc
            *self\counts\rx\overhead + 2  ;< chk is considered overhead
            chksum - prevbyte             ;< back out the chksum itself
            If (chksum & $ff) = prevbyte
              *self\counts\rx\packets + 1
              *pkt\len - 1                ;< rewind/adjust
              *self\evtHandler( *self, #CHANEVT_RECVPKT, *pkt )
            Else
              *self\counts\rx\chksum + 1
            EndIf
            *pkt = FreePkt( *pkt ) : assert( *pkt = 0 )
          Default
            chksum + byte
            *pkt\buf[*pkt\len] = byte
            *pkt\len + 1
        EndSelect
      Else
        If byte = $aa
          chksum = 0
          *pkt = NewPkt() : assert( *pkt ) : assert( *pkt\len=0 )
          *self\counts\rx\overhead + 1
        EndIf
      EndIf
      prevbyte = byte : idx + 1
    Wend
  Wend
  *self\evtHandler( *self, #CHANEVT_STOP, ElapsedMilliseconds() )
EndProcedure

Procedure.i prvFree( *self.tChannel, *counts.tCounters=0 )
  assert( *self\mutex )
  UnlockMutex( *self\mutex )    ;< signal thread to die
  assert( *self\thread )
  If Not WaitThread( *self\thread, 1000 )
    KillThread( *self\thread )  ;< times up!
  EndIf
  FreeMutex( *self\mutex )
  *self\dev = *self\dev\Free() : assert( *self\dev=0 )
  prvCounters( *self, *counts ) ;< grab final stats on way out if desired
  ClearStructure( *self, tChannel )
  FreeMemory( *self ) : *self=0
  ProcedureReturn *self
EndProcedure

Procedure.i NewChannel( *device.Device::iDevice, evtHandler.tChannelEvent )
  Protected *c.tChannel=0
  If *device And evtHandler
    *c = AllocateMemory( SizeOf(tChannel) )
    *c\vtbl = ?iChannelClass
    *c\evtHandler = evtHandler
    *c\dev = *device
    *c\mutex = CreateMutex() : assert( *c\mutex )
    LockMutex( *c\mutex )
    *c\thread = CreateThread( @prvThread(), *c )
    assert( *c\thread )
  EndIf
  ProcedureReturn *c
EndProcedure
