; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

XIncludeFile "device.pbi"

DeclareModule Channel
  
  #PKT_BUFSIZE = (8*1024)
  Structure tPkt
    buf.a[#PKT_BUFSIZE]
    len.i
  EndStructure
  
  Declare.i NewPkt( *pkt.tPkt=0 ) ;< optional copy to new
  Declare.i FreePkt( *pkt.tPkt )  ;< destroy pkt
  
  Structure tTX
    packets.i
    bytes.i
    overhead.i
  EndStructure  
  
  Structure tRX Extends tTX
    framing.i
    escape.i
    chksum.i
  EndStructure
  
  Structure tCounters
    tx.tTX
    rx.tRX
  EndStructure
  
  Enumeration        
    #CHANEVT_START      ;< *arg is ms timestamp
    #CHANEVT_RECVPKT    ;<      is tPkt
    #CHANEVT_STOP       ;<      is ms timestamp
  EndEnumeration
  
  Interface iChannel
    Send.i( *pkt.tPkt )
    Counters.i( *counts.tCounters )
    Free.i( *counts.tCounters=0 )
  EndInterface
  Prototype tChannelEvent( *c.iChannel, evt.i, *arg )
  Declare.i NewChannel( *device.Device::iDevice, evtHandler.tChannelEvent )
  
EndDeclareModule

Module Channel
  
  IncludeFile "assert.pbi"
  IncludeFile "channel\types.pbi"
  IncludeFile "channel\procs.pbi"
  IncludeFile "channel\classes.pbi"
  
EndModule