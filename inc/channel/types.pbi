; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

#TXRX_BUFSIZE = (1*1024)
Structure tBuf
  buf.a[#TXRX_BUFSIZE]
  len.i
  *mutex
EndStructure

Structure tChannel
  *vtbl.iChannel
  *dev.Device::iDevice
  *evtHandler.tChannelEvent
  *thread
  *mutex
  counts.tCounters
  tx.tBuf
  rx.tBuf
EndStructure

Structure tPkt
  *vtbl.iPkt
  size.i
  len.i
  *buf
EndStructure

Interface iPktQueue Extends iPkt
  Push( byte.a )
  Pop.a()
  Reset()
EndInterface

Structure tOverlay ;< avoid ugly pb pointer math and peek/poke nonsense
  bytes.a[64*1024]
EndStructure