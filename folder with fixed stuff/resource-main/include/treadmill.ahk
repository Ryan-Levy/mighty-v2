

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
        }
    }
}

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
