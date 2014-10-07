; -----------------------------------------------------------------------------
; Copyright (c) 2014 Sean Stasiak. All rights reserved.
; Developed by: Sean Stasiak <sstasiak@gmail.com>
; Refer to license terms in license.txt; In the absence of such a file,
; contact me at the above email address and I can provide you with one.
; -----------------------------------------------------------------------------

DataSection
  iDeviceClass:
  Data.i @prvSerialNumber()
  Data.i @prvDescription()
  Data.i @prvToStr()
  Data.i @prvFree()
EndDataSection