; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------
EnableExplicit

IncludePath "..\inc"
IncludeFile "ftdi.pbi"

Global.i cnt = 0

Procedure.s boolToStr( true.i )
  If true
    ProcedureReturn "True"
  EndIf
  ProcedureReturn "False"
EndProcedure

Procedure.i show( *node.FTDI::tNode )
  PrintN( "---------------------------------------------" + #CRLF$ +
          "Serial Number: " + *node\SerialNumber + #CRLF$ +
          "Description:   " + *node\Description + #CRLF$ +
          "VID:          $" + RSet(Hex(*node\VID),4,"0") + #CRLF$ +
          "PID:          $" + RSet(Hex(*node\PID),4,"0") + #CRLF$ +
          "Is Open:       " + boolToStr(*node\IsOpen) + #CRLF$ +
          "Is High Speed: " + boolToStr(*node\IsHighSpeed) + #CRLF$ +
          "---------------------------------------------")
  cnt + 1
  ProcedureReturn 0 ;< no match, to force continued enumeration
EndProcedure

If OpenConsole() And FTDI::Init()
  PrintN( "Searching: " )
  FTDI::First( @show() )    ;< use the matcher() to dump nodes
  PrintN( Str(cnt)+" FTDI devices found." )
  Input()               
  CloseConsole()
EndIf