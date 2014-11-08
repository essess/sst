; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

EnableExplicit
XIncludeFile "channel.pbi"
XIncludeFile "packet.pbi"

DeclareModule Cmd
  
  UseModule Channel
  UseModule Packet
  
  Enumeration ;< SetDataLogType()
    #DATALOG_OFF        = $00
    #DATALOG_BASIC      = $01
    #DATALOG_SCRATCHPAD = $02
    #DATALOG_STRUCTS    = $03
    #DATALOG_POSITION   = $04
    #DATALOG_BLOCKBYTES = $05
    #DATALOG_BLOCKWORDS = $06
    #DATALOG_BLOCKLONGS = $07
    #DATALOG_STREAMBYTE = $08
    #DATALOG_STREAMWORD = $09
    #DATALOG_STREAMLONG = $0A
  EndEnumeration
  
  Structure tPage
    ram.a
    flash.a
  EndStructure
  
  Structure tAddress
    ram.u
    flash.u
  EndStructure
  
  Structure tLocation
    id.u
    flags.u
    parent.u
    page.tPage
    address.tAddress
    size.u
  EndStructure
  
  Enumeration ;< location id flags
    #BLOCK_HAS_PARENT         = (1<<0)
    #BLOCK_IS_IN_RAM          = (1<<1)
    #BLOCK_IS_IN_FLASH        = (1<<2)
    #BLOCK_IS_INDEXABLE       = (1<<3)
    #BLOCK_IS_READ_ONLY       = (1<<4)
    #BLOCK_GETS_VERIFIED      = (1<<5)
    #BLOCK_FOR_BACKUP_RESTORE = (1<<6)
    #BLOCK_SPARE_FLAG_7       = (1<<7)
    #BLOCK_SPARE_FLAG_8       = (1<<8)
    #BLOCK_SPARE_FLAG_9       = (1<<9)
    #BLOCK_SPARE_FLAG_10      = (1<<10)
    #BLOCK_SPARE_FLAG_11      = (1<<11)
    #BLOCK_IS_2DUS_TABLE      = (1<<12)
    #BLOCK_IS_MAIN_TABLE      = (1<<13)
    #BLOCK_IS_LOOKUP_DATA     = (1<<14)
    #BLOCK_IS_CONFIGURATION   = (1<<15)
  EndEnumeration
  
  Enumeration ;< location id descriptions
    #VE_TABLE_MAIN_LOCATION_ID                            = $0000
    #VE_TABLE_MAIN2_LOCATION_ID                           = $0001
    #VE_TABLE_SECONDARY_LOCATION_ID                       = $0002
    #VE_TABLE_SECONDARY2_LOCATION_ID                      = $0003
    #AIRFLOW_TABLE_LOCATION_ID                            = $0004
    #AIRFLOW_TABLE2_LOCATION_ID                           = $0005
    #LAMBDA_TABLE_LOCATION_ID                             = $0006
    #LAMBDA_TABLE2_LOCATION_ID                            = $0007
    #IGNITION_ADVANCE_TABLE_MAIN_LOCATION_ID              = $0008
    #IGNITION_ADVANCE_TABLE_MAIN2_LOCATION_ID             = $0009
    #IGNITION_ADVANCE_TABLE_SECONDARY_LOCATION_ID         = $000A
    #IGNITION_ADVANCE_TABLE_SECONDARY2_LOCATION_ID        = $000B
    #INJECTION_ADVANCE_TABLE_MAIN_LOCATION_ID             = $000C
    #INJECTION_ADVANCE_TABLE_MAIN2_LOCATION_ID            = $000D
    #INJECTION_ADVANCE_TABLE_SECONDARY_LOCATION_ID        = $000E
    #INJECTION_ADVANCE_TABLE_SECONDARY2_LOCATION_ID       = $000F
    #MAIN_TABLE_TWO_D_TABLE_US_BORDER                     = $0100
    #DWELL_DESIRED_VERSUS_VOLTAGE_TABLE_LOCATION_ID       = $0100
    #DWELL_DESIRED_VERSUS_VOLTAGE_TABLE2_LOCATION_ID      = $0101
    #INJECTOR_DEAD_TIME_TABLE_LOCATION_ID                 = $0102
    #INJECTOR_DEAD_TIME_TABLE2_LOCATION_ID                = $0103
    #POST_START_ENRICHMENT_TABLE_LOCATION_ID              = $0104
    #POST_START_ENRICHMENT_TABLE2_LOCATION_ID             = $0105
    #ENGINE_TEMP_ENRICHMENT_TABLE_FIXED_LOCATION_ID       = $0106
    #ENGINE_TEMP_ENRICHMENT_TABLE_FIXED2_LOCATION_ID      = $0107
    #PRIMING_VOLUME_TABLE_LOCATION_ID                     = $0108
    #PRIMING_VOLUME_TABLE2_LOCATION_ID                    = $0109
    #ENGINE_TEMP_ENRICHMENT_TABLE_PERCENT_LOCATION_ID     = $010A
    #ENGINE_TEMP_ENRICHMENT_TABLE_PERCENT2_LOCATION_ID    = $010B
    #DWELL_VERSUS_RPM_TABLE_LOCATION_ID                   = $010C
    #DWELL_VERSUS_RPM_TABLE2_LOCATION_ID                  = $010D
    #BLEND_VERSUS_RPM_TABLE_LOCATION_ID                   = $010E
    #BLEND_VERSUS_RPM_TABLE2_LOCATION_ID                  = $010F
    #MAF_VERSUS_VOLTAGE_TABLE_LOCATION_ID                 = $011F
    #SMALL_TABLES_A_LOCATION_ID                           = $3000
    #SMALL_TABLES_A2_LOCATION_ID                          = $3001
    #SMALL_TABLES_B_LOCATION_ID                           = $3002
    #SMALL_TABLES_B2_LOCATION_ID                          = $3003
    #SMALL_TABLES_C_LOCATION_ID                           = $3004
    #SMALL_TABLES_C2_LOCATION_ID                          = $3005
    #SMALL_TABLES_D_LOCATION_ID                           = $3006
    #SMALL_TABLES_D2_LOCATION_ID                          = $3007
    #FILLER_A_LOCATION_ID                                 = $4000
    #FILLER_A2_LOCATION_ID                                = $4001
    #FILLER_B_LOCATION_ID                                 = $4002
    #FILLER_B2_LOCATION_ID                                = $4003
    #FILLER_C_LOCATION_ID                                 = $4004
    #FILLER_C2_LOCATION_ID                                = $4005
    #FILLER_D_LOCATION_ID                                 = $4006
    #FILLER_D2_LOCATION_ID                                = $4007
    #IAT_TRANSFER_TABLE_LOCATION_ID                       = $8000
    #CHT_TRANSFER_TABLE_LOCATION_ID                       = $8001
    #MAF_TRANSFER_TABLE_LOCATION_ID                       = $8002
    #TEST_TRANSFER_TABLE_LOCATION_ID                      = $8003
    #LOGGING_SETTINGS_LOCATION_ID                         = $9000
    #LOGGING_SETTINGS2_LOCATION_ID                        = $9001
    #FIXED_CONFIG1_LOCATION_ID                            = $A000
    #FIXED_CONFIG2_LOCATION_ID                            = $A001
    #ENGINE_SETTINGS_LOCATION_ID                          = $C000
    #SERIAL_SETTINGS_LOCATION_ID                          = $C001
    #COARSE_BB_SETTINGS_LOCATION_ID                       = $C002
    #SCHEDULING_SETTINGS_LOCATION_ID                      = $C003
    #CUT_AND_LIMITER_SETTINGS_LOCATION_ID                 = $C004
    #SIMPLE_GPIO_SETTINGS_LOCATION_ID                     = $C005
    #USER_TEXT_FIELD_LOCATION_ID                          = $C100
    #SENSOR_SOURCES_LOCATION_ID                           = $C020
    #SENSOR_PRESETS_LOCATION_ID                           = $C021
    #SENSOR_RANGES_LOCATION_ID                            = $C022
    #SENSOR_SETTINGS_LOCATION_ID                          = $C023
    #ALGORITHM_SETTINGS_LOCATION_ID                       = $C024
    #INPUT_OUTPUT_SETTINGS_LOCATION_ID                    = $C025
    #DECODER_SETTINGS_LOCATION_ID                         = $C026
    #USER_TEXT_FIELD2_LOCATION_ID                         = $C101
    #ADC_REGISTERS_LOCATION_ID                            = $F000
    #CORE_VARS_LOCATION_ID                                = $F001
    #DERIVED_VARS_LOCATION_ID                             = $F002
    #KEY_USER_DEBUG_LOCATION_ID                           = $F003
    #COUNTERS_LOCATION_ID                                 = $F004
    #CLOCKS_LOCATION_ID                                   = $F005
    #FLAGGABLES_LOCATION_ID                               = $F006
    #FLAGGABLES2_LOCATION_ID                              = $F007
  EndEnumeration
  
  Enumeration
    #CMDERR_OK      = 0
    #CMDERR_EXCFAIL
    #CMDERR_BADLEN
    #CMDERR_FWBUG
    #CMDERR_UNKNOWN = ~#CMDERR_OK
  EndEnumeration
  
  Declare.i GetInterfaceString( *c.iChannel, *p.tPkt, *s.String )
  Declare.i GetFirmwareString( *c.iChannel, *p.tPkt, *s.String )
  Declare.i GetDecoderString( *c.iChannel, *p.tPkt, *s.String )
  Declare.i GetFirmwareBuildDateString( *c.iChannel, *p.tPkt, *s.String )
  Declare.i GetCompilerString( *c.iChannel, *p.tPkt, *s.String )
  Declare.i GetBuildPlatformString( *c.iChannel, *p.tPkt, *s.String )
  Declare.i GetMaxPktLength( *c.iChannel, *p.tPkt, *len )
  Declare.i Echo( *c.iChannel, *p.tPkt, *buf, len.i )  ;< #CMDERR_FWBUG
  Declare.i DoSoftReset( *c.iChannel, *p.tPkt, wait.i=20 )
  Declare.i DoHardReset( *c.iChannel, *p.tPkt, wait.i=20 )
  Declare.i DoReInit( *c.iChannel, *p.tPkt )
  Declare.i DoClearCountersAndFlags( *c.iChannel, *p.tPkt )
  Declare.i SetDatalogType( *c.iChannel, *p.tPkt, type.a )
  Declare.i CreateLocationsList( *c.iChannel, *p.tPkt, List Locations.tLocation() )
  Declare.i GetLocationDetails( *c.iChannel, *p.tPkt, *l.tLocation )
  
  Declare.s LocationIDToString( id.u )
  
EndDeclareModule

Macro CMD_SUCCESS( e )
  (e = Cmd::#CMDERR_OK)
EndMacro
    
Macro CMD_FAILURE( e )
  (Not CMD_SUCCESS(e))
EndMacro

Macro HasParent( f )
  (f & Cmd::#BLOCK_HAS_PARENT)
EndMacro

Macro InRAM( f )
  (f & Cmd::#BLOCK_IS_IN_RAM)
EndMacro

Macro InFlash( f )
  (f & Cmd::#BLOCK_IS_IN_FLASH)
EndMacro

Macro IsConfiguration( f )
  (f & Cmd::#BLOCK_IS_CONFIGURATION)
EndMacro

Macro IsReadOnly( f )
  (f & Cmd::#BLOCK_IS_READ_ONLY)
EndMacro

Module Cmd
  UseModule Channel
  UseModule Packet
  IncludeFile "assert.pbi"
  IncludeFile "cmd\types.pbi"
  IncludeFile "cmd\procs.pbi"
  IncludeFile "cmd\classes.pbi"
EndModule