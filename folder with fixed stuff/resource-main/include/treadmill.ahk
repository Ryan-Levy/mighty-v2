

Loop,
{
    Gosub, Check
    If (TE != "None") {
        PixelSearch,,, 55, 145, 56, 145, 0x3A3A3A, 40, Fast
        If (ErrorLevel = 0) {
            Click, 410, 345
            Sleep 1000
            Gosub, AutoEat
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
                    If (TL = %A_LoopField%) {
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
                    If (A_LoopField = %A_LoopField%) {
                        sendsc("%A_LoopField%")
                    }
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
WaitTreadmill:
    If (TASR = "0") {
        DefaultWait:=9000
    } else If (TASR = "1") {
        DefaultWait:=TASRV
    }
    TimerSleep := A_TickCount
    Loop,
    {
        TaskSleep := A_TickCount - TimerSleep
        TaskTimer := A_TickCount - TreadmillTask
        Tooltip, %TaskSleep% %TaskTimer%
        If (TaskSleep > DefaultWait) {
            Break
        }
        If (TaskTimer > 65000) {
            Break
        }
        If (TaskTimer > 55000) {
            Click, 400, 290
        }
    }
Return
y:
{
    if (%A_LoopField% = 5) {
        y = 370
    }
    if (%A_LoopField% = 4) {
        y = 340
    }
    if (%A_LoopField% = 3) {
        y = 280
    }
    if (%A_LoopField% = 2) {
        y = 250
    }
    if (%A_LoopField% = 1) {
        y = 220
    }
}
Return
AutoEat:
{
    Slot:="1,2,3,4,5,6,7,8,9,0"
    Loop, Parse, Slot, `,
    {
        Send %A_LoopField%
        Sleep 150
        ImageSearch,,, 60, 520, 760, 550, resource-main\Common use\slotequip.bmp
        If (ErrorLevel = 0) {
            Loop, ;; eating part
            {
                PixelSearch,,, 119, 144, 110, 146, 0x3A3A3A, 40, Fast ; if the hunger isn't full
                If (ErrorLevel = 0) {
                    Click, 405, 620
                    ImageSearch,,, 60, 520, 760, 550, resource-main\Common use\slotequip.bmp
                    If ErrorLevel = 1
                    {
                        Goto, AutoEat
                    }
                } else If (ErrorLevel = 1) {
                    Return
                }
                ;; Search for combat here
            }
        }
    }
    If (TE = "SlotEat") {
        ;; Send Webhook After not found food in any slot
    } else if (TE = "Slot+Inventory") {
        sendsc("``") ;open inv
        MouseMove, 100, 480
        Sleep 600
        xx=95
        Loop = 10
        Loop, %Loop%
        {
            ImageSearch, x, y, 90, 195, 675, 500, *10 %A_WorkingDir%/resource-main/x5.bmp
            If (ErrorLevel = 0) {
                Sleep 40
                Click, %x%, %y%, Down
                Sleep 50
                Click, %xx%, 555, Up
                Sleep 60
                xx:=xx+70
            } else If (ErrorLevel = 1) {
                If (A_Index = 1) {
                    ;;  Food ran out of inventory + Break
                    ExitApp
                }
                Break
            }   
        }
    }
    MouseMove, 100, 480
    sendsc("``") 
    Sleep 300
    Gosub, AutoEat
}
Return



Check:
{
    if WinExist("Ahk_exe RobloxPlayerBeta.exe") {
        WinActivate
        WinGetPos,,,W,H,A
        If ((W >= A_ScreenWidth ) & (H >= A_ScreenHeight)) {
            Send {F11}
            Sleep 100
        }
        if ((W > 816) & ( H > 638)) {
            WinMove, Ahk_exe RobloxPlayerBeta.exe,,,, 800, 599 
        }
    } else {
        MsgBox,,Vivace's Macro,Roblox not active,3
        ExitApp
    }
}   
Return


RecordUsername:
{
    Send {o down}
    Sleep 1000
    Send {o up}
    If (RECTYPE = "Record") {
        Send %RECKEY%
    }
    PixelSearch,,, 565, 90, 566, 91, 0xFFFFFF, 10
    IF (ErrorLevel = 1) {
        Send {Tab}
    }
    MouseMove, 765, 125
    Loop, 10
    {
        Click, WheelUp
        Sleep 100
    }
    Loop, 79
    {
        MouseMove, 0, 5, 1.7, r
    }
    Click, 805, 160, Down
    Click, 805, 285, Up
    MouseMove, 765, 125
    Loop, 79
    {
        MouseMove, 0, 5, 1.7, r
    }
    If (RECTYPE = "Record") {
        Send %RECKEY%
    } else if (RECTYPE = "Shadow") {
        Send %RECKEY%
    }
}
Return

Waitforcombat:
{
    Send,
    Loop,
    {
        ImageSearch,,, ;; Some pos to find later , resource-main\Common use\combat.bmp
        If (ErrorLevel = 1) {

        }
        ;; Auto Run
        arr := ["left", "right", "Dash Left", "Dash Right"] ;; random run array
        Random, oVar, 1, 4
        If (arr[oVar] = arr[left]) {
            Send {Left, Down}
            Sleep 25000
            Send {Left, Up}
        } else If (arr[oVar] = arr[right]) {
            Send {Right, Down}
            Sleep 25000
            Send {Right, Up}
        }

    }
    
}

