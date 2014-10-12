; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

#BLKTIME = 100  ;< rx/tx blocking time - temp hack

Procedure.s prvSerialNumber( *self.tDevice )
  assert( *self\node )
  ProcedureReturn *self\node\SerialNumber
EndProcedure

Procedure.s prvDescription( *self.tDevice )
  assert( *self\node )
  ProcedureReturn *self\node\Description
EndProcedure

Procedure prvDefaultErrHandler( code.i, codestr.s )
  Debug "iDevice() error: $"+RSet(Hex(code),16,"0")+" ["+codestr+"]"
EndProcedure

Procedure prvError( *self.tDevice, code.i, codestr.s )
  ; might be a pb bug, need to break out the
  ; fcall from *self before calling it, otherwise
  ; the compiler chokes
  Protected *ehnd.tErrHandler = *self\errHandler
  *ehnd( code, codestr )
EndProcedure

Procedure.i prvSetup( *self.tDevice )
  If FT_SUCCESS(FT_StopInTask( *self\hnd )) And
     FT_SUCCESS(FT_SetBaudRate( *self\hnd, 115200 )) And
     FT_SUCCESS(FT_SetDataCharacteristics( *self\hnd, #FT_BITS_8, #FT_STOP_BITS_1, #FT_PARITY_ODD )) And
     FT_SUCCESS(FT_Purge( *self\hnd, #FT_PURGE_RX|#FT_PURGE_TX )) And
     FT_SUCCESS(FT_SetTimeouts( *self\hnd, #BLKTIME, #BLKTIME )) And
     FT_SUCCESS(FT_SetLatencyTimer( *self\hnd, 1 )) And
     FT_SUCCESS(FT_RestartInTask( *self\hnd ))
    ProcedureReturn ~0
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure.i prvClose( *self.tDevice )
  assert( *self\node\IsOpen )
  If FT_SUCCESS(FT_Close( *self\hnd ))
    *self\hnd = 0
    *self\node\IsOpen = 0
    ProcedureReturn ~0
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure.i prvOpen( *self.tDevice )
  assert( Not *self\node\IsOpen )
  Dim sn.b(64)
  PokeS( @sn(), *self\node\SerialNumber, -1, #PB_Ascii )
  If FT_SUCCESS(FT_OpenEx( @sn(), #FT_OPEN_BY_SERIAL_NUMBER, @*self\hnd ))
    assert( *self\hnd )
    *self\node\IsOpen = ~0
    Protected.l dv
    assert( FT_SUCCESS(FT_GetDriverVersion( *self\hnd, @dv )) )
    Debug "FT_GetDriverVersion(): $"+RSet(Hex(dv),8,"0")
    If Not prvSetup( *self )
      prvClose( *self )
    EndIf
  EndIf
  FreeArray( sn() )
  ProcedureReturn *self\hnd
EndProcedure

Procedure.i prvSend( *self.tDevice, *buf, len.i )
  Protected.i cnt=0, ftstatus=#FT_OK
  ftstatus = FT_Write( *self\hnd, *buf, len, @cnt )
  If Not FT_SUCCESS(ftstatus)
    prvError( *self, ftstatus, prvFTStatusToStr(ftstatus) )
  EndIf
  ProcedureReturn cnt
EndProcedure

Procedure.i prvReceive( *self.tDevice, *buf, len.i )
  Protected.i cnt=0, ftstatus=#FT_OK
  ftstatus = FT_Read( *self\hnd, *buf, len, @cnt )
  If Not FT_SUCCESS(ftstatus)
    prvError( *self, ftstatus, prvFTStatusToStr(ftstatus) )
  EndIf
  ProcedureReturn cnt
EndProcedure

Procedure.i prvFree( *self.tDevice )
  If prvClose( *self )
    FreeMemory( *self\node ) : *self\node=0
    *self\vtbl=0
    FreeMemory( *self ) : *self=0
  EndIf
  ProcedureReturn *self
EndProcedure

Procedure.i prvRegErrorHandler( *self.tDevice, *handler.tErrHandler )
  assert( *handler )
  Protected *prev.tErrHandler = *self\errHandler
  *self\errHandler = *handler
  ProcedureReturn( *prev )
EndProcedure

Procedure.i prvAny( *node.tNode )
  If *node And (*node\SerialNumber <> "")
    ProcedureReturn *node
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure.i Any()
  ProcedureReturn @prvAny()
EndProcedure

Procedure.i Init()
  ProcedureReturn FT_Load()
EndProcedure

Procedure.i First( *matcher.tMatcher=0 )
  If Not *matcher
    *matcher = Any()
  EndIf
  Protected.i cnt, i, ftstatus
  ftstatus = FT_CreateDeviceInfoList(@cnt)
  If FT_SUCCESS(ftstatus)
    While i < cnt
      Protected node.FT_DEVICE_LIST_INFO_NODE
      ftstatus = FT_GetDeviceInfoDetail(i, @node\Flags, @node\Type, @node\ID,
                 @node\LocId, @node\SerialNumber, @node\Description, @node\ftHandle)
      If FT_SUCCESS(ftstatus)
        Protected *node.tNode = AllocateMemory( SizeOf(tNode) )
        assert(*node)
        *node\SerialNumber = PeekS( @node\SerialNumber, 16, #PB_Ascii )
        *node\Description  = PeekS( @node\Description, 64, #PB_Ascii )
        *node\IsOpen       = prvFlagsIsOpen( node\Flags )
        *node\IsHighSpeed  = prvFlagsIsHighSpeed( node\Flags )
        *node\VID          = prvVIDFromID( node\ID )
        *node\PID          = prvPIDFromID( node\ID )
        ; NOTICE: you will not be able to create a device from one that
        ;         is already open, threadsafety is an issue also - I'll
        ;         leave that one up to the caller
        If *matcher( *node ) And Not *node\IsOpen
          Protected *device.tDevice = AllocateMemory( SizeOf(tDevice) )
          assert( *device )
          *device\vtbl = ?iDeviceClass
          *device\node = *node
          prvRegErrorHandler( *device, @prvDefaultErrHandler() )
          If prvOpen( *device )
            ProcedureReturn *device
          EndIf
          FreeMemory( *device ) : *device=0
        EndIf
        FreeMemory( *node ) : *node=0
      Else
        Debug prvFTStatusToStr(ftstatus) + " = FT_GetDeviceInfoDetail()"
        Break
      EndIf
      i + 1
    Wend
  Else
    Debug prvFTStatusToStr(ftstatus) + " = FT_CreateDeviceInfoList()"
  EndIf
  ProcedureReturn 0
EndProcedure
