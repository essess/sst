; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

EnableExplicit

DeclareModule Packet
  
  #BUFSIZE = (2*1024)
  
  Structure tPkt
    buf.a[#BUFSIZE]
    len.i
  EndStructure
  
  Enumeration
    #LENGTH     = %001
    #NACK       = %010
    #TAG        = %100
  EndEnumeration
  
  Declare.i NewPkt( flags.a=0 )
  Declare.i FreePkt( *pkt.tPkt )
  
  Macro PktIsNack( p )
    p\buf[0] & #NACK
  EndMacro
  
  Macro PktHasLength( p )
    p\buf[0] & #LENGTH
  EndMacro
  
  Macro PktHasTag( p )
    p\buf[0] & #TAG
  EndMacro
  
  Macro PktTag( p )
    p\buf[3]
  EndMacro
  
  ;TODO ENDIAN HELPERS(?)
  
 EndDeclareModule

Module Packet
  IncludeFile "assert.pbi"
  IncludeFile "packet\types.pbi"
  IncludeFile "packet\procs.pbi"
  IncludeFile "packet\classes.pbi"
EndModule