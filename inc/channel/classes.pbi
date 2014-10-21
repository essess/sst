; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

DataSection
  
iChannelClass:
  Data.i @prvSend()
  Data.i @prvExchange()
  Data.i @prvCounters()
  Data.i @prvChannelFree()
  
iPktClass:
  Data.i @prvBuffer()
  Data.i @prvLength()
  Data.i @prvSetLength()
  Data.i @prvPktFree()  
iPktQueueClass:
  Data.i @prvPush()
  Data.i @prvPop()
  Data.i @prvReset()
  
EndDataSection