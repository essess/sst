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

Global SN.s
#JSON = 0

Procedure.i First( *node.tNode )
  PrintN("SerialNumber: "+*node\SerialNumber)
  PrintN("Description: "+*node\Description)
  SN = *node\SerialNumber
  ProcedureReturn ~0 ;< first
EndProcedure

Procedure.i InsertLocation( *j, *location.tLocation )
  Protected *v
  
  *j = SetJSONObject(AddJSONMember( *j, LocationIDToString(*location\id) ))
  SetJSONInteger( AddJSONMember( *j, "id" ), *location\id )
  SetJSONInteger( AddJSONMember( *j, "size" ), *location\size )
  
  If InRAM(*location\flags)
    *v = SetJSONObject( AddJSONMember(*j, "ram") )
    SetJSONInteger( AddJSONMember(*v, "page"), *location\page\ram )
    SetJSONInteger( AddJSONMember(*v, "address"), *location\address\ram )
  EndIf
  
  If InFlash(*location\flags)
    *v = SetJSONObject( AddJSONMember(*j, "flash") )
    SetJSONInteger( AddJSONMember(*v, "page"), *location\page\flash )
    SetJSONInteger( AddJSONMember(*v, "address"), *location\address\flash )
  EndIf
  
  ; this information is already recorded implicitly, but capture the rest
  ; of the flags if they exists
  If *location\flags & ~(#BLOCK_HAS_PARENT|#BLOCK_IS_IN_RAM|#BLOCK_IS_IN_FLASH)
    *v = SetJSONArray( AddJSONMember(*j, "flags") )
    If *location\flags & #BLOCK_IS_INDEXABLE
      SetJSONString( AddJSONElement(*v), "#BLOCK_IS_INDEXABLE" )
    EndIf 
    If *location\flags & #BLOCK_IS_READ_ONLY
      SetJSONString( AddJSONElement(*v), "#BLOCK_IS_READ_ONLY" )
    EndIf 
    If *location\flags & #BLOCK_GETS_VERIFIED
      SetJSONString( AddJSONElement(*v), "#BLOCK_GETS_VERIFIED" )
    EndIf 
    If *location\flags & #BLOCK_FOR_BACKUP_RESTORE
      SetJSONString( AddJSONElement(*v), "#BLOCK_FOR_BACKUP_RESTORE" )
    EndIf 
    If *location\flags & #BLOCK_SPARE_FLAG_7
      SetJSONString( AddJSONElement(*v), "#BLOCK_SPARE_FLAG_7" )
    EndIf 
    If *location\flags & #BLOCK_SPARE_FLAG_8
      SetJSONString( AddJSONElement(*v), "#BLOCK_SPARE_FLAG_8" )
    EndIf 
    If *location\flags & #BLOCK_SPARE_FLAG_9
      SetJSONString( AddJSONElement(*v), "#BLOCK_SPARE_FLAG_9" )
    EndIf 
    If *location\flags & #BLOCK_IS_2DUL_TABLE
      SetJSONString( AddJSONElement(*v), "#BLOCK_IS_2DUL_TABLE" )
    EndIf 
    If *location\flags & #BLOCK_SPARE_FLAG_11
      SetJSONString( AddJSONElement(*v), "#BLOCK_SPARE_FLAG_11" )
    EndIf 
    If *location\flags & #BLOCK_IS_2DUS_TABLE
      SetJSONString( AddJSONElement(*v), "#BLOCK_IS_2DUS_TABLE" )
    EndIf 
    If *location\flags & #BLOCK_IS_MAIN_TABLE
      SetJSONString( AddJSONElement(*v), "#BLOCK_IS_MAIN_TABLE" )
    EndIf 
    If *location\flags & #BLOCK_IS_LOOKUP_DATA
      SetJSONString( AddJSONElement(*v), "#BLOCK_IS_LOOKUP_DATA" )
    EndIf  
    If *location\flags & #BLOCK_IS_CONFIGURATION
      SetJSONString( AddJSONElement(*v), "#BLOCK_IS_CONFIGURATION" )
    EndIf  
  EndIf
  
  ProcedureReturn AddJSONMember( *j, "children" )
EndProcedure

Procedure InsertChildren( *j, List Locations.tLocation(), *parent.tLocation )
  assert( *j )
  assert( *parent )
  ForEach Locations() ;< recursivly troll for childrens children too
    If HasParent(Locations()\flags) And Locations()\parent = *parent\id
      PushListPosition( Locations() )
      If JSONType(*j) <> #PB_JSON_Object : *j = SetJSONObject(*j) : EndIf
      InsertChildren( InsertLocation( *j, Locations() ), Locations(), @Locations() )
      PopListPosition( Locations() )
    EndIf
  Next
EndProcedure

Procedure InsertJSONLocationsList( *j, List Locations.tLocation() )
  assert( *j ) : *j = SetJSONObject( *j )
  ForEach Locations()
    If Not HasParent(Locations()\flags) ;< pick out parents and troll for children
      PushListPosition( Locations() )
      InsertChildren( InsertLocation( *j, Locations() ), Locations(), @Locations() )
      PopListPosition( Locations() )
    EndIf
  Next
EndProcedure

Procedure DumpCfg( file.s="dump.json" )
  OpenConsole("Test")
  Device::Init()
  Protected.iChannel *chan = NewChannel( NewDevice(@First()) )
  If *chan And SN
    Protected.tPkt *pkt = NewPkt(), s.String, *v : assert( *pkt )
    SetDatalogType( *chan, *pkt, #DATALOG_OFF )
    
    CreateJSON(#JSON) : assert( IsJSON(#JSON) )
    Protected *j = AddJSONMember( SetJSONObject(JSONValue(#JSON)), SN )
    
    If CMD_FAILURE(GetInterfaceString(*chan, *pkt, @s))
      s\s = "UNKNOWN"
    EndIf
    *j = SetJSONObject(AddJSONMember( SetJSONObject(*j), s\s ))
    
    ; build info ------------------------------------------
    Protected *info = SetJSONObject(AddJSONMember(*j, "info"))
    *v = AddJSONMember( *info, "firmware" )
    If CMD_SUCCESS(GetFirmwareString( *chan, *pkt, @s ))
      SetJSONString( *v, s\s )
    EndIf
    *v = AddJSONMember( *info, "decoder" )
    If CMD_SUCCESS(GetDecoderString( *chan, *pkt, @s ))
      SetJSONString( *v, s\s )
    EndIf
    *v = AddJSONMember( *info, "compiler" )
    If CMD_SUCCESS(GetCompilerString( *chan, *pkt, @s ))
      SetJSONString( *v, s\s )
    EndIf
    *v = AddJSONMember( *info, "built" )
    If CMD_SUCCESS(GetFirmwareBuildDateString( *chan, *pkt, @s ))
      SetJSONString( *v, s\s )
    EndIf
    *v = AddJSONMember( *info, "platform" )
    If CMD_SUCCESS(GetBuildPlatformString( *chan, *pkt, @s ))
      SetJSONString( *v, s\s )
    EndIf
    
    ; dump locations --------------------------------------
    Protected *locations = AddJSONMember(*j, "locations")
    NewList Locations.tLocation()
    If CMD_SUCCESS(GetLocationList( *chan, *pkt, Locations() ))
      ; "locations": { }
      InsertJSONLocationsList( *locations, Locations() )
      ; "locations": { <location>, <location>, ... }
      ;      OR
      ; "locations": { }  ; if empty list
    ; Else
      ; "locations": null ; on command failure
    EndIf
    
    SaveJSON(#JSON, file, #PB_JSON_PrettyPrint)
    FreeJSON( #JSON )
    
    *pkt = FreePkt( *pkt ) : assert( *pkt=0 )
    Define counts.tCounters
    *chan = *chan\Free( @counts ) : assert( *chan=0 ) ;< device automatically free'd too
    
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
    Delay(3000)
  EndIf
  Delay(2000) : PrintN( "Bye" ) : Delay(1000)
  CloseConsole()
EndProcedure

DumpCfg()
