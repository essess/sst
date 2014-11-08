; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

Enumeration
  #FT_OK                          = 0
  #FT_INVALID_HANDLE              = 1
  #FT_DEVICE_NOT_FOUND            = 2
  #FT_DEVICE_NOT_OPENED           = 3
  #FT_IO_ERROR                    = 4
  #FT_INSUFFICIENT_RESOURCES      = 5
  #FT_INVALID_PARAMETER           = 6
  #FT_INVALID_BAUD_RATE           = 7
  #FT_DEVICE_NOT_OPENED_FOR_ERASE = 8
  #FT_DEVICE_NOT_OPENED_FOR_WRITE = 9
  #FT_FAILED_TO_WRITE_DEVICE      = 10
  #FT_EEPROM_READ_FAILED          = 11
  #FT_EEPROM_WRITE_FAILED         = 12
  #FT_EEPROM_ERASE_FAILED         = 13
  #FT_EEPROM_NOT_PRESENT          = 14
  #FT_EEPROM_NOT_PROGRAMMED       = 15
  #FT_INVALID_ARGS                = 16
  #FT_NOT_SUPPORTED               = 17
  #FT_OTHER_ERROR                 = 18
  #FT_DEVICE_LIST_NOT_READY       = 19
EndEnumeration

Macro FT_SUCCESS( ftstatus )
  (ftstatus = #FT_OK)
EndMacro

Procedure.s prvFTStatusToStr( ftstatus.i )
  Protected.s str = "UNKNOWN"
  Select ftstatus
    Case #FT_OK : str = "#FT_OK"
    Case #FT_INVALID_HANDLE : str = "#FT_INVALID_HANDLE"
    Case #FT_DEVICE_NOT_FOUND : str = "#FT_DEVICE_NOT_FOUND"
    Case #FT_DEVICE_NOT_OPENED : str = "#FT_DEVICE_NOT_OPENED"
    Case #FT_IO_ERROR : str = "#FT_IO_ERROR"
    Case #FT_INSUFFICIENT_RESOURCES : str = "#FT_INSUFFICIENT_RESOURCES"
    Case #FT_INVALID_PARAMETER : str = "#FT_INVALID_PARAMETER"
    Case #FT_INVALID_BAUD_RATE : str = "#FT_INVALID_BAUD_RATE"
    Case #FT_DEVICE_NOT_OPENED_FOR_ERASE : str = "#FT_DEVICE_NOT_OPENED_FOR_ERASE"
    Case #FT_DEVICE_NOT_OPENED_FOR_WRITE : str = "#FT_DEVICE_NOT_OPENED_FOR_WRITE"
    Case #FT_FAILED_TO_WRITE_DEVICE : str = "#FT_FAILED_TO_WRITE_DEVICE"
    Case #FT_EEPROM_READ_FAILED : str = "#FT_EEPROM_READ_FAILED"
    Case #FT_EEPROM_WRITE_FAILED : str = "#FT_EEPROM_WRITE_FAILED"
    Case #FT_EEPROM_ERASE_FAILED : str = "#FT_EEPROM_ERASE_FAILED"
    Case #FT_EEPROM_NOT_PRESENT : str = "#FT_EEPROM_NOT_PRESENT"
    Case #FT_EEPROM_NOT_PROGRAMMED : str = "#FT_EEPROM_NOT_PROGRAMMED"
    Case #FT_INVALID_ARGS : str = "#FT_INVALID_ARGS"
    Case #FT_NOT_SUPPORTED : str = "#FT_NOT_SUPPORTED"
    Case #FT_OTHER_ERROR : str = "#FT_OTHER_ERROR"
    Case #FT_DEVICE_LIST_NOT_READY : str = "#FT_DEVICE_LIST_NOT_READY"
  EndSelect
  ProcedureReturn str  
EndProcedure

Structure FT_DEVICE_LIST_INFO_NODE Align #PB_Structure_AlignC
  Flags.l
  Type.l
  ID.l
  LocId.l
  SerialNumber.b[16]
  Description.b[64]
  ftHandle.i
EndStructure

Procedure.w prvVIDFromID( id.i )
  ProcedureReturn id >> 16
EndProcedure

Procedure.w prvPIDFromID( id.i )
  ProcedureReturn id
EndProcedure

Enumeration
  #FT_FLAGS_OPENED  = 1
  #FT_FLAGS_HISPEED = 2
EndEnumeration

Procedure.i prvFlagsIsOpen( flags.i )
  ProcedureReturn flags & #FT_FLAGS_OPENED
EndProcedure

Procedure.i prvFlagsIsHighSpeed( flags.i )
  ProcedureReturn flags & #FT_FLAGS_HISPEED
EndProcedure

Enumeration
  #FT_DEVICE_BM       = 0
  #FT_DEVICE_AM       = 1
  #FT_DEVICE_100AX    = 2
  #FT_DEVICE_UNKNOWN  = 3
  #FT_DEVICE_2232C    = 4
  #FT_DEVICE_232R     = 5
  #FT_DEVICE_2232H    = 6
  #FT_DEVICE_4232H    = 7
  #FT_DEVICE_232H     = 8
  #FT_DEVICE_X_SERIES = 9
EndEnumeration

Enumeration
  #FT_OPEN_BY_SERIAL_NUMBER = 1
  #FT_OPEN_BY_DESCRIPTION   = 2
  #FT_OPEN_BY_LOCATION      = 4
EndEnumeration

Enumeration
  #FT_STOP_BITS_1 = 0
  #FT_STOP_BITS_2 = 2
EndEnumeration

Enumeration
  #FT_PARITY_NONE  = 0
  #FT_PARITY_ODD   = 1
  #FT_PARITY_EVEN  = 2
  #FT_PARITY_MARK  = 3
  #FT_PARITY_SPACE = 4
EndEnumeration

Enumeration
  #FT_BITS_8 = 8
  #FT_BITS_7 = 7
EndEnumeration

Enumeration
  #FT_PURGE_RX = 1
  #FT_PURGE_TX = 2
EndEnumeration

Declare.i FT_Load()
Declare.i FT_GetLibraryVersion( *version )
Declare.i FT_CreateDeviceInfoList( *devcnt )
Declare.i FT_GetDeviceInfoDetail( idx.i, *flags, *type, *id, *locid, *sn, *desc, *hnd )
Declare.i FT_GetDeviceInfoList( *array, *devcnt )
Declare.i FT_OpenEx( *arg, flags.l, *hnd )
Declare.i FT_Close( hnd.i )
Declare.i FT_GetDriverVersion( hnd.i, *version )
Declare.i FT_ResetDevice( hnd.i )
Declare.i FT_Purge( hnd.i, mask.l )
Declare.i FT_SetLatencyTimer( hnd.i, timer.b )
Declare.i FT_SetBitMode( hnd.i, mask.b, mode.b )
Declare.i FT_SetFlowControl( hnd.i, cntrl.w, xon.b=17, xoff.b=19 )
Declare.i FT_SetDataCharacteristics( hnd.i, len.b, stopbits.b, parity.b )
Declare.i FT_SetBaudRate( hnd.i, rate.l )
Declare.i FT_Write( hnd.i, *buff, writecnt.l, *writtencnt )
Declare.i FT_Read( hnd.i, *buff, readcnt.l, *returncnt )
Declare.i FT_StopInTask( hnd.i )
Declare.i FT_RestartInTask( hnd.i )
Declare.i FT_SetTimeouts( hnd.i, rto.l, wto.l )
Declare.i FT_GetQueueStatus( hnd.i, *rxcnt )
Declare.i FT_SetDeadmanTimeout( hnd.i, timeout.w )

;{
Prototype.i _FT_GetLibraryVersion(*lpdwDLLVersion)
Prototype.i _FT_CreateDeviceInfoList(*lpdwNumDevs)
Prototype.i _FT_GetDeviceInfoDetail(dwIndex.l,*lpdwFlags,*lpdwType,*lpdwID,*lpdwLocId,*pcSerialNumber.p-ascii,*pcDescription.p-ascii,*ftHandle)
Prototype.i _FT_GetDeviceInfoList(*pDest,*lpdwNumDevs)
Prototype.i _FT_OpenEx(*pvArg,dwFlags.l,*ftHandle)
Prototype.i _FT_Close(ftHandle.i)
Prototype.i _FT_GetDriverVersion(ftHandle.i,*lpdwDriverVersion)
Prototype.i _FT_ResetDevice(ftHandle.i)
Prototype.i _FT_Purge(ftHandle.i,dwMask.l)
Prototype.i _FT_SetLatencyTimer(ftHandle.i,ucTimer.b)
Prototype.i _FT_SetBitMode(ftHandle.i,ucMask.b,ucMode.b)
Prototype.i _FT_SetFlowControl(ftHandle.i,usFlowControl.w,uXon.b,uXoff.b)
Prototype.i _FT_SetDataCharacteristics(ftHandle.i,uWordLength.b,uStopBits.b,uParity.b)
Prototype.i _FT_SetBaudRate(ftHandle.i,dwBaudRate.l)
Prototype.i _FT_Write(ftHandle.i,*lpBuffer,dwBytesToWrite.l,*lpdwBytesWritten)
Prototype.i _FT_Read(ftHandle.i,*lpBuffer,dwBytesToRead.l,*lpdwBytesReturned)
Prototype.i _FT_StopInTask(ftHandle.i)
Prototype.i _FT_RestartInTask(ftHandle.i)
Prototype.i _FT_SetTimeouts(ftHandle.i,dwReadTimeout.l,dwWriteTimeout.l)
Prototype.i _FT_GetQueueStatus(ftHandle.i,*lpdwAmountInRxQueue)
Prototype.i _FT_SetDeadmanTimeout(ftHandle.i,dwDeadmanTimeout.w)
;}

Structure DLL
  *FT_GetLibraryVersion._FT_GetLibraryVersion
  *FT_CreateDeviceInfoList._FT_CreateDeviceInfoList
  *FT_GetDeviceInfoDetail._FT_GetDeviceInfoDetail
  *FT_GetDeviceInfoList._FT_GetDeviceInfoList
  *FT_OpenEx._FT_OpenEx
  *FT_Close._FT_Close
  *FT_GetDriverVersion._FT_GetDriverVersion
  *FT_ResetDevice._FT_ResetDevice
  *FT_Purge._FT_Purge
  *FT_SetLatencyTimer._FT_SetLatencyTimer
  *FT_SetBitMode._FT_SetBitMode
  *FT_SetFlowControl._FT_SetFlowControl
  *FT_SetDataCharacteristics._FT_SetDataCharacteristics
  *FT_SetBaudRate._FT_SetBaudRate
  *FT_Write._FT_Write
  *FT_Read._FT_Read
  *FT_StopInTask._FT_StopInTask
  *FT_RestartInTask._FT_RestartInTask
  *FT_SetTimeouts._FT_SetTimeouts
  *FT_GetQueueStatus._FT_GetQueueStatus
  *FT_SetDeadmanTimeout._FT_SetDeadmanTimeout
EndStructure

Global *me.DLL = 0

Procedure.i FT_Load()
  If Not *me
    *me = AllocateStructure( DLL )
    If *me
      Protected lib.l = OpenLibrary( #PB_Any, "ftd2xx.dll" )
      If lib
        With *me
          \FT_GetLibraryVersion = GetFunction( lib, "FT_GetLibraryVersion" )
          \FT_CreateDeviceInfoList = GetFunction( lib, "FT_CreateDeviceInfoList" )
          \FT_GetDeviceInfoDetail = GetFunction( lib, "FT_GetDeviceInfoDetail" )
          \FT_GetDeviceInfoList = GetFunction( lib, "FT_GetDeviceInfoList" )
          \FT_OpenEx = GetFunction( lib, "FT_OpenEx" )
          \FT_Close = GetFunction( lib, "FT_Close" )
          \FT_GetDriverVersion = GetFunction( lib, "FT_GetDriverVersion" )
          \FT_ResetDevice = GetFunction( lib, "FT_ResetDevice" )
          \FT_Purge = GetFunction( lib, "FT_Purge" )
          \FT_SetLatencyTimer = GetFunction( lib, "FT_SetLatencyTimer" )
          \FT_SetBitMode = GetFunction( lib, "FT_SetBitMode" )
          \FT_SetFlowControl = GetFunction( lib, "FT_SetFlowControl" )
          \FT_SetDataCharacteristics = GetFunction( lib, "FT_SetDataCharacteristics" )
          \FT_SetBaudRate = GetFunction( lib, "FT_SetBaudRate" )
          \FT_Write = GetFunction( lib, "FT_Write" )
          \FT_Read = GetFunction( lib, "FT_Read" )
          \FT_StopInTask = GetFunction( lib, "FT_StopInTask" )
          \FT_RestartInTask = GetFunction( lib, "FT_RestartInTask" )
          \FT_SetTimeouts = GetFunction( lib, "FT_SetTimeouts" )
          \FT_GetQueueStatus = GetFunction( lib, "FT_GetQueueStatus" )
          \FT_SetDeadmanTimeout = GetFunction( lib, "FT_SetDeadmanTimeout" )
        EndWith
      Else
        FreeStructure( *me )
        *me = 0
      EndIf
    EndIf
  EndIf
  ProcedureReturn *me
EndProcedure

Procedure.i FT_GetLibraryVersion( *version )
  assert( *me )
  ProcedureReturn *me\FT_GetLibraryVersion( *version )
EndProcedure

Procedure.i FT_CreateDeviceInfoList( *devcnt )
  assert( *me )
  ProcedureReturn *me\FT_CreateDeviceInfoList( *devcnt )
EndProcedure

Procedure.i FT_GetDeviceInfoDetail( idx.i, *flags, *type, *id, *locid, *sn, *desc, *hnd )
  assert( *me )
  ProcedureReturn *me\FT_GetDeviceInfoDetail( idx, *flags, *type, *id, *locid, *sn, *desc, *hnd )
EndProcedure

Procedure.i FT_GetDeviceInfoList( *array, *devcnt )
  assert( *me )
  ProcedureReturn *me\FT_GetDeviceInfoList( *array, *devcnt )
EndProcedure

Procedure.i FT_OpenEx( *arg, flags.l, *hnd )
  assert( *me )
  ProcedureReturn *me\FT_OpenEx( *arg, flags.l, *hnd )
EndProcedure

Procedure.i FT_Close( hnd.i )
  assert( *me )
  ProcedureReturn *me\FT_Close( hnd.i )
EndProcedure

Procedure.i FT_GetDriverVersion( hnd.i, *version )
  assert( *me )
  ProcedureReturn *me\FT_GetDriverVersion( hnd, *version )
EndProcedure

Procedure.i FT_ResetDevice( hnd.i )
  assert( *me )
  ProcedureReturn *me\FT_ResetDevice( hnd )
EndProcedure

Procedure.i FT_Purge( hnd.i, mask.l )
  assert( *me )
  ProcedureReturn *me\FT_Purge( hnd, mask )
EndProcedure

Procedure.i FT_SetLatencyTimer( hnd.i, timer.b )
  assert( *me )
  ProcedureReturn *me\FT_SetLatencyTimer( hnd, timer )
EndProcedure

Procedure.i FT_SetBitMode( hnd.i, mask.b, mode.b )
  assert( *me )
  ProcedureReturn *me\FT_SetBitMode( hnd, mask, mode )
EndProcedure

Procedure.i FT_SetFlowControl( hnd.i, cntrl.w, xon.b=17, xoff.b=19 )
  assert( *me )
  ProcedureReturn *me\FT_SetFlowControl( hnd, cntrl, xon, xoff )
EndProcedure

Procedure.i FT_SetDataCharacteristics( hnd.i, len.b, stopbits.b, parity.b )
  assert( *me )
  ProcedureReturn *me\FT_SetDataCharacteristics( hnd, len, stopbits, parity )
EndProcedure

Procedure.i FT_SetBaudRate( hnd.i, rate.l )
  assert( *me )
  ProcedureReturn *me\FT_SetBaudRate( hnd, rate )
EndProcedure

Procedure.i FT_Write( hnd.i, *buff, writecnt.l, *writtencnt )
  assert( *me )
  ProcedureReturn *me\FT_Write( hnd, *buff, writecnt, *writtencnt )
EndProcedure

Procedure.i FT_Read( hnd.i, *buff, readcnt.l, *returncnt )
  assert( *me )
  ProcedureReturn *me\FT_Read( hnd, *buff, readcnt, *returncnt )
EndProcedure

Procedure.i FT_StopInTask( hnd.i )
  assert( *me )
  ProcedureReturn *me\FT_StopInTask( hnd )
EndProcedure

Procedure.i FT_RestartInTask( hnd.i )
  assert( *me )
  ProcedureReturn *me\FT_RestartInTask( hnd )
EndProcedure

Procedure.i FT_SetTimeouts( hnd.i, rto.l, wto.l )
  assert( *me )
  ProcedureReturn *me\FT_SetTimeouts( hnd.i, rto, wto )
EndProcedure

Procedure.i FT_GetQueueStatus( hnd.i, *rxcnt )
  assert( *me )
  ProcedureReturn *me\FT_GetQueueStatus( hnd.i, *rxcnt )
EndProcedure

Procedure.i FT_SetDeadmanTimeout( hnd.i, timeout.w )
  assert( *me )
  ProcedureReturn *me\FT_SetDeadmanTimeout( hnd.i, timeout )
EndProcedure