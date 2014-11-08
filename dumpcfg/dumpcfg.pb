; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------
EnableExplicit

IncludePath "..\inc"
XIncludeFile "assert.pbi"
XIncludeFile "device.pbi"   : UseModule Device
XIncludeFile "channel.pbi"  : UseModule Channel
XIncludeFile "packet.pbi"   : UseModule Packet
XIncludeFile "cmd.pbi"      : UseModule Cmd

Procedure.i First( *node.tNode )
  PrintN("SerialNumber: "+*node\SerialNumber)
  PrintN("Description: "+*node\Description)
  ProcedureReturn ~0 ;< first
EndProcedure

Procedure ChannelEvent( *c.iChannel, evt.i, *arg )
  Static start.i
  Select evt
    Case #CHANEVT_ORPHANPKT
      ; filter out logs, leaving the remaining to be true orphans
      Protected *pkt.tPkt = *arg : Swap *pkt\buf[1], *pkt\buf[2]
      If PeekW(@*pkt\buf[1]) <> $0191
        PrintN("#CHANEVT_ORPHANPKT")
;       ShowMemoryViewer( *pkt, *pkt\len )
;       CallDebugger
      Else
;       PrintN(".")
      EndIf
    Case #CHANEVT_START
      PrintN("#CHANEVT_START: "+Str(*arg)+"ms")
      start = *arg
    Case #CHANEVT_STOP
      PrintN("#CHANEVT_STOP: "+Str(*arg)+"ms ["+Str(*arg-start)+"ms]")
  EndSelect
EndProcedure  

Procedure Dump( *l.tLocation )
  PrintN("  ID:     $"+RSet(Hex(*l\id),4,"0")+" "+LocationIDToString(*l\id))
  PrintN("  Flags:  $"+RSet(Hex(*l\flags),4,"0")+" (%"+RSet(Bin(*l\flags),16,"0")+")")
 If *l\flags & #BLOCK_IS_INDEXABLE
  PrintN("                #BLOCK_IS_INDEXABLE")
 EndIf
 If IsReadOnly(*l\flags)
  PrintN("                #BLOCK_IS_READ_ONLY")
 EndIf
 If *l\flags & #BLOCK_GETS_VERIFIED
  PrintN("                #BLOCK_GETS_VERIFIED")
 EndIf
 If *l\flags & #BLOCK_FOR_BACKUP_RESTORE
  PrintN("                #BLOCK_FOR_BACKUP_RESTORE")
 EndIf
 If *l\flags & #BLOCK_SPARE_FLAG_7
  PrintN("                #BLOCK_SPARE_FLAG_7")
 EndIf
 If *l\flags & #BLOCK_SPARE_FLAG_8
  PrintN("                #BLOCK_SPARE_FLAG_8")
 EndIf
 If *l\flags & #BLOCK_SPARE_FLAG_9
  PrintN("                #BLOCK_SPARE_FLAG_9")
 EndIf
 If *l\flags & #BLOCK_SPARE_FLAG_10
  PrintN("                #BLOCK_SPARE_FLAG_10")
 EndIf
 If *l\flags & #BLOCK_SPARE_FLAG_11
  PrintN("                #BLOCK_SPARE_FLAG_11")
 EndIf
 If *l\flags & #BLOCK_IS_2DUS_TABLE
  PrintN("                #BLOCK_IS_2DUS_TABLE")
 EndIf
 If *l\flags & #BLOCK_IS_MAIN_TABLE
  PrintN("                #BLOCK_IS_MAIN_TABLE")
 EndIf
 If *l\flags & #BLOCK_IS_LOOKUP_DATA
  PrintN("                #BLOCK_IS_LOOKUP_DATA")
 EndIf
 If IsConfiguration(*l\flags)
  PrintN("                #BLOCK_IS_CONFIGURATION")
 EndIf
 If HasParent(*l\flags) 
  PrintN("  Parent: $"+RSet(Hex(*l\parent),4,"0"))
 EndIf
 If InRAM(*l\flags)
  PrintN("  RAM:    $"+RSet(Hex(*l\page\ram),2,"0")+"."+RSet(Hex(*l\address\ram),4,"0"))
 EndIf
 If InFlash(*l\flags) 
  PrintN("  Flash:  $"+RSet(Hex(*l\page\flash),2,"0")+"."+RSet(Hex(*l\address\flash),4,"0"))
 EndIf
  PrintN("  Size:   $"+RSet(Hex(*l\size),4,"0")+" ("+Str(*l\size)+")")
EndProcedure

OpenConsole("Test")
Device::Init()
Define.iChannel *chan = NewChannel( NewDevice(@First()), @ChannelEvent() )
If *chan
  Define.tPkt *pkt = NewPkt( #TAG ) : assert( *pkt )
  
  NewList Locations.tLocation()
  Define *l.tLocation
  
  ; purebasic's console clips, so you might miss the first few tables
  ; and unfortunately, you can't redirect for some reason. with enough
  ; bitching, I will spend the time on a more timeless solution
  ; BUT YOU MUST LET ME KNOW FIRST IF YOU FIND THIS TOOL USEFUL!
  
  If CMD_FAILURE(SetDatalogType( *chan, *pkt, #DATALOG_OFF ))
    PrintN( "CMD_FAILURE(SetDatalogType( *chan, *pkt, #DATALOG_OFF ))" )
  EndIf
  
  Define loops.i = 1
  While loops
    If CMD_FAILURE(CreateLocationsList( *chan, *pkt, Locations() ))
      PrintN( "CMD_FAILURE(CreateLocationsList( *chan, *pkt, Locations() ))" )
    EndIf
    PrintN( "Locations(): "+Str(ListSize(Locations())) )
    ForEach Locations() 
      If CMD_FAILURE(GetLocationDetails( *chan, *pkt, @Locations() ))
        PrintN( "CMD_FAILURE(GetLocationDetails( *chan, *pkt, @Locations() ))" )
      EndIf
      PrintN( "Index["+Str(ListIndex(Locations()))+"]" )
      Dump( Locations() )
    Next
    loops-1
  Wend
  
  If CMD_FAILURE(SetDatalogType( *chan, *pkt, #DATALOG_BASIC ))
    PrintN( "CMD_FAILURE(SetDatalogType( *chan, *pkt, #DATALOG_BASIC ))" )
  EndIf

  Define counts.tCounters
  *pkt = FreePkt( *pkt ) : assert( *pkt=0 )
  *chan = *chan\Free( @counts ) : assert( *chan=0 ) ;< device automatically free'd too
                                                    ;  is this actually desirable ?
  PrintN("RX Framing Errors: "+Str(counts\rx\framing))
  PrintN("   Escaping Errors: "+Str(counts\rx\escape))
  PrintN("   Checksum Errors: "+Str(counts\rx\chksum))
  PrintN("   Packets: "+Str(counts\rx\packets))
  PrintN("   Bytes: "+Str(counts\rx\bytes))
  PrintN("   Overhead: "+Str(counts\rx\overhead))
  PrintN("TX Packets: "+Str(counts\tx\packets))
  PrintN("   Bytes: "+Str(counts\tx\bytes))
  PrintN("   Overhead: "+Str(counts\tx\overhead))
  PrintN("Orphans: "+Str(counts\orphans))
  PrintN("Good Exchanges: "+Str(counts\good_exchanges))
  PrintN("Failed Exchanges: "+Str(counts\failed_exchanges))

Else
  PrintN("No devices found.")
EndIf
PrintN("Press Return")
Input()
CloseConsole()


