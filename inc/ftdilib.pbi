; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

DeclareModule ftdilib

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
  
  Structure FT_DEVICE_LIST_INFO_NODE Align #PB_Structure_AlignC
    Flags.l
    Type.l
    ID.l
    LocId.l
    SerialNumber.b[16]
    Description.b[64]
    ftHandle.i
  EndStructure
  
  Enumeration
    #FT_FLAGS_OPENED  = 1
    #FT_FLAGS_HISPEED = 2
  EndEnumeration
  
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
  
  Declare.i Load()
  Declare.i GetLibraryVersion( *version )
  Declare.i CreateDeviceInfoList( *devcnt )
  Declare.i GetDeviceInfoDetail( idx.i, *flags, *type, *id, *locid, *sn, *desc, *hnd )
  Declare.i GetDeviceInfoList( *array, *devcnt )
  Declare.i Open( idx.i, *hnd )
  Declare.i Close( hnd.i )
  Declare.i GetDriverVersion( hnd.i, *version )
  Declare.l ResetDevice( hnd.i )
  Declare.l Purge( hnd.i, mask.l )
  Declare.l SetLatencyTimer( hnd.i, timer.b )
  Declare.l SetBitMode( hnd.i, mask.b, mode.b )
  Declare.l SetFlowControl( hnd.i, cntrl.w, xon.b=17, xoff.b=19 )
  Declare.l SetDataCharacteristics( hnd.i, len.b, stopbits.b, parity.b )
  Declare.l SetBaudRate( hnd.i, rate.l )
  Declare.l Write( hnd.i, *buff, writecnt.l, *writtencnt )
  Declare.l Read_( hnd.i, *buff, readcnt.l, *returncnt )

EndDeclareModule

Module ftdilib
  
  EnableExplicit
  XIncludeFile "assert.pbi"

  Prototype.l _FT_GetLibraryVersion(*lpdwDLLVersion)
  Prototype.l _FT_CreateDeviceInfoList(*lpdwNumDevs)
  Prototype.l _FT_GetDeviceInfoDetail(dwIndex.l,*lpdwFlags,*lpdwType,*lpdwID,*lpdwLocId,*pcSerialNumber.p-ascii,*pcDescription.p-ascii,*ftHandle)
  Prototype.l _FT_GetDeviceInfoList(*pDest,*lpdwNumDevs)
  Prototype.l _FT_Open(iDevice.i,*ftHandle)
  Prototype.l _FT_Close(ftHandle.i)
  Prototype.l _FT_GetDriverVersion(ftHandle.i,*lpdwDriverVersion)
  Prototype.l _FT_ResetDevice(ftHandle.i)
  Prototype.l _FT_Purge(ftHandle.i,dwMask.l)
  Prototype.l _FT_SetLatencyTimer(ftHandle.i,ucTimer.b)
  Prototype.l _FT_SetBitMode(ftHandle.i,ucMask.b,ucMode.b)
  Prototype.l _FT_SetFlowControl(ftHandle.i,usFlowControl.w,uXon.b,uXoff.b)
  Prototype.l _FT_SetDataCharacteristics(ftHandle.i,uWordLength.b,uStopBits.b,uParity.b)
  Prototype.l _FT_SetBaudRate(ftHandle.i,dwBaudRate.l)
  Prototype.l _FT_Write(ftHandle.i,*lpBuffer,dwBytesToWrite.l,*lpdwBytesWritten)
  Prototype.l _FT_Read(ftHandle.i,*lpBuffer,dwBytesToRead.l,*lpdwBytesReturned)

  Structure DLL
    *FT_GetLibraryVersion._FT_GetLibraryVersion
    *FT_CreateDeviceInfoList._FT_CreateDeviceInfoList
    *FT_GetDeviceInfoDetail._FT_GetDeviceInfoDetail
    *FT_GetDeviceInfoList._FT_GetDeviceInfoList
    *FT_Open._FT_Open
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
  EndStructure

  Global *me.DLL=0

  Procedure.i Load()
    If Not *me
      *me = AllocateStructure( DLL )
      If *me
        Protected lib.l = OpenLibrary( #PB_Any, "ftd2xx.dll" )
        If lib
          With *me
            \FT_GetLibraryVersion = GetFunction( lib, "FT_GetLibraryVersion" )
            assert( \FT_GetLibraryVersion )
            \FT_CreateDeviceInfoList = GetFunction( lib, "FT_CreateDeviceInfoList" )
            assert( \FT_CreateDeviceInfoList )
            \FT_GetDeviceInfoDetail = GetFunction( lib, "FT_GetDeviceInfoDetail" )
            assert( \FT_GetDeviceInfoDetail )
            \FT_GetDeviceInfoList = GetFunction( lib, "FT_GetDeviceInfoList" )
            assert( \FT_GetDeviceInfoList )
            \FT_Open = GetFunction( lib, "FT_Open" )
            assert( \FT_Open )
            \FT_Close = GetFunction( lib, "FT_Close" )
            assert( \FT_Close )
            \FT_GetDriverVersion = GetFunction( lib, "FT_GetDriverVersion" )
            assert( \FT_GetDriverVersion )
            \FT_ResetDevice = GetFunction( lib, "FT_ResetDevice" )
            assert( \FT_ResetDevice )
            \FT_Purge = GetFunction( lib, "FT_Purge" )
            assert( \FT_Purge )
            \FT_SetLatencyTimer = GetFunction( lib, "FT_SetLatencyTimer" )
            assert( \FT_SetLatencyTimer )
            \FT_SetBitMode = GetFunction( lib, "FT_SetBitMode" )
            assert( \FT_SetBitMode )
            \FT_SetFlowControl = GetFunction( lib, "FT_SetFlowControl" )
            assert( \FT_SetFlowControl )
            \FT_SetDataCharacteristics = GetFunction( lib, "FT_SetDataCharacteristics" )
            assert( \FT_SetDataCharacteristics )
            \FT_SetBaudRate = GetFunction( lib, "FT_SetBaudRate" )
            assert( \FT_SetBaudRate )
            \FT_Write = GetFunction( lib, "FT_Write" )
            assert( \FT_Write )
            \FT_Read = GetFunction( lib, "FT_Read" )
            assert( \FT_Read )
          EndWith
        Else
          FreeStructure( *me )
          *me = 0
        EndIf
      EndIf
    EndIf
    ProcedureReturn *me
  EndProcedure

  Procedure.i GetLibraryVersion( *version )
    assert( *me )
    ProcedureReturn *me\FT_GetLibraryVersion( *version )
  EndProcedure
  
  Procedure.i CreateDeviceInfoList( *devcnt )
    assert( *me )
    ProcedureReturn *me\FT_CreateDeviceInfoList( *devcnt )
  EndProcedure
  
  Procedure.i GetDeviceInfoDetail( idx.i, *flags, *type, *id, *locid, *sn, *desc, *hnd )
    assert( *me )
    ProcedureReturn *me\FT_GetDeviceInfoDetail( idx, *flags, *type, *id, *locid, *sn, *desc, *hnd )
  EndProcedure
  
  Procedure.i GetDeviceInfoList( *array, *devcnt )
    assert( *me )
    ProcedureReturn *me\FT_GetDeviceInfoList( *array, *devcnt )
  EndProcedure
  
  Procedure.i Open( idx.i, *hnd )
    assert( *me )
    assert( idx < 32 )
    ProcedureReturn *me\FT_Open( idx, *hnd )
  EndProcedure
  
  Procedure.i Close( hnd.i )
    assert( *me )
    ProcedureReturn *me\FT_Close( hnd.i )
  EndProcedure
  
  Procedure.i GetDriverVersion( hnd.i, *version )
    assert( *me )
    ProcedureReturn *me\FT_GetDriverVersion( hnd, *version )
  EndProcedure
  
  Procedure.l ResetDevice( hnd.i )
    assert( *me )
    ProcedureReturn *me\FT_ResetDevice( hnd )
  EndProcedure
  
  Procedure.l Purge( hnd.i, mask.l )
    assert( *me )
    ProcedureReturn *me\FT_Purge( hnd, mask )
  EndProcedure
  
  Procedure.l SetLatencyTimer( hnd.i, timer.b )
    assert( *me )
    ProcedureReturn *me\FT_SetLatencyTimer( hnd, timer )
  EndProcedure
  
  Procedure.l SetBitMode( hnd.i, mask.b, mode.b )
    assert( *me )
    ProcedureReturn *me\FT_SetBitMode( hnd, mask, mode )
  EndProcedure
  
  Procedure.l SetFlowControl( hnd.i, cntrl.w, xon.b=17, xoff.b=19 )
    assert( *me )
    ProcedureReturn *me\FT_SetFlowControl( hnd, cntrl, xon, xoff )
  EndProcedure
  
  Procedure.l SetDataCharacteristics( hnd.i, len.b, stopbits.b, parity.b )
    assert( *me )
    ProcedureReturn *me\FT_SetDataCharacteristics( hnd, len, stopbits, parity )
  EndProcedure
  
  Procedure.l SetBaudRate( hnd.i, rate.l )
    assert( *me )
    ProcedureReturn *me\FT_SetBaudRate( hnd, rate )
  EndProcedure
  
  Procedure.l Write( hnd.i, *buff, writecnt.l, *writtencnt )
    assert( *me )
    ProcedureReturn *me\FT_Write( hnd, *buff, writecnt, *writtencnt )
  EndProcedure
  
  Procedure.l Read_( hnd.i, *buff, readcnt.l, *returncnt )
    assert( *me )
    ProcedureReturn *me\FT_Read( hnd, *buff, readcnt, *returncnt )
  EndProcedure    
  
EndModule