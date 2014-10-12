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
    Send.i( *buf, bsize.i, *cnt )
    Receive.i( *buf, bsize.i, *cnt )
    Free.i()
  EndInterface
  
EndDeclareModule

Module Device
  
  IncludeFile "assert.pbi"
  IncludeFile "device\ftdi.pbi"
  
  IncludeFile "device\types.pbi"
  IncludeFile "device\globals.pbi"
  IncludeFile "device\procs.pbi"
  IncludeFile "device\classes.pbi"
  
EndModule