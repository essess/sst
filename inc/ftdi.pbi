; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

XIncludeFile "ftdilib.pbi"

DeclareModule ftdi
  
  Structure node_t
    sn.s        ; serial number
    desc.s      ; description
    part.s      ; ftdi type as str
    type.b      ; ftdi type
    vid.w       ; vendor id
    pid.w       ; product id
    loc.l       ; location
    is_open.b   ; is open flag
    is_hs.b     ; is high speed flag
    idx.b       ; identifier used by ftdilib::open()
  EndStructure
  
  Enumeration
  EndEnumeration
  
  Prototype.i matcher_t( *node.node_t )
  
  Declare.i init()
  Declare.i find( List devlst.node_t(), *matcher.matcher_t )
  Declare.s node_tostr( *node.node_t )
  
  Declare.i all()
  
EndDeclareModule

Module ftdi
  
  EnableExplicit
  IncludeFile "assert.pbi"
  UseModule ftdilib
  
  Procedure.i _prv_matcher_all( *node.node_t )
    assert( *node )
    If *node
      ProcedureReturn ~0
    EndIf
    ProcedureReturn 0
  EndProcedure
  
  Procedure.s _prv_type_tostr( type.i )
    Select type
      Case #FT_DEVICE_BM
        ProcedureReturn "FT_DEVICE_BM"
      Case #FT_DEVICE_AM
        ProcedureReturn "FT_DEVICE_AM"
      Case #FT_DEVICE_100AX
        ProcedureReturn "FT_DEVICE_100AX"
      Case #FT_DEVICE_2232C
        ProcedureReturn "FT_DEVICE_2232C"
      Case #FT_DEVICE_232R
        ProcedureReturn "FT_DEVICE_232R"
      Case #FT_DEVICE_2232H
        ProcedureReturn "FT_DEVICE_2232H"
      Case #FT_DEVICE_4232H
        ProcedureReturn "FT_DEVICE_4232H"
      Case #FT_DEVICE_232H
        ProcedureReturn "FT_DEVICE_232H"
      Case #FT_DEVICE_X_SERIES
        ProcedureReturn "FT_DEVICE_X_SERIES"
      Case #FT_DEVICE_BM
        ProcedureReturn "FT_DEVICE_UNKNOWN"
      Default
        ProcedureReturn "FT_DEVICE_UNKNOWN"
    EndSelect
  EndProcedure
  
  Procedure.w _prv_pid_fromid( id.i )
    ProcedureReturn (id & $ffff)
  EndProcedure
  
  Procedure.w _prv_vid_fromid( id.i )
    ProcedureReturn (id & $ffff0000) >> 16
  EndProcedure
  
  Procedure.i _prv_node_to_list( List devlst.node_t(), *node.FT_DEVICE_LIST_INFO_NODE )
    If AddElement( devlst() )
      devlst()\sn = PeekS(*node\SerialNumber, 16, #PB_Ascii)    ;< BUG - something in pb
      devlst()\desc = PeekS(*node\Description, 64, #PB_Ascii)   ;<       chokes here
      devlst()\part = _prv_type_tostr( *node\Type )
      devlst()\type = *node\Type
      devlst()\vid = _prv_vid_fromid( *node\ID )
      devlst()\pid = _prv_pid_fromid( *node\ID )
      devlst()\loc = *node\LocId
      devlst()\is_open = Bool( *node\Flags & #FT_FLAGS_OPENED )
      devlst()\is_hs = Bool( *node\Flags & #FT_FLAGS_HISPEED )
    EndIf
    ProcedureReturn devlst()
  EndProcedure
  
  Procedure.i init()
    ProcedureReturn ftdilib::Load()
  EndProcedure
  
  ; !threadsafe
  Procedure.i find( List devlst.node_t(), *matcher.matcher_t )
    Protected.i cnt, i
    If CreateDeviceInfoList( @cnt ) = #FT_OK And *matcher
      While i < cnt
        Protected node.FT_DEVICE_LIST_INFO_NODE
        If GetDeviceInfoDetail(i, @node\Flags, @node\Type, @node\ID,
                               @node\LocId, @node\SerialNumber, @node\Description,
                               @node\ftHandle) <> #FT_OK
          Goto find_err:
        EndIf
        If *matcher( @node )
          If AddElement( devlst() ) ; see _prv_node_to_list() bug
            devlst()\sn = PeekS(@node\SerialNumber, 16, #PB_Ascii)
            devlst()\desc = PeekS(@node\Description, 64, #PB_Ascii)
            devlst()\part = _prv_type_tostr( node\Type )
            devlst()\type = node\Type
            devlst()\vid = _prv_vid_fromid( node\ID )
            devlst()\pid = _prv_pid_fromid( node\ID )
            devlst()\loc = node\LocId
            devlst()\is_open = Bool( node\Flags & #FT_FLAGS_OPENED )
            devlst()\is_hs = Bool( node\Flags & #FT_FLAGS_HISPEED )
            devlst()\idx = i
          Else
            Goto find_err:
          EndIf          
        EndIf
        i+1
      Wend
      ProcedureReturn ~0
    EndIf
  find_err:
    ClearList( devlst() )
    ProcedureReturn 0
  EndProcedure
  
  Procedure.s node_tostr( *node.node_t )
    Protected str.s = ""
    If *node
      str = "Index:         " + *node\idx + #CRLF$ +
            "Serial Number: " + *node\sn + #CRLF$ +
            "Description:   " + *node\desc + #CRLF$ +
            "Part($"+RSet(Hex(*node\type),2,"0")+"):     " + *node\part + #CRLF$ +
            "Location:     $" + RSet(Hex(*node\loc),8,"0") + #CRLF$ +
            "VID:          $" + RSet(Hex(*node\vid),4,"0") + #CRLF$ +
            "PID:          $" + RSet(Hex(*node\pid),4,"0") + #CRLF$ +
            "Is:            "
      If Not *node\is_open
        str + "Not "
      EndIf
      str + "Open, "
      If Not *node\is_hs
        str + "Full Speed (12Mbps)" + #CRLF$
      Else
        str + "High Speed (480Mbps)" + #CRLF$
      EndIf
    EndIf
    ProcedureReturn str
  EndProcedure
  
  Procedure.i all()
    ProcedureReturn @_prv_matcher_all()
  EndProcedure
  
EndModule