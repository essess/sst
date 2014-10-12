; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

Procedure.i prvSetup( *self.tDevice )
  If FT_SUCCESS(FT_StopInTask( *self\hnd )) And
     FT_SUCCESS(FT_SetBaudRate( *self\hnd, 115200 )) And
     FT_SUCCESS(FT_SetDataCharacteristics( *self\hnd, #FT_BITS_8, #FT_STOP_BITS_1, #FT_PARITY_ODD )) And
     FT_SUCCESS(FT_Purge( *self\hnd, #FT_PURGE_RX|#FT_PURGE_TX )) And
     FT_SUCCESS(FT_SetTimeouts( *self\hnd, 50, 50 )) And
     FT_SUCCESS(FT_SetLatencyTimer( *self\hnd, 5 )) And
     FT_SUCCESS(FT_RestartInTask( *self\hnd ))
    ProcedureReturn ~0
  EndIf
  Debug "prvSetup(): FAIL" ;< FT_SetLatencyTimer() on older devices!
  ProcedureReturn 0
EndProcedure

Procedure.i prvClose( *self.tDevice )
  assert( *self\hnd )
  If FT_SUCCESS(FT_Close( *self\hnd ))
    *self\hnd = 0
    ProcedureReturn ~0
  EndIf
  ProcedureReturn 0
EndProcedure

Procedure.i prvOpen( *self.tDevice )
  assert( Not *self\hnd )
  Protected *sn = AllocateMemory( 64 ) : assert( *sn )
  PokeS( *sn, *self\node\SerialNumber, 64, #PB_Ascii )
  If FT_SUCCESS(FT_OpenEx( *sn, #FT_OPEN_BY_SERIAL_NUMBER, @*self\hnd ))
    assert( *self\hnd )
    Protected.l dv
    assert( FT_SUCCESS(FT_GetDriverVersion( *self\hnd, @dv )) )
    Debug "FT_GetDriverVersion(): $"+RSet(Hex(dv),8,"0")
    If Not prvSetup( *self )
      prvClose( *self )
    EndIf
  EndIf
  FreeMemory( *sn )
  ProcedureReturn *self\hnd
EndProcedure

Procedure.i prvSend( *self.tDevice, *buf, bsize.i, *cnt )
  Protected.i ftstatus = FT_Write( *self\hnd, *buf, bsize, *cnt )
  If Not FT_SUCCESS(ftstatus)
    assert( *cnt )
    PokeI( *cnt, 0 )
    ProcedureReturn 0
  EndIf
  ProcedureReturn ~0
EndProcedure

Procedure.i prvReceive( *self.tDevice, *buf, bsize.i, *cnt )
  Protected.i ftstatus = FT_Read( *self\hnd, *buf, bsize, *cnt )
  If Not FT_SUCCESS(ftstatus)
    assert( *cnt )
    PokeI( *cnt, 0 )
    ProcedureReturn 0
  EndIf
  ProcedureReturn ~0
EndProcedure

Procedure.i prvFree( *self.tDevice )
  If prvClose( *self )
    FreeMemory( *self\node ) : *self\node=0
    *self\vtbl=0
    FreeMemory( *self ) : *self=0
  EndIf
  ProcedureReturn *self
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

Procedure.i NewDevice( *matcher.tMatcher=0 )
  Protected.i cnt, i, ftstatus
  ftstatus = FT_CreateDeviceInfoList( @cnt )
  If FT_SUCCESS( ftstatus )
    If Not *matcher
      *matcher = Any()
    EndIf
    While i < cnt
      Protected node.FT_DEVICE_LIST_INFO_NODE
      ftstatus = FT_GetDeviceInfoDetail(i, @node\Flags, @node\Type, @node\ID,
                 @node\LocId, @node\SerialNumber, @node\Description, @node\ftHandle)
      If FT_SUCCESS(ftstatus)
        If Not prvFlagsIsOpen( node\Flags )
          Protected *node.tNode = AllocateMemory( SizeOf(tNode) )
          assert(*node)
          *node\SerialNumber = PeekS( @node\SerialNumber, 16, #PB_Ascii )
          *node\Description  = PeekS( @node\Description, 64, #PB_Ascii )
          If *matcher( *node )
            Protected *device.tDevice = AllocateMemory( SizeOf(tDevice) )
            assert( *device )
            *device\vtbl = ?iDeviceClass
            *device\node = *node
            If prvOpen( *device )
              ProcedureReturn *device
            EndIf
            FreeMemory( *device ) : *device=0
          EndIf
          FreeMemory( *node ) : *node=0
        EndIf
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
