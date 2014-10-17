; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------
EnableExplicit

IncludePath "..\inc"
XIncludeFile "assert.pbi"
XIncludeFile "device.pbi"
XIncludeFile "channel.pbi"

UseModule Device
UseModule Channel

Procedure.i First( *node.Device::tNode )
  Debug "SerialNumber: "+*node\SerialNumber
  Debug "Description: "+*node\Description
  ProcedureReturn ~0 ;< first
EndProcedure

Procedure ChannelEvent( *c.iChannel, evt.i, *arg )
  
  Select evt
    Case #CHANEVT_RECVPKT
      ;Debug "#CHANEVT_RECVPKT"
      assert( *arg )
      Protected.tPkt *pkt = *arg
      If *pkt\len <> 103
        Debug "*pkt\len: "+Str(*pkt\len)
      EndIf
    Case #CHANEVT_START
      Debug "#CHANEVT_START: "+Str(*arg)+"ms"
    Case #CHANEVT_STOP
      Debug "#CHANEVT_STOP: "+Str(*arg)+"ms"
  EndSelect
  
EndProcedure

Device::Init()
Define.iChannel *c = NewChannel( NewDevice(@First()), @ChannelEvent() )
If *c
  Define.tPkt pkt

  ; fill *buf
  ;*buf = 0x01 0x01 0x94 0x00 0x01 0x00
  pkt\buf[0] = $01
  pkt\buf[1] = $ff;$01
  pkt\buf[2] = $ff;$94
  pkt\buf[3] = $00
  pkt\buf[4] = $01
  pkt\buf[5] = $00
  pkt\len = 6 ;< 1-flags,2-id,2-len,1-cmdarg
              ;  ShowMemoryViewer(*pkt\buf, *pkt\len)
;  Define.i i=0
;  For i=0 To 1000
;    Debug "Send Start ["+Str(i)+"]"
    assert( *c\Send(@pkt) ) ; watch for stream to die
    Debug "Sent"
;    Delay(0)
;  Next

  
  
  Delay(600000)
  Define counts.tCounters
  *c = *c\Free( @counts ) : assert( *c=0 ) ;< device automatically free'd too
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
Else
  Debug "No devices found."
EndIf



