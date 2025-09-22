.ifndef __GLOBALS__
__GLOBALS__ = 1


    .segment "ZEROPAGE"
.import Frame_Ready
.import controller1, controller1_prev
.import NTINDEX


    .segment "CODE"
.import ReadController
.import LoadGraphics
.import NMIHandler
.import ClearRAM
.import WaitVBlank
.import action_MaveForward
.import action_MaveBackward
;.import ActController
;.import controller1, controller1_prev
;.import MainLoop

.endif