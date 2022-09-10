
TreadmillStart:
CoordMode, Tooltip, Window
Tooltip, J Reload K Pause L Exit, 650, 550, 2
ToolTip, Started Treadmill, 650, 600
Loop,
{
    Gosub, Check
    If (TE != "None") {
        PixelSearch,,, 55, 145, 56, 145, 0x3A3A3A, 40, Fast
        If (ErrorLevel = 0) {
            Click, 410, 345
            Sleep 1000
            Gosub, AutoEatTread
            Send {BackSpace}
            Sleep 200
            UpTreadmill := A_TickCount
            Loop,
            {			
                Click , 409, 296
                Click , 409, 295
            } Until A_TickCount - UpTreadmill > 1500
        }
    }
    ImageSearch,,, 20, 120, 260, 140, *10 %A_WorkingDir%\resource-main\treadmill\Stamina.bmp
    If (ErrorLevel = 0) { ;; found stamina bar
        Tooltip, Found Stam, 650, 600
        Sleep 100
        If (TS = "Stamina") {
            Click, 290, 310, 20
        } else If (TS = "RunningSpeed") {
            Click, 520, 310, 20
        }
        Tooltip, Clicked Level, 650, 600
        Color:="0x5A5A5A,0x98FF79"
        wait := A_TickCount
        Loop,
        {
            Loop, Parse, Color, `,
            {
                PixelSearch,,, 339, 249, 340, 250, %A_LoopField%,, Fast
                If (ErrorLevel = 0) {
                    Break
                }
            }
            If (ErrorLevel = 0) {
                Break
            }
        } Until (A_TickCount - wait > 3000)
        Sleep 300 ;; forwat ^^^
        MouseMove, 0, 100,, R
        PixelSearch,,, 410, 355, 411, 356, 0x98FF79, 30, Fast
        If (ErrorLevel = 1) { ;; If hand isn't in middle
            levell:="5,4,3,2,1"
            If (TL = "Auto") {
                Loop, Parse, levell, `,
                {
                    ToolTip, Search For %A_LoopField%, 650, 600
                    Sleep 100
                    ImageSearch,,, 390, 240, 430, 390, *Trans0x5A5A5A *13 resource-main\treadmill\level%A_LoopField%.bmp
                    If (ErrorLevel = 0) {
                        y:=y(A_LoopField)
                        Tooltip, Choose %A_LoopField%, 650, 600
                        Click, 470, %y%, 10
                        Break
                    } else If (ErrorLevel = 1) {
                        If (A_Index = 5) {
                            MsgBox, Not Found ;; Send Webhook and stop
                        }
                    }
                }
            } else If ((TL = "5") or (TL = "4") or (TL = "3") or (TL = "2") or (TL = "1")) {
                Loop, Parse, levell, `,
                {
                    If (TL = A_LoopField) {
                        y:=y(A_LoopField)
                        tooltip, y = %y%, 650,600
                        Click, 470, %y%, 10
                        Tooltip, Choose %A_LoopField%, 650, 600
                        Sleep 100
                        Break
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
        Tooltip, Clicked Hand, 650, 600
        Sleep 3000
        button := "w,a,s,d"
        TreadmillTask := A_TickCount
        If (TASS = 1) {
            Sleep %TASSV%
        }
        Loop,
        {
            TaskTimer := A_TickCount - TreadmillTask
            Loop, Parse, button, `,
            {
                ImageSearch,,, 200, 240, 600, 300, *50 %A_WorkingDir%\resource-main\treadmill\%A_LoopField%.bmp
                If (ErrorLevel = 0) {
                    Tooltip, Send %A_LoopField%, 650, 600
                    keytread:=A_LoopField
                    sc(keytread, 3)
                    Break
                }
            }
            If (TASD = 1) {
                IF (TA = "High") {
                    PixelSearch ,,, 40, 130, 40, 133, 0x3A3A3A, 40, Fast
                    If (ErrorLevel = 0) {
                        Gosub, WaitTreadmill
                    }
                } else If (TA = "Medium") {
                    PixelSearch ,,, 40, 130, 50, 133, 0x3A3A3A, 40, Fast
                    If (ErrorLevel = 0) {
                        Gosub, WaitTreadmill
                    }
                } else If (TA = "Low") {
                    PixelSearch ,,, 40, 130, 60, 133, 0x3A3A3A, 40, Fast
                    If (ErrorLevel = 0) {
                        Gosub, WaitTreadmill
                    }
                }
            }
            If (TaskTimer > 55000) {
                Click, 400, 290
            }
            If (TaskTimer > 65000) {
                Break
            }
        }
    }
    ImageSearch,,, 20, 85, 170, 110, *20 resource-main\Common use\combat.bmp
    If (ErrorLevel = 0) {
        If (TAAC = 1) {
            Gosub, RecordUsername
        }
        Gosub, Waitforcombat
    }
    ; auto log for round
    If (TD = "Fatigue Estimate") {
        vRound++
        If (Round = vRound) {
            MsgBox, LOGGED
        }
    }
}
Return

