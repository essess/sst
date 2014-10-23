; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

XIncludeFile "device.pbi"
XIncludeFile "packet.pbi"

DeclareModule Channel
  
  UseModule Packet
  UseModule Device
  
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
    orphans.i
    good_exchanges.i
    failed_exchanges.i
  EndStructure
  
  Enumeration        
    #CHANEVT_START      ;< *arg is ms timestamp
    #CHANEVT_ORPHANPKT  ;<      is tPkt
    #CHANEVT_STOP       ;<      is ms timestamp
  EndEnumeration
  
  Interface iChannel
    Send.i( *pkt.tPkt )
    Exchange.i( *pkt.tPkt, timeout.i=30 )
    Counters.i( *counts.tCounters )
    Free.i( *counts.tCounters=0 )
  EndInterface
  Prototype tChannelEvent( *c.iChannel, evt.i, *arg )
  Declare.i NewChannel( *d.iDevice, *evtHandler.tChannelEvent )
  
EndDeclareModule

Module Channel
  IncludeFile "assert.pbi"
  IncludeFile "channel\types.pbi"
  IncludeFile "channel\procs.pbi"
  IncludeFile "channel\classes.pbi"
EndModule