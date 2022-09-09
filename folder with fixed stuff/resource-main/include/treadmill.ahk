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
        If (TS = "Stamina") {
            Click, 290, 310, 20
        } else If (TS = "RunningSpeed") {
            Click, 520, 310, 20
        }
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
        PixelSearch,,, 410, 355, 411, 356, 0x98FF79, 30, Fast
        If (ErrorLevel = 1) { ;; If hand isn't in middle
            levell = "1,2,3,4,5"
            If (TL = "Auto") {
                Loop, Parse, levell, `,
                {
                    ImageSearch,,, 390, 240, 430, 390, resource-main\treadmill\level%A_LoopField%.bmp
                    If (ErrorLevel = 0) {
                        y:=y(A_LoopField)
                        Click, 470, %y%, 10
                    }
                }
                If (ErrorLevel = 1) { ;; Not Found Anything
                    ;; Send Webhook and stop
                }
            } else {
                Loop, Parse, levell, `,
                {
                    If (TL = %A_LoopField%) {
                        y:=y(A_LoopField)
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
                    sendsc("%A_LoopField%")
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
    ; combat search
    ; auto log for round
}
Return



Waitforcombat:
{
    Loop,
    {
        ;ImageSearch,,, ;; Some pos to find later , resource-main\Common use\combat.bmp
        If (ErrorLevel = 1) {

        }
        ;; Auto Run
        If (ErrorLevel = 1) { ;; if stam enough
            arr := ["left", "right", "Dash Left", "Dash Right", "Dash Foward", "left run", "right run", "dash forward"] ;; random run array
            Random, oVar, 1, 8

            If (arr[oVar] = arr[left run]) {
                Send {Left, Down}
                Sleep 2000
                Send {Left, Up}
            } else If (arr[oVar] = arr[right run]) {
                Send {Right, Down}
                Sleep 2000
                Send {Right, Up}
            }
        } else if (ErrorLevel = 0) { ;; if low stam walk

        }
        



    }
    
}

