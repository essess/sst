; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------
EnableExplicit

Enumeration
  #REQUEST_INTERFACE_VERSION        = $0000
  #REQUEST_FIRMWARE_VERSION         = $0002
  #REQUEST_MAX_PACKET_SIZE          = $0004
  #REQUEST_ECHO_PACKET_RETURN       = $0006   ;< #CMDERR_FWBUG
  #REQUEST_SOFT_SYSTEM_RESET        = $0008
  #REQUEST_HARD_SYSTEM_RESET        = $000A
  #REQUEST_RE_INIT_OF_SYSTEM        = $000C
  #CLEAR_COUNTERS_AND_FLAGS_TO_ZERO = $FFF0
  #REQUEST_DECODER_NAME             = $EEEE
  #REQUEST_FIRMWARE_BUILD_DATE      = $EEF0
  #REQUEST_COMPILER_VERSION         = $EEF2
  #REQUEST_OPERATING_SYSTEM         = $EEF4
  #UPDATE_BLOCK_IN_RAM              = $0100
  #UPDATE_BLOCK_IN_FLASH            = $0102
  #RETRIEVE_BLOCK_FROM_RAM          = $0104
  #RETRIEVE_BLOCK_FROM_FLASH        = $0106
  #BURN_BLOCK_FROM_RAM_TO_FLASH     = $0108
  #REQUEST_DATALOG_PACKET           = $0190
  #SET_ASYNC_DATALOG_TYPE           = $0194
  #RETRIEVE_ARBITRARY_MEMORY        = $0258
  #RETRIEVE_LIST_OF_LOCATION_IDS    = $DA5E
  #RETRIEVE_LOCATION_ID_DETAILS     = $F8E0
  #REQUEST_UNIT_TEST_OVER_SERIAL    = $6666
  #START_BENCH_TEST_SEQUENCE        = $8888
EndEnumeration

Macro IsID( id )
  (id = #REQUEST_INTERFACE_VERSION        Or
   id = #REQUEST_FIRMWARE_VERSION         Or
   id = #REQUEST_MAX_PACKET_SIZE          Or
   id = #REQUEST_ECHO_PACKET_RETURN       Or
   id = #REQUEST_SOFT_SYSTEM_RESET        Or
   id = #REQUEST_HARD_SYSTEM_RESET        Or
   id = #REQUEST_RE_INIT_OF_SYSTEM        Or
   id = #CLEAR_COUNTERS_AND_FLAGS_TO_ZERO Or
   id = #REQUEST_DECODER_NAME             Or
   id = #REQUEST_FIRMWARE_BUILD_DATE      Or
   id = #REQUEST_COMPILER_VERSION         Or
   id = #REQUEST_OPERATING_SYSTEM         Or
   id = #UPDATE_BLOCK_IN_RAM              Or
   id = #UPDATE_BLOCK_IN_FLASH            Or
   id = #RETRIEVE_BLOCK_FROM_RAM          Or
   id = #RETRIEVE_BLOCK_FROM_FLASH        Or
   id = #BURN_BLOCK_FROM_RAM_TO_FLASH     Or
   id = #REQUEST_DATALOG_PACKET           Or
   id = #SET_ASYNC_DATALOG_TYPE           Or
   id = #RETRIEVE_ARBITRARY_MEMORY        Or
   id = #RETRIEVE_LIST_OF_LOCATION_IDS    Or
   id = #RETRIEVE_LOCATION_ID_DETAILS     Or
   id = #REQUEST_UNIT_TEST_OVER_SERIAL    Or
   id = #START_BENCH_TEST_SEQUENCE )
EndMacro