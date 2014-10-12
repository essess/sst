; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------
EnableExplicit

IncludePath "..\inc"
XIncludeFile "assert.pbi"
XIncludeFile "device.pbi"

Procedure.i First( *node.Device::tNode )
  Debug "SerialNumber: "+*node\SerialNumber
  Debug "Description: "+*node\Description
  ProcedureReturn ~0
EndProcedure

Device::Init()
Define.Device::iDevice *d = Device::NewDevice( @First() )
If *d
  
  #BUFSIZE = 512
  Define  *buf = AllocateMemory( #BUFSIZE ) : assert( *buf )
  Define.i cnt = 0
  
  ; echo
  If *d\Receive( *buf, #BUFSIZE, @cnt )
    Debug "cnt [in] = "+Str(cnt)
    If *d\Send( *buf, cnt, @cnt )
      Debug "cnt [out] = "+Str(cnt)
    EndIf
  EndIf

  FreeMemory( *buf ) : *buf=0
  *d = *d\Free() : assert( *d=0 )
Else
  Debug "No devices found."
EndIf