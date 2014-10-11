; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

DeclareModule FTDI
    
  Structure tNode
    SerialNumber.s
    Description.s
    IsOpen.b
    IsHighSpeed.b
    VID.w
    PID.w
  EndStructure
  
  Prototype.i tMatcher( *node.tNode )
  Declare.i Any()
  Declare.i Init()
  Declare.i First( *matcher.tMatcher=0 )
  
  Interface iDevice
    SerialNumber.s()
    Description.s()
    Open.i()
    Close.i()
    Free.i()
  EndInterface
  
EndDeclareModule

Module FTDI
  
  IncludeFile "assert.pbi"
  IncludeFile "ftdi\dll.pbi"
  
  IncludeFile "ftdi\types.pbi"
  IncludeFile "ftdi\globals.pbi"
  IncludeFile "ftdi\procs.pbi"
  IncludeFile "ftdi\classes.pbi"
  
EndModule