; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

Procedure.s LocationIDToString( id.u )
  Select id
    Case #VE_TABLE_MAIN_LOCATION_ID
      ProcedureReturn "#VE_TABLE_MAIN_LOCATION_ID"
    Case #VE_TABLE_MAIN2_LOCATION_ID
      ProcedureReturn "#VE_TABLE_MAIN2_LOCATION_ID"
    Case #VE_TABLE_SECONDARY_LOCATION_ID
      ProcedureReturn "#VE_TABLE_SECONDARY_LOCATION_ID"
    Case #VE_TABLE_SECONDARY2_LOCATION_ID
      ProcedureReturn "#VE_TABLE_SECONDARY2_LOCATION_ID"
    Case #AIRFLOW_TABLE_LOCATION_ID
      ProcedureReturn "#AIRFLOW_TABLE_LOCATION_ID"
    Case #AIRFLOW_TABLE2_LOCATION_ID
      ProcedureReturn "#AIRFLOW_TABLE2_LOCATION_ID"
    Case #LAMBDA_TABLE_LOCATION_ID
      ProcedureReturn "#LAMBDA_TABLE_LOCATION_ID"
    Case #LAMBDA_TABLE2_LOCATION_ID
      ProcedureReturn "#LAMBDA_TABLE2_LOCATION_ID"
    Case #IGNITION_ADVANCE_TABLE_MAIN_LOCATION_ID
      ProcedureReturn "#IGNITION_ADVANCE_TABLE_MAIN_LOCATION_ID"
    Case #IGNITION_ADVANCE_TABLE_MAIN2_LOCATION_ID
      ProcedureReturn "#IGNITION_ADVANCE_TABLE_MAIN2_LOCATION_ID"
    Case #IGNITION_ADVANCE_TABLE_SECONDARY_LOCATION_ID
      ProcedureReturn "#IGNITION_ADVANCE_TABLE_SECONDARY_LOCATION_ID"
    Case #IGNITION_ADVANCE_TABLE_SECONDARY2_LOCATION_ID
      ProcedureReturn "#IGNITION_ADVANCE_TABLE_SECONDARY2_LOCATION_ID"
    Case #INJECTION_ADVANCE_TABLE_MAIN_LOCATION_ID
      ProcedureReturn "#INJECTION_ADVANCE_TABLE_MAIN_LOCATION_ID"
    Case #INJECTION_ADVANCE_TABLE_MAIN2_LOCATION_ID
      ProcedureReturn "#INJECTION_ADVANCE_TABLE_MAIN2_LOCATION_ID"
    Case #INJECTION_ADVANCE_TABLE_SECONDARY_LOCATION_ID
      ProcedureReturn "#INJECTION_ADVANCE_TABLE_SECONDARY_LOCATION_ID"
    Case #INJECTION_ADVANCE_TABLE_SECONDARY2_LOCATION_ID
      ProcedureReturn "#INJECTION_ADVANCE_TABLE_SECONDARY2_LOCATION_ID"
    Case #DWELL_DESIRED_VERSUS_VOLTAGE_TABLE_LOCATION_ID
      ProcedureReturn "#DWELL_DESIRED_VERSUS_VOLTAGE_TABLE_LOCATION_ID"
    Case #DWELL_DESIRED_VERSUS_VOLTAGE_TABLE2_LOCATION_ID
      ProcedureReturn "#DWELL_DESIRED_VERSUS_VOLTAGE_TABLE2_LOCATION_ID"
    Case #INJECTOR_DEAD_TIME_TABLE_LOCATION_ID
      ProcedureReturn "#INJECTOR_DEAD_TIME_TABLE_LOCATION_ID"
    Case #INJECTOR_DEAD_TIME_TABLE2_LOCATION_ID
      ProcedureReturn "#INJECTOR_DEAD_TIME_TABLE2_LOCATION_ID"
    Case #POST_START_ENRICHMENT_TABLE_LOCATION_ID
      ProcedureReturn "#POST_START_ENRICHMENT_TABLE_LOCATION_ID"
    Case #POST_START_ENRICHMENT_TABLE2_LOCATION_ID
      ProcedureReturn "#POST_START_ENRICHMENT_TABLE2_LOCATION_ID"
    Case #ENGINE_TEMP_ENRICHMENT_TABLE_FIXED_LOCATION_ID
      ProcedureReturn "#ENGINE_TEMP_ENRICHMENT_TABLE_FIXED_LOCATION_ID"
    Case #ENGINE_TEMP_ENRICHMENT_TABLE_FIXED2_LOCATION_ID
      ProcedureReturn "#ENGINE_TEMP_ENRICHMENT_TABLE_FIXED2_LOCATION_ID"
    Case #PRIMING_VOLUME_TABLE_LOCATION_ID
      ProcedureReturn "#PRIMING_VOLUME_TABLE_LOCATION_ID"
    Case #PRIMING_VOLUME_TABLE2_LOCATION_ID
      ProcedureReturn "#PRIMING_VOLUME_TABLE2_LOCATION_ID"
    Case #ENGINE_TEMP_ENRICHMENT_TABLE_PERCENT_LOCATION_ID
      ProcedureReturn "#ENGINE_TEMP_ENRICHMENT_TABLE_PERCENT_LOCATION_ID"
    Case #ENGINE_TEMP_ENRICHMENT_TABLE_PERCENT2_LOCATION_ID
      ProcedureReturn "#ENGINE_TEMP_ENRICHMENT_TABLE_PERCENT2_LOCATION_ID"
    Case #DWELL_VERSUS_RPM_TABLE_LOCATION_ID
      ProcedureReturn "#DWELL_VERSUS_RPM_TABLE_LOCATION_ID"
    Case #DWELL_VERSUS_RPM_TABLE2_LOCATION_ID
      ProcedureReturn "#DWELL_VERSUS_RPM_TABLE2_LOCATION_ID"
    Case #BLEND_VERSUS_RPM_TABLE_LOCATION_ID
      ProcedureReturn "#BLEND_VERSUS_RPM_TABLE_LOCATION_ID"
    Case #BLEND_VERSUS_RPM_TABLE2_LOCATION_ID
      ProcedureReturn "#BLEND_VERSUS_RPM_TABLE2_LOCATION_ID"
    Case #MAF_VERSUS_VOLTAGE_TABLE_LOCATION_ID
      ProcedureReturn "#MAF_VERSUS_VOLTAGE_TABLE_LOCATION_ID"
    Case #SMALL_TABLES_A_LOCATION_ID
      ProcedureReturn "#SMALL_TABLES_A_LOCATION_ID"
    Case #SMALL_TABLES_A2_LOCATION_ID
      ProcedureReturn "#SMALL_TABLES_A2_LOCATION_ID"
    Case #SMALL_TABLES_B_LOCATION_ID
      ProcedureReturn "#SMALL_TABLES_B_LOCATION_ID"
    Case #SMALL_TABLES_B2_LOCATION_ID
      ProcedureReturn "#SMALL_TABLES_B2_LOCATION_ID"
    Case #SMALL_TABLES_C_LOCATION_ID
      ProcedureReturn "#SMALL_TABLES_C_LOCATION_ID"
    Case #SMALL_TABLES_C2_LOCATION_ID
      ProcedureReturn "#SMALL_TABLES_C2_LOCATION_ID"
    Case #SMALL_TABLES_D_LOCATION_ID
      ProcedureReturn "#SMALL_TABLES_D_LOCATION_ID"
    Case #SMALL_TABLES_D2_LOCATION_ID
      ProcedureReturn "#SMALL_TABLES_D2_LOCATION_ID"
    Case #FILLER_A_LOCATION_ID
      ProcedureReturn "#FILLER_A_LOCATION_ID"
    Case #FILLER_A2_LOCATION_ID
      ProcedureReturn "#FILLER_A2_LOCATION_ID"
    Case #FILLER_B_LOCATION_ID
      ProcedureReturn "#FILLER_B_LOCATION_ID"
    Case #FILLER_B2_LOCATION_ID
      ProcedureReturn "#FILLER_B2_LOCATION_ID"
    Case #FILLER_C_LOCATION_ID
      ProcedureReturn "#FILLER_C_LOCATION_ID"
    Case #FILLER_C2_LOCATION_ID
      ProcedureReturn "#FILLER_C2_LOCATION_ID"
    Case #FILLER_D_LOCATION_ID
      ProcedureReturn "#FILLER_D_LOCATION_ID"
    Case #FILLER_D2_LOCATION_ID
      ProcedureReturn "#FILLER_D2_LOCATION_ID"
    Case #IAT_TRANSFER_TABLE_LOCATION_ID
      ProcedureReturn "#IAT_TRANSFER_TABLE_LOCATION_ID"
    Case #CHT_TRANSFER_TABLE_LOCATION_ID
      ProcedureReturn "#CHT_TRANSFER_TABLE_LOCATION_ID"
    Case #MAF_TRANSFER_TABLE_LOCATION_ID
      ProcedureReturn "#MAF_TRANSFER_TABLE_LOCATION_ID"
    Case #TEST_TRANSFER_TABLE_LOCATION_ID
      ProcedureReturn "#TEST_TRANSFER_TABLE_LOCATION_ID"
    Case #LOGGING_SETTINGS_LOCATION_ID
      ProcedureReturn "#LOGGING_SETTINGS_LOCATION_ID"
    Case #LOGGING_SETTINGS2_LOCATION_ID
      ProcedureReturn "#LOGGING_SETTINGS2_LOCATION_ID"
    Case #FIXED_CONFIG1_LOCATION_ID
      ProcedureReturn "#FIXED_CONFIG1_LOCATION_ID"
    Case #FIXED_CONFIG2_LOCATION_ID
      ProcedureReturn "#FIXED_CONFIG2_LOCATION_ID"
    Case #ENGINE_SETTINGS_LOCATION_ID
      ProcedureReturn "#ENGINE_SETTINGS_LOCATION_ID"
    Case #SERIAL_SETTINGS_LOCATION_ID
      ProcedureReturn "#SERIAL_SETTINGS_LOCATION_ID"
    Case #COARSE_BB_SETTINGS_LOCATION_ID
      ProcedureReturn "#COARSE_BB_SETTINGS_LOCATION_ID"
    Case #SCHEDULING_SETTINGS_LOCATION_ID
      ProcedureReturn "#SCHEDULING_SETTINGS_LOCATION_ID"
    Case #CUT_AND_LIMITER_SETTINGS_LOCATION_ID
      ProcedureReturn "#CUT_AND_LIMITER_SETTINGS_LOCATION_ID"
    Case #SIMPLE_GPIO_SETTINGS_LOCATION_ID
      ProcedureReturn "#SIMPLE_GPIO_SETTINGS_LOCATION_ID"
    Case #USER_TEXT_FIELD_LOCATION_ID
      ProcedureReturn "#USER_TEXT_FIELD_LOCATION_ID"
    Case #SENSOR_SOURCES_LOCATION_ID
      ProcedureReturn "#SENSOR_SOURCES_LOCATION_ID"
    Case #SENSOR_PRESETS_LOCATION_ID
      ProcedureReturn "#SENSOR_PRESETS_LOCATION_ID"
    Case #SENSOR_RANGES_LOCATION_ID
      ProcedureReturn "#SENSOR_RANGES_LOCATION_ID"
    Case #SENSOR_SETTINGS_LOCATION_ID
      ProcedureReturn "#SENSOR_SETTINGS_LOCATION_ID"
    Case #ALGORITHM_SETTINGS_LOCATION_ID
      ProcedureReturn "#ALGORITHM_SETTINGS_LOCATION_ID"
    Case #INPUT_OUTPUT_SETTINGS_LOCATION_ID
      ProcedureReturn "#INPUT_OUTPUT_SETTINGS_LOCATION_ID"
    Case #DECODER_SETTINGS_LOCATION_ID
      ProcedureReturn "#DECODER_SETTINGS_LOCATION_ID"
    Case #USER_TEXT_FIELD2_LOCATION_ID
      ProcedureReturn "#USER_TEXT_FIELD2_LOCATION_ID"
    Case #ADC_REGISTERS_LOCATION_ID
      ProcedureReturn "#ADC_REGISTERS_LOCATION_ID"
    Case #CORE_VARS_LOCATION_ID
      ProcedureReturn "#CORE_VARS_LOCATION_ID"
    Case #DERIVED_VARS_LOCATION_ID
      ProcedureReturn "#DERIVED_VARS_LOCATION_ID"
    Case #KEY_USER_DEBUG_LOCATION_ID
      ProcedureReturn "#KEY_USER_DEBUG_LOCATION_ID"
    Case #COUNTERS_LOCATION_ID
      ProcedureReturn "#COUNTERS_LOCATION_ID"
    Case #CLOCKS_LOCATION_ID
      ProcedureReturn "#CLOCKS_LOCATION_ID"
    Case #FLAGGABLES_LOCATION_ID
      ProcedureReturn "#FLAGGABLES_LOCATION_ID"
    Case #FLAGGABLES2_LOCATION_ID
      ProcedureReturn "#FLAGGABLES2_LOCATION_ID"
  EndSelect
  ProcedureReturn "Unknown"
EndProcedure

Procedure.i prvGetString( *chan.iChannel, *pkt.tPkt, *s.String )
  Protected retval.i = #CMDERR_EXCFAIL
  If *chan\Exchange(*pkt) And Not PktIsNack(*pkt)
    assert( PktHasTag(*pkt) )
    Protected strlen.i=-1, *strbuf=@*pkt\buf[4]
    If PktHasLength(*pkt)
      Swap *pkt\buf[4], *pkt\buf[5]
      Protected len.i = PeekU(@*pkt\buf[4])
      If len <= #BUFSIZE And len > 0
        strlen = len-1 ;< not including terminator
      EndIf
      *strbuf = @*pkt\buf[6]
    EndIf
    *s\s = PeekS(*strbuf, strlen, #PB_Ascii)
    retval = #CMDERR_OK
  EndIf
  ProcedureReturn retval
EndProcedure

Procedure.i GetInterfaceString( *chan.iChannel, *pkt.tPkt, *s.String )
  assert( *chan )
  assert( *pkt )
  assert( *s )
    
  *pkt\buf[0] =  #TAG
  *pkt\buf[1] = (#REQUEST_INTERFACE_VERSION>>8) & $FF
  *pkt\buf[2] =  #REQUEST_INTERFACE_VERSION     & $FF
  *pkt\len    =  4

  ProcedureReturn prvGetString( *chan, *pkt, *s )
EndProcedure

Procedure.i GetFirmwareString( *chan.iChannel, *pkt.tPkt, *s.String )
  assert( *chan )
  assert( *pkt )
  assert( *s )
    
  *pkt\buf[0] =  #TAG
  *pkt\buf[1] = (#REQUEST_FIRMWARE_VERSION>>8) & $FF
  *pkt\buf[2] =  #REQUEST_FIRMWARE_VERSION     & $FF
  *pkt\len    =  4

  ProcedureReturn prvGetString( *chan, *pkt, *s )
EndProcedure

Procedure.i GetDecoderString( *chan.iChannel, *pkt.tPkt, *s.String )
  assert( *chan )
  assert( *pkt )
  assert( *s )
    
  *pkt\buf[0] =  #TAG
  *pkt\buf[1] = (#REQUEST_DECODER_NAME>>8) & $FF
  *pkt\buf[2] =  #REQUEST_DECODER_NAME     & $FF
  *pkt\len    =  4

  ProcedureReturn prvGetString( *chan, *pkt, *s )
EndProcedure

Procedure.i GetFirmwareBuildDateString( *chan.iChannel, *pkt.tPkt, *s.String )
  
  assert( *chan )
  assert( *pkt )
  assert( *s )
    
  *pkt\buf[0] =  #TAG
  *pkt\buf[1] = (#REQUEST_FIRMWARE_BUILD_DATE>>8) & $FF
  *pkt\buf[2] =  #REQUEST_FIRMWARE_BUILD_DATE     & $FF
  *pkt\len    =  4

  ProcedureReturn prvGetString( *chan, *pkt, *s )
EndProcedure

Procedure.i GetCompilerString( *chan.iChannel, *pkt.tPkt, *s.String )
  assert( *chan )
  assert( *pkt )
  assert( *s )
    
  *pkt\buf[0] =  #TAG
  *pkt\buf[1] = (#REQUEST_COMPILER_VERSION>>8) & $FF
  *pkt\buf[2] =  #REQUEST_COMPILER_VERSION     & $FF
  *pkt\len    =  4

  ProcedureReturn prvGetString( *chan, *pkt, *s )
EndProcedure

Procedure.i GetBuildPlatformString( *chan.iChannel, *pkt.tPkt, *s.String )
  
  assert( *chan )
  assert( *pkt )
  assert( *s )
    
  *pkt\buf[0] =  #TAG
  *pkt\buf[1] = (#REQUEST_OPERATING_SYSTEM>>8) & $FF
  *pkt\buf[2] =  #REQUEST_OPERATING_SYSTEM     & $FF
  *pkt\len    =  4

  ProcedureReturn prvGetString( *chan, *pkt, *s )
EndProcedure

Procedure.i GetMaxPktLength( *chan.iChannel, *pkt.tPkt, *len )
  
  assert( *chan )
  assert( *pkt )
  assert( *len )
    
  *pkt\buf[0] =  #TAG
  *pkt\buf[1] = (#REQUEST_MAX_PACKET_SIZE>>8) & $FF
  *pkt\buf[2] =  #REQUEST_MAX_PACKET_SIZE     & $FF
  *pkt\len    =  4
  
  PokeI( *len, 0 )
  Protected.i retval = #CMDERR_EXCFAIL
  If *chan\Exchange(*pkt) And Not PktIsNack(*pkt)
    assert( PktHasTag(*pkt) )
    Swap *pkt\buf[1], *pkt\buf[2] : assert( PeekU(@*pkt\buf[1]) = #REQUEST_MAX_PACKET_SIZE+1 )
    assert( Not PktHasLength(*pkt) )
    Swap *pkt\buf[4], *pkt\buf[5]
    PokeI( *len, PeekU(@*pkt\buf[4]) )
    retval = #CMDERR_OK
  EndIf
  ProcedureReturn retval
EndProcedure

Procedure.i Echo( *chan.iChannel, *pkt.tPkt, *buf, len.i )
  
  ;Send: 04 00 06 <seq> 2E 00 30 2E
  ;Recv: 05 00 07 <seq> 00 09 04 00 06 <seq> 2E 00 30 2E 18
  ;                                                      ^^
  
  ProcedureReturn #CMDERR_FWBUG
EndProcedure

Procedure.i DoSoftReset( *chan.iChannel, *pkt.tPkt, wait.i=20 )
  
  assert( *chan )
  assert( *pkt )
    
  *pkt\buf[0] =  0
  *pkt\buf[1] = (#REQUEST_SOFT_SYSTEM_RESET>>8) & $FF
  *pkt\buf[2] =  #REQUEST_SOFT_SYSTEM_RESET     & $FF
  *pkt\len    =  3
  
  If *chan\Send( *pkt )
    Delay( wait )
    ProcedureReturn #CMDERR_OK
  EndIf
  ProcedureReturn #CMDERR_UNKNOWN
EndProcedure

Procedure.i DoHardReset( *chan.iChannel, *pkt.tPkt, wait.i=20 )
  
  assert( *chan )
  assert( *pkt )
    
  *pkt\buf[0] =  0
  *pkt\buf[1] = (#REQUEST_HARD_SYSTEM_RESET>>8) & $FF
  *pkt\buf[2] =  #REQUEST_HARD_SYSTEM_RESET     & $FF
  *pkt\len    =  3
  
  If *chan\Send( *pkt )
    Delay( wait )
    ProcedureReturn #CMDERR_OK
  EndIf
  ProcedureReturn #CMDERR_UNKNOWN
EndProcedure

Procedure.i DoReInit( *chan.iChannel, *pkt.tPkt )
  
  assert( *chan )
  assert( *pkt )
    
  *pkt\buf[0] =  #TAG
  *pkt\buf[1] = (#REQUEST_RE_INIT_OF_SYSTEM>>8) & $FF
  *pkt\buf[2] =  #REQUEST_RE_INIT_OF_SYSTEM     & $FF
  *pkt\len    =  4
  
  Protected.i retval = #CMDERR_EXCFAIL
  If *chan\Exchange(*pkt) And Not PktIsNack(*pkt)
    assert( PktHasTag(*pkt) )
    Swap *pkt\buf[1], *pkt\buf[2] : assert( PeekU(@*pkt\buf[1]) = #REQUEST_RE_INIT_OF_SYSTEM+1 )
    retval = #CMDERR_OK
  EndIf
  ProcedureReturn retval
EndProcedure

Procedure.i DoClearCountersAndFlags( *chan.iChannel, *pkt.tPkt )
  
  assert( *chan )
  assert( *pkt )
    
  *pkt\buf[0] =  #TAG
  *pkt\buf[1] = (#CLEAR_COUNTERS_AND_FLAGS_TO_ZERO>>8) & $FF
  *pkt\buf[2] =  #CLEAR_COUNTERS_AND_FLAGS_TO_ZERO     & $FF
  *pkt\len    =  4
  
  Protected.i retval = #CMDERR_EXCFAIL
  If *chan\Exchange(*pkt) And Not PktIsNack(*pkt)
    assert( PktHasTag(*pkt) )
    Swap *pkt\buf[1], *pkt\buf[2] : assert( PeekU(@*pkt\buf[1]) = #CLEAR_COUNTERS_AND_FLAGS_TO_ZERO+1 )
    retval = #CMDERR_OK
  EndIf
  ProcedureReturn retval
EndProcedure

Procedure.i SetDatalogType( *chan.iChannel, *pkt.tPkt, type.a )
  
  assert( *chan )
  assert( *pkt )
  assert( type <= #DATALOG_STREAMLONG )
    
  *pkt\buf[0] =  #TAG
  *pkt\buf[1] = (#SET_ASYNC_DATALOG_TYPE>>8) & $FF
  *pkt\buf[2] =  #SET_ASYNC_DATALOG_TYPE     & $FF
 ;*pkt\buf[3] = tag
  *pkt\buf[4] = type
  *pkt\len    = 5
  
  Protected.i retval = #CMDERR_EXCFAIL
  If *chan\Exchange(*pkt) And Not PktIsNack(*pkt)
    assert( PktHasTag(*pkt) )
    Swap *pkt\buf[1], *pkt\buf[2] : assert( PeekU(@*pkt\buf[1]) = #SET_ASYNC_DATALOG_TYPE+1 )
    retval = #CMDERR_OK
  EndIf
  ProcedureReturn retval
EndProcedure

Procedure.i CreateLocationsList( *chan.iChannel, *pkt.tPkt, List Locations.tLocation() )
  
  assert( *chan )
  assert( *pkt )
  
  *pkt\buf[0] =  #TAG
  *pkt\buf[1] = (#RETRIEVE_LIST_OF_LOCATION_IDS>>8) & $FF
  *pkt\buf[2] =  #RETRIEVE_LIST_OF_LOCATION_IDS     & $FF
 ;*pkt\buf[3] = tag
  *pkt\buf[4] = $00 ;< all locations - just brute force it since the
  *pkt\buf[5] = $00 ;  the time to exec is just as long as if I request
  *pkt\buf[6] = $00 ;  a filtered list. I'll sort on this end.
  *pkt\len    = 7
  
  Protected.i retval = #CMDERR_EXCFAIL
  If *chan\Exchange(*pkt,400) And Not PktIsNack(*pkt)
    assert( PktHasTag(*pkt) )
    Swap *pkt\buf[1], *pkt\buf[2] : assert( PeekU(@*pkt\buf[1]) = #RETRIEVE_LIST_OF_LOCATION_IDS+1 )
    assert( PktHasLength(*pkt) )
    Swap *pkt\buf[4], *pkt\buf[5]
    #HDRSIZE = 6 : Protected len.u = PeekU(@*pkt\buf[4]) : assert( len+#HDRSIZE = *pkt\len )
    retval = #CMDERR_BADLEN
    If len>0 And len<#BUFSIZE And Not len%2
      ClearList( Locations() )
      len = #HDRSIZE ;< reusing len as an idx
      Repeat
        Swap *pkt\buf[len], *pkt\buf[len+1]
        AddElement( Locations() )
        Locations()\id = PeekU(@*pkt\buf[len])
        len+2
      Until len >= *pkt\len
      FirstElement( Locations() )
      retval = #CMDERR_OK
    EndIf
  EndIf
  ProcedureReturn retval
EndProcedure

Procedure.i GetLocationDetails( *chan.iChannel, *pkt.tPkt, *loc.tLocation )
  
  assert( *chan )
  assert( *pkt )
  assert( *loc )
  
  *pkt\buf[0] =  #TAG
  *pkt\buf[1] = (#RETRIEVE_LOCATION_ID_DETAILS>>8) & $FF
  *pkt\buf[2] =  #RETRIEVE_LOCATION_ID_DETAILS     & $FF
 ;*pkt\buf[3] =  tag
  *pkt\buf[4] = (*loc\id>>8) & $FF
  *pkt\buf[5] =  *loc\id     & $FF
  *pkt\len    =  6
  
  Protected.i retval = #CMDERR_EXCFAIL
  If *chan\Exchange(*pkt) And Not PktIsNack(*pkt)
    assert( PktHasTag(*pkt) )
    Swap *pkt\buf[1], *pkt\buf[2] : assert( PeekU(@*pkt\buf[1]) = #RETRIEVE_LOCATION_ID_DETAILS+1 )
    assert( PktHasLength(*pkt) )
    Swap *pkt\buf[4], *pkt\buf[5]
    #HDRSIZE = 6 : Protected len.u = PeekU(@*pkt\buf[4]) : assert( len+#HDRSIZE = *pkt\len )
    retval = #CMDERR_BADLEN
    If len>0 And len<#BUFSIZE                           ;< swaps kill overlay convenience
      Swap *pkt\buf[#HDRSIZE+0], *pkt\buf[#HDRSIZE+1]   ; flags         @+0
      Swap *pkt\buf[#HDRSIZE+2], *pkt\buf[#HDRSIZE+3]   ; parent        @+2
                                                        ; ram page      @+4
                                                        ; flash page    @+5
      Swap *pkt\buf[#HDRSIZE+6], *pkt\buf[#HDRSIZE+7]   ; ram address   @+6
      Swap *pkt\buf[#HDRSIZE+8], *pkt\buf[#HDRSIZE+9]   ; flash address @+8
      Swap *pkt\buf[#HDRSIZE+10], *pkt\buf[#HDRSIZE+11] ; size          @+10
                                                        ;               = 12
      *loc\flags         = PeekU( @*pkt\buf[#HDRSIZE+0] )
      *loc\parent        = PeekU( @*pkt\buf[#HDRSIZE+2] )
      *loc\page\ram      = PeekA( @*pkt\buf[#HDRSIZE+4] )
      *loc\page\flash    = PeekA( @*pkt\buf[#HDRSIZE+5] )
      *loc\address\ram   = PeekU( @*pkt\buf[#HDRSIZE+6] )
      *loc\address\flash = PeekU( @*pkt\buf[#HDRSIZE+8] )
      *loc\size          = PeekU( @*pkt\buf[#HDRSIZE+10])
      retval = #CMDERR_OK
    EndIf
  EndIf
  ProcedureReturn retval
  
EndProcedure