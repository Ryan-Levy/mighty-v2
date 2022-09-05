

Loop,
{
    Gosub, Check
    If (WE != "None") {
        PixelSearch,,, 55, 145, 56, 145, 0x3A3A3A, 40, Fast
        If (ErrorLevel = 0) {
            Click, 400, 455 ; Leave weight
            Sleep 1000
            Gosub, AutoEat
            Send {BackSpace}
            Sleep 200
            UpWeight := A_TickCount
            Loop,
            {			
                Click , 409, 396
                Click , 409, 395
            } Until A_TickCount - UpWeight > 1500
        }
    }
    ImageSearch,,, 20, 120, 260, 140, *10 resource-main/weight/Stamina.bmp
    If (ErrorLevel = 0) {
        PixelSearch,,, 410, 355, 411, 356, 0x98FF79, 30, Fast
        If (ErrorLevel = 1) { ;; If hand isn't in middle
            levell = "1,2,3,4,5,6"
            If (WL = "Auto") {
                Loop, Parse, levell, `,
                {
                    ImageSearch,,, 390, 240, 430, 390, resource-main\weight\w%A_LoopField%.bmp
                    If (ErrorLevel = 0) {
                        gosub, y
                        Click, 470, %y%, 10
                    }
                }
                If (ErrorLevel = 1) { ;; Not Found Anything
                    ;; Send Webhook and stop
                }
            } else {
                Loop, Parse, levell, `,
                {
                    If (WL = %A_LoopField%) {
                        gosub, y
                        Click, 470, %y%, 10
                    }
                }
            }
        }
        HandCheck:=A_TickCount
        Loop,
        {
            Timer := A_TickCount - HandCheck
            PixelSearch,,, 410, 355, 411, 356, 0x98FF79, 30, Fast
            If (ErrorLevel = 0) {
                Click , 410, 355, 10
                Break
            }
            If (Timer > 10000) {
                Msgbox, Not Found Hand Money Ranout
                ExitApp
            }
        }
        WeightTask := A_TickCount
        Loop,
        {
            TaskTimer := A_TickCount - WeightTask
            ImageSearch, PosX, PosY, 250, 220, 560, 440, *25 resource-main\weight\yellow.png
            If (ErrorLevel = 0) {
                PosX:=PosX+5
                PosY:=PosY+5
                Click, %PosX%, %PosY%, 10
                Sleep 50
                MouseMove, 400, 540
                Sleep 10
            }
            If (WASD = 1) {
                If (WA "High") {
                    PixelSearch ,,, 40, 130, 40, 133, 0x3A3A3A, 40, Fast
                    If (ErrorLevel = 0) {
                        Gosub, WaitWeight
                    }
                }
                If (WA "Medium") {
                    PixelSearch ,,, 40, 130, 40, 133, 0x3A3A3A, 40, Fast
                    If (ErrorLevel = 0) {
                        Gosub, WaitWeight
                    }                
                }
                If (WA "Low") {
                    PixelSearch ,,, 40, 130, 40, 133, 0x3A3A3A, 40, Fast
                    If (ErrorLevel = 0) {
                        Gosub, WaitWeight
                    }
                }
            }
            If (TaskTimer > 55000) {
                Click, 400, 391
            }
            If (TaskTimer > 70000) {
                Break
            }
        }
    }
}
Return
WaitWeight:
{
    If (WASR = "0") {
        DefaultWait:=9000
    }
    If (WASR = "1") {
        DefaultWait:=WASR
    }
    TimerSleep := A_TickCount
    Loop,
    {
        TaskSleep := A_TickCount - TimerSleep
        TaskTimer := A_TickCount - WeightTask
        Tooltip, %TaskSleep% %TaskTimer%
        If (TaskSleep > DefaultWait) {
            Break
        }
        If (TaskTimer > 65000) {
            Break
        }
        If (TaskTimer > 55000) {
            Click, 400, 391
        }
    }
}
Return

