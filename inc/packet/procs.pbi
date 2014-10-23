; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

Procedure.i NewPkt( flags.a=0 )
  Protected.tPkt *self = AllocateMemory( SizeOf(tPkt) ) : assert( *self )
  *self\len = 0
  *self\buf[0] = flags & (#LENGTH|#NACK|#TAG)
  ProcedureReturn *self
EndProcedure

Procedure.i FreePkt( *pkt.tPkt )
  assert( *pkt )
  *pkt\len = 0
  FreeMemory( *pkt ) : *pkt = 0
  ProcedureReturn *pkt
EndProcedure