Unz(sZip, sUnz)	{
	FileCreateDir, %sUnz%
    psh  := ComObjCreate("Shell.Application")
    psh.Namespace( sUnz ).CopyHere( psh.Namespace( sZip ).items, 4|16 )
}
WM_LBUTTONDOWN() {
  If A_Gui
    PostMessage, 0xA1, 2
}
GetUrlStatus( URL, Timeout = -1 )
{
    ComObjError(0)
    static WinHttpReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")

    WinHttpReq.Open("HEAD", URL, True)
    WinHttpReq.Send()
    WinHttpReq.WaitForResponse(Timeout) ; Return: Success = -1, Timeout = 0, No response = Empty String

    Return, WinHttpReq.Status()
}
sendsc(keyspe) {
    thatkey := format("sc{:x}", getKeySC(keyspe))
    send {%thatkey%}
}

DiscordSend(m,p) {
    postdata={"username":"i love vivace's macro","content":"%p% %m%"}
    return postdata
}
y(var) {
    if (var = 6) {
        y = 400
    } else if (var = 5) {
        y = 370
    } else if (var = 4) {
        y = 340
    } else if (var = 3) {
        y = 280
    } else if (var = 2) {
        y = 250
    } else if (var = 1) {
        y = 220
    }
    return y
}
runfunction(direction) {
    if (direction = 1) { ; left
        sc("w", 3)sc("w", 1)
        send {left down}
        sleep 2000
        send {left up}
        sc("w", 2)
    } else if (direction = 2) { ; right
        sc("w", 3)sc("w", 1)
        send {right down}
        sleep 2000
        send {right up}
        sc("w", 2)
    }
}
siderunfunction(direction) {
    If (direction = 1) { ; a key
        sc("w", 3)sc("w", 1)sc("a", 1)
        send, {up}
        sleep 1000
        sc("w", 2)sc("a", 2)
    } else If (direction = 2) {
        sc("w", 3)sc("w", 1)sc("d", 1)
        send, {up}
        sleep 1000
        sc("w", 2)sc("d", 2)
    }
}
walkfunction(direction) {
    if (direction = 1) { ; left
        sc("w", 1)
        send {left down}
        sleep 2000
        send {left up}
        sc("w", 2)
    } else if (direction = 2) { ; right
        sc("w", 1)
        send {right down}
        sleep 2000
        send {right up}
        sc("w", 2)
    }
}
sidewalkfunction(direction) {
    If (direction = 1) { ; a key
        sc("a", 1)
        sleep 1000
        sc("a", 2)
    } else If (direction = 2) {
        sc("d", 1)
        sleep 1000
        sc("d", 2)
    }
}

dash(direction) {
    if (direction = 1) { ;; 4 direction
        sc("w", 1)
    } else if (direction = 2) { 
        sc("a", 1)
    } else if (direction = 3) { 
        sc("d", 1)
    } else if (direction = 4) { 
        sc("s", 1)
    }
    Send {space down}
    Sleep 50
    sc("q", 3)
    Send {space up}
    if (direction = 1) { ;; 4 direction
        sc("w", 2)
    } else if (direction = 2) { 
        sc("a", 2)
    } else if (direction = 3) { 
        sc("d", 2)
    } else if (direction = 4) { 
        sc("s", 2)
    }
}
sc(key,type) {
    thatkey := format("sc{:x}", getKeySC(key))
    if (type = 1) {
        Send {%thatkey% down}
    } else if (type = 2) {
        Send {%thatkey% up}        
    } else if (type = 3) {
        send {%thatkey%}
    }
}

AutoEatWeight:
    If (WE = "Food") {
        Slot:="1,2,3,4,5,6,7,8,9,0"
    } else if (WE = "Food+Protein") {
        Slot:="2,3,4,5,6,7,8,9,0"
    }
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
                        Goto, AutoEatWeight
                    }
                } else If (ErrorLevel = 1) {
                    Return
                }
                ImageSearch,,, 20, 85, 170, 110, *20 resource-main\Common use\combat.bmp
                If (ErrorLevel = 0) {
                    Gosub, RecordUsername
                    Gosub, Waitforcombat
                }
                ;; Search for combat here
            }
        }
    }
    If (WE = "Food" or WE = "Food+Protein") {
        sendsc("``")
        MouseMove, 100, 480
        Sleep 600
        xx=95
        Loop = 10
        Loop, %Loop%
        {
            ImageSearch, x, y, 90, 195, 675, 500, *10 %A_WorkingDir%/resource-main/Common Use/x5.bmp
            If (ErrorLevel = 0) {
                Sleep 40
                Click, %x%, %y%, Down
                Sleep 50
                Click, %xx%, 555, Up
                Sleep 60
                xx:=xx+70
            } else If (ErrorLevel = 1) {
                If (A_Index = 1) {
                    MsgBox, Food Ranout ;;  Food ran out of inventory + Break
                    ExitApp
                }
                Break
            }   
        }
        MouseMove, 100, 480
        sendsc("``") 
        Sleep 300
        Gosub, AutoEatWeight
    } ;; doesn't have slot eat for weight
Return
AutoEatTread:
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
                        Goto, AutoEatTread
                    }
                } else If (ErrorLevel = 1) {
                    Return
                }
                ImageSearch,,, 20, 85, 170, 110, *20 resource-main\Common use\combat.bmp
                If (ErrorLevel = 0) {
                    Gosub, RecordUsername
                    Gosub, Waitforcombat
                }
                ;; Search for combat here
            }
        }
    }
    If (TE = "SlotEat") {
        MsgBox, Food Ranout ;; Send Webhook After not found food in any slot
    } else if (TE = "Slot+Inventory") {
        sendsc("``") ;open inv
        MouseMove, 100, 480
        Sleep 600
        xx=95
        Loop = 10
        Loop, %Loop%
        {
            ImageSearch, x, y, 90, 195, 675, 500, *10 %A_WorkingDir%/resource-main/Common Use/x5.bmp
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
    Gosub, AutoEatTread
Return
Check:
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
        Tooltip, %TaskSleep% %TaskTimer%, 650, 600
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


RecordUsername:
    SetMouseDelay, 5
    ;RECTYPE = "Record"
    ;RECKEY = "{F12}"

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
        Click, WheelUp 10
        Sleep 100
    }

    Gosub, CheckName

    Click, 805, 160, Down
    Click, 805, 285, Up

    Gosub, CheckName
    
    If (RECTYPE = "Record") {
        Send %RECKEY%
    } else if (RECTYPE = "Shadow") {
        Send %RECKEY%
    }
Return
CheckName:
    vale = 108
    Loop, 14
    {
        y:=vale+14
        MouseMove, 765, %y%
        vale:=vale+31
        Sleep 150
    }
Return
WaitWeight:
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
        Tooltip, %TaskSleep% %TaskTimer%, 650, 600
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
Return
AutoEatSP:
    Slot:="2,3,4,5,6,7,8,9,0"
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
                        Goto, AutoEatSP
                    }
                } else If (ErrorLevel = 1) {
                    Return
                }
                ;; Search for combat here
            }
        }
    }
    If (SPE = "SlotEat") {
        ;; Send Webhook After not found food in any slot
    } else if (SPE = "Slot+Inventory") {
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
    Gosub, AutoEatSP
Return
Waitforcombat:
    ImageSearch,,, 20, 85, 170, 110, *20 resource-main\Common use\combat.bmp
    If (ErrorLevel = 0) {
        tooltip found combat
        Loop,
        {
            Sleep 30
            ImageSearch,,, 20, 85, 170, 110, *20 resource-main\Common use\combat.bmp
            If (ErrorLevel = 1) {
                Break
            } else If (ErrorLevel = 0) {
                PixelSearch,,, 40, 130, 40, 133, 0x3A3A3A, 40, Fast
                If (ErrorLevel = 1) { ;; if stam enough
                    Gosub, Combat1
                } else if (ErrorLevel = 0) { ;; if low stam walk
                    Loop, 5
                    {
                        Gosub, Combat2
                    }   
                }
            }
            ImageSearch,,, 670, 45, 755, 55, *5 resource-main\Common use\gripped.bmp
            If (ErrorLevel = 0) {
                Tooltip, Gripped, 650, 600
                Return
            }
        } 
    }
    CombatTask := A_TickCount
    Loop,
    {
        ImageSearch,,, 20, 85, 170, 110, *20 resource-main\Common use\combat.bmp
        If (ErrorLevel = 0) {
            Goto, Waitforcombat
        }
        tooltip, Combat Is Gone, 650, 600
    } Until A_TickCount - CombatTask > 5000
    tooltip, Combat Is Gone
    MsgBox, Stopped
Return
Combat1:
    Random, oVar, 1, 2
    If (oVar = 1) {
        Random, oVar, 1, 2
        If (oVar = 2) {
            Random, oVar, 1, 2
            siderunfunction(oVar)
        } else if (oVar = 1) {
            Random, oVar, 1, 2
            runfunction(oVar)
        } 
    } else If (oVar = 2) {
        Random, oVar, 1, 4
        dash(oVar)
    }
return
Combat2:
    Random, oVar, 1, 2
    If (oVar = 2) {
        Random, oVar, 1, 2
        sidewalkfunction(oVar)
    } else if (oVar = 1) {
        Random, oVar, 1, 2
        walkfunction(oVar)
    } 
Return

stacss:
    Gui, Submit
    Gui, Destroy
    Goto, Skip4
Return
stasrv:
    Gui, Submit
    Gui, Destroy
    Goto, Skip5
Return