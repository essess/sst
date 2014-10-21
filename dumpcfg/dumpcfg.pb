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
    Case #CHANEVT_ORPHANPKT
      ;      Debug "#CHANEVT_ORPHANPKT"
      assert( *arg )
      Protected.iPkt *pkt = *arg
      If *pkt\Length() <> 103
        Debug "ORPHAN (Exchange() missed one)"
        ShowMemoryViewer( *pkt\Buffer(), *pkt\Length() )
      EndIf
    Case #CHANEVT_START
      Debug "#CHANEVT_START: "+Str(*arg)+"ms"
    Case #CHANEVT_STOP
      Debug "#CHANEVT_STOP: "+Str(*arg)+"ms"
  EndSelect
  
EndProcedure


Structure tHdr
  flags.a
  cmd.w
EndStructure

Structure tTagHdr Extends tHdr
  tag.a
EndStructure

Structure tLenHdr Extends tHdr
  len.w
EndStructure

Structure tTagLenHdr Extends tHdr
  tag.a
  len.w
EndStructure

Structure tSTFU Extends tTagHdr
  logtype.a
EndStructure

Device::Init()
Define.iChannel *c = NewChannel( NewDevice(@First()), @ChannelEvent() )
If *c
  Define.iPkt *p = NewPkt( SizeOf(tSTFU) ) : assert( *p )
  Define.tSTFU *ovr = *p\Buffer() : assert( *ovr )
  *ovr\flags = $04
  *ovr\cmd = $9401  ;< big endian
  *ovr\logtype = $00
  *p\SetLength( SizeOf(tSTFU) )
  ;ShowMemoryViewer( *p\Buffer(), *p\Length() )
  
  Define.i i
  For i=1 To 300
    Debug "Send Start ["+Str(i)+"]"
    *ovr\tag = i & $ff
    ' start here : flesh out exchange() and test
  Next
  *p = *p\Free() : assert( *p=0 )
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
  Debug "Orphans: "+Str(counts\orphans)
  Debug "Exchanges: "+Str(counts\exchanges)
Else
  Debug "No devices found."
EndIf



