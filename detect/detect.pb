; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------
EnableExplicit

IncludePath "..\inc"
IncludeFile "ftdi.pbi"

Enumeration
  #MAINWIN
  #TREEVIEW
EndEnumeration

Global.i cnt = 0, *thread = 0

Procedure.i AddToTreeView( *node.FTDI::tNode )
  ; ftdi driver returns junk (empty string) sometimes - not sure
  ; if I should 'fix' in the ftdi:: namespace or simply filter here
  ; each has its drawbacks
  If *node\SerialNumber <> ""
    cnt + 1 : SetWindowTitle(#MAINWIN, "Detect ["+Str(cnt)+"]")
    AddGadgetItem(#TREEVIEW, -1, *node\SerialNumber, 0, 0)
    AddGadgetItem(#TREEVIEW, -1, *node\Description, 0, 1)
    AddGadgetItem(#TREEVIEW, -1, "PID: $"+RSet(Hex(*node\PID),4,"0"), 0, 1)
    AddGadgetItem(#TREEVIEW, -1, "VID: $"+RSet(Hex(*node\VID),4,"0"), 0, 1)
    If *node\IsHighSpeed
      AddGadgetItem(#TREEVIEW, -1, "High Speed (480Mbps)", 0, 1)
    Else
      AddGadgetItem(#TREEVIEW, -1, "Full Speed (12Mbps)", 0, 1) 
    EndIf
    If *node\IsOpen
      AddGadgetItem(#TREEVIEW, -1, "Open in another process", 0, 1)
    EndIf
  EndIf
  ProcedureReturn 0 ;< no match, to force continued enumeration
EndProcedure

Procedure Resize()
  ResizeGadget(#TREEVIEW, #PB_Ignore, #PB_Ignore,
               WindowWidth(#MAINWIN)-10, WindowHeight(#MAINWIN)-10)
EndProcedure

Procedure.i EnumDevices( *unused )
  ClearGadgetItems(#TREEVIEW)
  SetWindowTitle(#MAINWIN, "Detect [Searching]") : cnt = 0
  Delay(5000) ; pos ftdi driver needs to 'stabilize' upon plug/unplug
  FTDI::First( @AddToTreeView() )
EndProcedure

Procedure WinProcCB(hWnd, uMsg, WParam, LParam)
  If umsg = #WM_DEVICECHANGE
    If (WParam = #DBT_DEVICEARRIVAL) Or
       (WParam = #DBT_DEVICEREMOVECOMPLETE)
      If IsThread(*thread) : KillThread(*thread) : EndIf
      *thread = CreateThread(@EnumDevices(),0)
    EndIf
  EndIf
  ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure

; begin:

OpenWindow(#MAINWIN, 0, 0, 230, 270, "Detect",
           #PB_Window_SizeGadget|#PB_Window_ScreenCentered|
           #PB_Window_SystemMenu)
TreeGadget(#TREEVIEW, 5, 5, 220,260, #PB_Tree_NoLines)
BindEvent(#PB_Event_SizeWindow, @Resize(), #MAINWIN)

FTDI::Init()
*thread = CreateThread(@EnumDevices(),0)
SetWindowCallback(@WinProcCB(),#MAINWIN)

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow