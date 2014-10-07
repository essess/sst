; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

Procedure.i prvAny( *node.tNode )
  ProcedureReturn *node
EndProcedure

Procedure prvFree( *self.tDevice )
  assert( *self )
  FreeMemory( *self\node ) : *self\node = 0
  *self\vtbl = 0 : FreeMemory( *self )
EndProcedure

Procedure.s prvSerialNumber( *self.tDevice )
  ProcedureReturn *self\node\SerialNumber
EndProcedure

Procedure.s prvDescription( *self.tDevice )
  ProcedureReturn *self\node\Description
EndProcedure

Procedure.s prvToStr( *self.tDevice )
  ProcedureReturn *self\node\SerialNumber
EndProcedure

Procedure.i Any()
  ProcedureReturn @prvAny()
EndProcedure

Procedure.i Init()
  ProcedureReturn FT_Load()
EndProcedure

Procedure.i First( *matcher.tMatcher=0 )
  If Not *matcher
    Debug "*matcher = Any()"
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
          ProcedureReturn *device
        EndIf
        FreeMemory( *node )
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
