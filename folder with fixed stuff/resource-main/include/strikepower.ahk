StartSPMac:
gosub, Check
CoordMode, Tooltip, Window
Tooltip, J Reload K Pause L Exit, 650, 550, 2
ToolTip, Started StrikePower, 650, 600
Send {BackSpace}{Click, Right}
Sleep 100
Send 1{Shift}
Sleep 100
If (SPR = "Rhythm") or (SPR = "Rhythm+Flow") {
    Sleep 100
    Send r
}
Tooltip, Please Have Shift Lock On
SetTimer, RMT , -3000
Loop,
{
    Gosub, Check
    re:
    ImageSearch,,, 20, 120, 260, 140, *10 resource-main\Common Use\Stamina.bmp
    If (ErrorLevel = 0) {
        ;; Check for combat tool if equip or not
        If (SPAWS = 1) {
            Sleep 100
            Send {BackSpace}
            Sleep 100
            Send 2
            Sleep 100
            Timer:=A_TickCount
            Loop,
            {
                CheckTimer:=A_TickCount-Timer
                If (CheckTimer > 60000) {
                    SPAWS = 0
                    eat = 2
                    Break
                }
                Click
                ImageSearch,,, 20, 120, 260, 140, *10 resource-main\Common Use\Stamina.bmp
                Sleep 50
            } Until (ErrorLevel = 1)
            Send 1
            If (SPR = "Rhythm") or (SPR = "Rhythm+Flow") {
                SetTimer, sendrhythm, -1000
            }
        } else If (SPAWS = 0) {
            Send {BackSpace}
            Sleep 100
            Send 1
            ;; run part 
            Send {Space}{w up} ; check
            Sleep 100
            Send w{w down}{up} ; run
            Sleep 3000
            Timer:=A_TickCount
            Loop,
            {
                TimerCheck:=A_TickCount-Timer
                If (TimerCheck > 60000) {
                    ;; running too long inf stam?
                }
                PixelSearch,,, 190, 130, 191, 131, 0x3A3A3A, 40, Fast ;enough stamina for sp gain
                If (ErrorLevel = 0) {
                    Send {w up}
                    If (SPR = "Rhythm") or (SPR = "Rhythm+Flow") {
                        SetTimer, sendrhythm, -300
                    }
                    HUH:=A_TickCount    
                    Break
                }
                ImageSearch,,, 20, 120, 260, 140, *10 resource-main\Common Use\Stamina.bmp
                if (ErrorLevel = 0) {
                    goto, re
                }
            }
        }
    } else {
        SetMouseDelay, 10
        Click, 50
        Click, Right
        ;; low stam timer check
        STAMCHECK:=A_TickCount-HUH
        If (STAMCHECK > 240000) {
            ;; been punching nonstop for over 4 minute can be inf stamina? ;; might be unequip combat
            MsgBox, Your Stamina is freezing
        }
    }
    ;; low stam

    If (SPA = "Low") {
        PixelSearch ,,, 40, 130, 60, 133, 0x3A3A3A, 40, Fast
        If (ErrorLevel = 0) {
            gosub, WaitSp
            
        }
    } else If (SPA = "Medium") {
        PixelSearch ,,, 40, 130, 50, 133, 0x3A3A3A, 40, Fast
        If (ErrorLevel = 0) {
            gosub, WaitSp
        }
    } else If (SPA = "High") {
        PixelSearch ,,, 40, 130, 40, 133, 0x3A3A3A, 40, Fast
        If (ErrorLevel = 0) {
            gosub, WaitSp
        }
    } 
    
    ;; Autoeat
    If (SPE != "None") {
        PixelSearch,,, 55, 145, 56, 145, 0x3A3A3A, 40, Fast ; Hungry
        If (ErrorLevel = 0) {
            Send {Shift}{BackSpace}
            Gosub, AutoEatSP
            Send 1
            Loop, ;; have to wait until stamina is full incase something stopped 
            {
                ImageSearch,,, 20, 120, 260, 140, *10 resource-main\Common Use\Stamina.bmp
                If (ErrorLevel = 0) {
                    Break
                }
                ImageSearch,,, 20, 85, 170, 110, *20 resource-main\Common use\combat.bmp
                If (ErrorLevel = 0) {
                    If (TAAC = 1) {
                        Gosub, RecordUsername
                    }
                    Gosub, Waitforcombat
                }
                ;; Combat
            }
            Send {Shift}
        }
    }

    ;; combat 
    ImageSearch,,, 20, 85, 170, 110, *20 resource-main\Common use\combat.bmp
    If (ErrorLevel = 0) {
        If (TAAC = 1) {
            Gosub, RecordUsername
        }
        Gosub, Waitforcombat
    }
}
Return

RMT:
    tooltip
Return