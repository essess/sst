; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

#TXRX_BUFSIZE = 2*#PKT_BUFSIZE    ;< encoding/decoding couldn't possibly
Structure tBuf                   ;  be worse than this!
  buf.a[#TXRX_BUFSIZE]
  len.i
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