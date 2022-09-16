StartSPMac:
CoordMode, Tooltip, Window
Tooltip, J Reload K Pause L Exit, 650, 550, 2
ToolTip, Started StrikePower, 650, 600
gosub, Check
Send {BackSpace}{Click, Right}
Sleep 100
Send 1{Shift}
Tooltip, Please Have Shift Lock On
SetTimer, RMT , 3000
Loop,
{
    Gosub, Check
    re:
    TimerCheck:=A_TickCount-Timer
    If (TimerCheck > 40000) or (TimerCheck = "") {
        can = true
    } 
    ImageSearch,,, 20, 120, 260, 140, *10 %A_WorkingDir%/resource-main/StrikePower/Stamina.bmp
    If (ErrorLevel = 0) {
        if (can = true) {
            ;; Check for combat tool if equip or not
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
                PixelSearch,,, 200, 130, 201, 131, 0x3A3A3A, 40, Fast ;enough stamina for sp gain
                If (ErrorLevel = 0) {
                    Send {w up}
                    If (SPR = 1) {
                        Sleep 100
                        Send r
                    }
                    HUH:=A_TickCount    
                    Break
                }
                ImageSearch,,, 20, 120, 260, 140, *10 %A_WorkingDir%/resource-main/StrikePower/Stamina.bmp
                if (ErrorLevel = 0) {
                    goto, re
                }
            }
            can = false
        } else {
            SetMouseDelay, 10
            Click, 50
            Click, Right
            ;; low stam timer check
            STAMCHECK:=A_TickCount-HUH
            If (STAMCHECK > 120000) {
                ;; been punching nonstop for over 2 minute can be inf stamina? ;; might be unequip combat
                
            }
        }
    } else {
        SetMouseDelay, 10
        Click, 50
        Click, Right
        ;; low stam timer check
        STAMCHECK:=A_TickCount-HUH
        If (STAMCHECK > 120000) {
            ;; been punching nonstop for over 2 minute can be inf stamina? ;; might be unequip combat
            
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
                ImageSearch,,, 20, 120, 260, 140, *10 %A_WorkingDir%/resource-main/StrikePower/Stamina.bmp
                If (ErrorLevel = 0) {
                    Break
                }
                ;; Combat
            }
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