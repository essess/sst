; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------
EnableExplicit

IncludePath "..\inc"
IncludeFile "assert.pbi"
IncludeFile "ftdi.pbi"

FTDI::Init()
Define *device.FTDI::iDevice = FTDI::First()
If *device
  Debug "SerialNumber: " + *device\SerialNumber()
  *device = *device\Free()
  assert( *device=0 )
Else
  Debug "No FTDI devices found."
EndIf