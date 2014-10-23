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
XIncludeFile "packet.pbi"

UseModule Device
UseModule Channel
UseModule Packet

Procedure.i First( *node.tNode )
  Debug "SerialNumber: "+*node\SerialNumber
  Debug "Description: "+*node\Description
  ProcedureReturn ~0 ;< first
EndProcedure

Procedure ChannelEvent( *c.iChannel, evt.i, *arg )
  Select evt
    Case #CHANEVT_ORPHANPKT
;     Debug "#CHANEVT_ORPHANPKT"
    Case #CHANEVT_START
      Debug "#CHANEVT_START: "+Str(*arg)+"ms"
    Case #CHANEVT_STOP
      Debug "#CHANEVT_STOP: "+Str(*arg)+"ms"
  EndSelect
  
EndProcedure
  
Structure tMinHdr
  flags.a
  cmd.w
EndStructure
  
Structure tLenHdr Extends tMinHdr
  len.w
EndStructure
  
Structure tTagHdr Extends tMinHdr
  tag.a
EndStructure
  
Structure tTagLenHdr Extends tTagHdr
  len.w
EndStructure
  
Structure tSTFU Extends tTagHdr
  logtype.a
EndStructure

OpenConsole("Test")
Device::Init()
Define.iChannel *c = NewChannel( NewDevice(@First()), @ChannelEvent() )
If *c
  Define.tPkt *p = NewPkt( #TAG ) : assert( *p )
  Debug "Start Test"
  Define.i i
  For i=1 To 1000
    ; 0 - flags
    *p\buf[1] = $01
    *p\buf[2] = $94
    ; 3 - tag
    *p\buf[4] = $00
    *p\len = 5

    *c\Exchange( *p )
    PrintN("tag[$"+RSet(Hex(PktTag(*p)),2,"0")+"]")
  Next
  Debug "Test Done"
  
  Define counts.tCounters
  *p = FreePkt( *p ) : assert( *p=0 )
  *c = *c\Free( @counts ) : assert( *c=0 ) ;< device automatically free'd too
  
  PrintN("Counts:")
  PrintN("RX Framing Errors: "+Str(counts\rx\framing))
  PrintN("RX Escaping Errors: "+Str(counts\rx\escape))
  PrintN("RX Checksum Errors: "+Str(counts\rx\chksum))
  PrintN("RX Packets: "+Str(counts\rx\packets))
  PrintN("RX Bytes: "+Str(counts\rx\bytes))
  PrintN("RX Overhead: "+Str(counts\rx\overhead))
  PrintN("TX Packets: "+Str(counts\tx\packets))
  PrintN("TX Bytes: "+Str(counts\tx\bytes))
  PrintN("TX Overhead: "+Str(counts\tx\overhead))
  PrintN("Orphans: "+Str(counts\orphans))
  PrintN("Good Exchanges: "+Str(counts\good_exchanges))
  PrintN("Failed Exchanges: "+Str(counts\failed_exchanges))
  PrintN("Test Done")

Else
  Debug "No devices found."
  PrintN("No devices found.")
EndIf
PrintN("Press Return")
Input()
CloseConsole()


