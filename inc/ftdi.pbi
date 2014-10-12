; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

DeclareModule Device
    
  Structure tNode
    SerialNumber.s
    Description.s
  EndStructure
  
  Prototype.i tMatcher( *node.tNode )
  Declare.i Any()
  Declare.i Init()
  Declare.i NewDevice( *matcher.tMatcher=0 )
  
  Interface iDevice
    Send.i( *buf, len.i )
    Receive.i( *buf, len.i )
    Free.i()
  EndInterface
  
EndDeclareModule

Module Device
  
  IncludeFile "assert.pbi"
  IncludeFile "ftdi\dll.pbi"
  
  IncludeFile "ftdi\types.pbi"
  IncludeFile "ftdi\globals.pbi"
  IncludeFile "ftdi\procs.pbi"
  IncludeFile "ftdi\classes.pbi"
  
EndModule