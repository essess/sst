; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------
EnableExplicit

IncludePath "..\inc"
IncludeFile "ftdi.pbi"

OpenConsole()

NewList devlst.ftdi::node_t()
If ftdi::init() And ftdi::find( devlst(), ftdi::all() ) And ListSize( devlst() )
  ForEach devlst()
    PrintN( ftdi::node_tostr(devlst()) )
  Next
Else
  PrintN( "No FTDI devices found." )
EndIf
FreeList( devlst() )

Input()