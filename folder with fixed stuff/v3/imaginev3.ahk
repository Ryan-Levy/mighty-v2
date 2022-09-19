#Persistent
#SingleInstance, force
#NoEnv
If (A_ScreenDPI != 96) { ;; checking scale and layout
    MsgBox,	16,Vivace's Macro, Your Scale `& layout settings need to be on 100`%
    ;; might add a option that ask if you want to use 100% scale
    ExitApp
}
SetCapsLockState, Off ;; uncapslock
;; faster load
SetBatchLines, -1
SetKeyDelay, -1
SetMouseDelay, -1
;; coord mode
CoordMode, Pixel, Window
CoordMode, Mouse, Window
;; Drag gui
OnMessage(0x201, "WM_LBUTTONDOWN") ;; first function
If !FileExist("settings.ini") {
    FileAppend,, settings.ini
    Reload
    Return
} else {
    IniRead, Webhook, settings.ini, Notifications, Webhook
    IniRead, UserID, settings.ini, Notifications, UserID
    if ((Webhook = "ERROR") or (UserID = "ERROR") or (UserID = "<@>") or (Webhook = "") or (UserID = "")) {
        Gosub, CreateWebhookGui
        Return
    } else {
        Goto, main
    }
}

;; main

main:
{
    if (Webhook = true) { ;; making thing ready
        req := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        req.Open("POST", webhook, true)
        req.SetRequestHeader("Content-Type", "application/json")
    }
    ;; Start Read Saved Data from settings.ini
    gosub, LoadData
    ;; load gui
    gosub, LoadMainGui
    Hidethis:="SPTab,vvtext1,vvtext2,vvtext3,vvtext4,vvtext5,SPA,SPR,SPE,SPD,SPASR,SPAAC,SPAAL,SPAWS,3button,2Button,WeightTab,vtext1,vtext2,vtext3,vtext4,vtext5,WL,WE,WD,WA,WASD,WASR,WAAC,WAAL,Button,TreadmillTab,TS,TL,TE,TD,TA,text1,text2,text3,text4,text5,text6,TASD,TASS,TASR,TAAC,TAAL"
    Loop, Parse, Hidethis, `,
    {
        GuiControl, Hide, %A_LoopField%
    }
    ;; load saved ddl
    CheckBox:="SPASR,SPAAC,SPAAL,SPAWS,WASD,WASR,WAAC,WAAL,TASD,TASS,TASR,TAAC,TAAL"
    Loop, Parse, CheckBox, `,
    {
        If (%A_LoopField% = "ERROR") {
            %A_LoopField% = 0
        }
    }
    gosub, SetOptions
    Gui, Show , h300 w700, Vivace's Macro
    WinSet, Region, 0-0 h300 w700 R15-15,Vivace's Macro
}
Return
;; sub main
StartTread:
    Gui, Submit
    Gui, Destroy
    If (TS = "" or TL = "" or TE = "" or TD = "" or TA = "" or TASD = "" or TASS = "" or = ""TASR = "" or TAAC = "" or TAAL = "") {
        MsgBox,,Vivace's Macro,You have incomplete information.
        ExitApp
    }
    IniWrite, %TS%, settings.ini, Treadmill, TS
    IniWrite, %TL%, settings.ini, Treadmill, TL
    IniWrite, %TE%, settings.ini, Treadmill, TE
    IniWrite, %TD%, settings.ini, Treadmill, TD
    IniWrite, %TA%, settings.ini, Treadmill, TA
    IniWrite, %TASD%, settings.ini, AdvTreadmill, TASD
    IniWrite, %TASS%, settings.ini, AdvTreadmill, TASS
    IniWrite, %TASR%, settings.ini, AdvTreadmill, TASR
    IniWrite, %TAAC%, settings.ini, AdvTreadmill, TAAC
    IniWrite, %TAAL%, settings.ini, AdvTreadmill, TAAL
    If (TD = "Fatigue Estimate") {
        Gui, Add, Text, y10,How Many Round:
        Gui, Add, Edit, ym vRound number,
        Gui, Add, Button, ym gtd, Done 
        Gui, Show,, Vivace's Macro
        Return
    }
    td:
    {
        Gui, Submit
        Gui, Destroy
    }
    If (TAAC = 1) {
        IniRead, KeyCombo, settings.ini, Record, RECKEY
        IniRead, List, settings.ini, Record, RECTYPE
        if (KeyCombo = "" or List = "" or KeyCombo = "ERROR" or List = "ERROR") {
            Gui, Add, Text, y10,Record Key:
            Gui, Add, DDL, +Theme ym vKeyCombo , Win+Alt+G|F8|F12
            Gui, Add, Button, ym gRecorder, Done
            Gui, Add, Text, xm,Record Type:
            Gui, Add, DDL, +Theme x79 y30 vList, Record|ShadowPlay
            Gui, Show,, Vivace's Macro
            Return
        }
    }
    Recorder:
    {
        Gui, Submit
        Gui, Destroy
        Gosub, RecordStuff
    }
    If (TASS = 1) {
        Gui, Add, Text, y10,Start Delay Enabled:
        Gui, Add, Edit, Number ym vTASSV,
        Gui, Add, Button, ym gstacss, Done
        Gui, Show,, Vivace's Macro
        Return
    } else If (TASS = 0) {
        TASSV = 0
    }
    stacss:
    {
        Gui, Submit
        Gui, Destroy
    }
    If (TASR = 1) {
        Gui, Add, Text, y10,Rest Delay Enabled:
        Gui, Add, Edit, Number ym vTASRV,
        Gui, Add, Button, ym gstasrv, Done
        Gui, Show,, Vivace's Macro
        Return
    } else If (TASR = 0) {
        TASRV = 9000
    }
    stasrv:
    {
        Gui, Submit
        Gui, Destroy        
    }
    Loop,
    {
        Gosub, Check
        If (TE != "None") {
            PixelSearch,,, 55, 145, 56, 145, 0x3A3A3A, 40, Fast
            If (ErrorLevel = 0) {
                Click, 410, 345
                Sleep 1000
                Gosub, TreadEat
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
                                If (Webhook = true) {
                                    WinHttpReq.Send(DiscordSend("You are pushed away from treadmill",UserID))
                                } else if (Webhook = false) {
                                    MsgBox, Not Found ;; Send Webhook and stop
                                }
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
StartSP:
    Gui, Submit
    Gui, Destroy
    If (SPR = "" or SPA = "" or SPD = "" or SPE = "" or SPAWS = "" or SPASR = "" or SPAAC = "" or SPAAL = "") {
        msgbox,,Vivace's Macro,You have incomplete information.
        ExitApp
    }
    IniWrite, %SPR%, settings.ini, StrikePower, SPR
    IniWrite, %SPA%, settings.ini, StrikePower, SPA
    IniWrite, %SPD%, settings.ini, StrikePower, SPD
    IniWrite, %SPE%, settings.ini, StrikePower, SPE
    IniWrite, %SPAWS%, settings.ini, AdvStrikePower, SPAWS
    IniWrite, %SPASR%, settings.ini, AdvStrikePower, SPASR
    IniWrite, %SPAAC%, settings.ini, AdvStrikePower, SPAAC
    IniWrite, %SPAAL%, settings.ini, AdvStrikePower, SPAAL
    If (SPD = "Fatigue Estimate") {
        Gui, Add, Text, y10,How Many Round:
        Gui, Add, Edit, ym vRound number,
        Gui, Add, Button, ym gSPD, Done 
        Gui, Show,, Vivace's Macro
        Return
    }
    SPD:
    {
        Gui, Submit
        Gui, Destroy
    }
    If (SPAAC = 1) {
        IniRead, KeyCombo, settings.ini, Record, RECKEY
        IniRead, List, settings.ini, Record, RECTYPE
        if (KeyCombo = "" or List = "" or KeyCombo = "ERROR" or List = "ERROR") {
            Gui, Add, Text, y10,Record Key:
            Gui, Add, DDL, +Theme ym vKeyCombo , Win+Alt+G|F8|F12
            Gui, Add, Button, ym gRecorderr, Done
            Gui, Add, Text, xm,Record Type:
            Gui, Add, DDL, +Theme x79 y30 vList, Record|ShadowPlay
            Gui, Show,, Vivace's Macro
            Return
        }
    }
    Recorderr:
    {
        Gui, Submit
        Gui, Destroy
        Gosub, RecordStuff
    }
    If (SPSR = 1) {
        Gui, Add, Text, y10,Rest Delay Enabled:
        Gui, Add, Edit, Number ym vSPSRV,
        Gui, Add, Button, ym gstspsr, Done
        Gui, Show,, Vivace's Macro
    } else If (SPSR = 0) {
        SPSRV = 9000
    }
    stspr:
    {
        Gui, Submit
        Gui, Destroy
    }
    gosub, Check
    Send {BackSpace}{Click, Right}
    Sleep 100
    Send 1{Shift}
    Sleep 100
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
                    ImageSearch,,, 20, 85, 170, 110, *20 resource-main\Common use\combat.bmp
                    If (ErrorLevel = 0) {
                        If (TAAC = 1) {
                            Gosub, RecordUsername
                        }
                        Gosub, Waitforcombat
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
                Gosub, SpEat
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
StartWeight:
Return
;; function

WM_LBUTTONDOWN() {
    If A_Gui
        PostMessage, 0xA1, 2
}
GetUrlStatus( URL, Timeout = -1 ) {
    ComObjError(0)
    static WinHttpReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WinHttpReq.Open("HEAD", URL, True)
    WinHttpReq.Send()
    WinHttpReq.WaitForResponse(Timeout) ; Return: Success = -1, Timeout = 0, No response = Empty String
    Return, WinHttpReq.Status()
}
DiscordSend(m,p) {
    postdata={"username":"i love vivace's macro","content":"%p% %m%"}
    Return postdata
}
sendsc(keyspe) {
    thatkey := format("sc{:x}", getKeySC(keyspe))
    send {%thatkey%}
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
;; sub
LoadMainGui:
    Gui, -Caption
    Gui, +AlwaysOnTop
    Gui, Add, Text, x30 y8, Vivace's Macro

    ;; - - - treadmill
    Gui, Add, Picture, w20 h20 x5 y5, bin/ico.ico
    ;; group picture 
    Gui, Add, Picture, ggit w16 h16 X620 y10, bin/git.png
    Gui, Add, Picture, gcopy w16 h16 X645 y10, bin/discord.png
    Gui, Add, Picture, gminimize w16 h16 X670 y10, bin/Minimize.png
    Gui, Add, Picture, gtest w32 h32 x10 y30, bin/tab/Treadmill.png
    Gui, Add, Picture, gtest2 w32 h32 x10 y75, bin/tab/Weight.png
    Gui, Add, Picture, gtest3 w32 h32 x10 y110, bin/tab/sp.png
    Gui, Add, Picture, gtest2 w32 h32 x10 y155, bin/tab/ss.png

    Gui, Add, GroupBox,  x50 y30 w630 h250 vTreadmillTab, Treadmill's Option

    Gui, Add, Text,xm+55 ym+50 vtext1 ,Which stat do you want to train?
    Gui, Add, DropDownList, vTS ,Stamina|RunningSpeed
    Gui, Add, Text, vtext2,Which Level?
    Gui, Add, DropDownList, vTL ,Auto|5|4|3|2|1
    Gui, Add, Text, vtext3,Auto Eat Options
    Gui, Add, DropDownList,vTE ,None|Slot Eat|Slot+Inventory

    Gui, Add, Text,xm+250 ym+50 vtext4,Duration Options?
    Gui, Add, DropDownList,vTD ,Macro Indefinitely|Fatigue estimate
    Gui, Add, Text, vtext5,What's Your Stamina Amount?
    Gui, Add, DropDownList, vTA ,High|Medium|Low

    ;; advance

    Gui, Add, Text,xm+445 ym+50 vtext6,Advance Options

    Gui, Add, Checkbox, vTASD ,Stamina Detection
    Gui, Add, Checkbox, vTASS ,Set Start Delay
    Gui, Add, Checkbox, vTASR ,Set Rest Delay
    Gui, Add, Checkbox, vTAAC ,Auto Clip 
    Gui, Add, Checkbox, vTAAL ,Auto Leave 

    Gui, Add, Button,xm+321 ym+240 vbutton gStartTread ,Done ;; start button

    ;; - - - end treadmill gui

    ;; - - -weight
    Gui, Add, GroupBox,  x50 y30 w630 h250 vWeightTab, Weight Machine's Option

    Gui, Add, Text, xm+55 ym+50 vvtext1,Which Level?
    Gui, Add, DropDownList, vWL,Auto|6|5|4|3|2|1
    Gui, Add, Text, vvtext2,Auto Eat Options`,Protein on slot 1
    Gui, Add, DropDownList, vWE ,None|Food|Protein|Food+Protein

    Gui, Add, Text,xm+250 ym+50 vvtext3,Duration Options?
    Gui, Add, DropDownList, vWD,Macro Indefinitely|Fatigue estimate
    Gui, Add, Text, vvtext4,What's Your Stamina Amount?
    Gui, Add, DropDownList, vWA ,High|Medium|Low

    Gui, Add, Text,xm+445 ym+50 vvtext5,Advance Options
    Gui, Add, Checkbox, vWASD ,Stamina Detection
    Gui, Add, Checkbox, vWASR ,Set Rest Delay
    Gui, Add, Checkbox, vWAAC ,Auto Clip 
    Gui, Add, Checkbox, vWAAL ,Auto Leave 

    Gui, Add, Button,xm+321 ym+240 v2button gStartWeight ,Done ;; start button
    ;;; end weight


    ;; strike power
    Gui, Add, GroupBox,  x50 y30 w630 h250 vSPTab, Strike Power's Option

    Gui, Add, Text, xm+55 ym+50 vvvtext1,Rhythm Flow Options
    Gui, Add, DropDownList, vSPR,None|Rhythm|Rhythm+Flow
    Gui, Add, Text, vvvtext2,What's Your Stamina Amount?
    Gui, Add, DropDownList, vSPA ,High|Medium|Low

    Gui, Add, Text, xm+250 ym+50 vvvtext3 ,Duration Options?
    Gui, Add, DropDownList,vSPD ,Macro Indefinitely|Fatigue estimate
    Gui, Add, Text, vvvtext4 ,Auto Eat Options
    Gui, Add, DropDownList, vSPE ,None|Slot Eat|Slot+Inventory 

    Gui, Add, Text,xm+445 ym+50 vvvtext5 ,Advance Options

    Gui, Add, Checkbox, vSPAWS ,Drain Move on 2
    Gui, Add, Checkbox, vSPASR ,Set Rest Delay
    Gui, Add, Checkbox, vSPAAC ,Auto Clip 
    Gui, Add, Checkbox, vSPAAL ,Auto Leave 

    Gui, Add, Button,xm+321 ym+240 v3button gStartSP ,Done ;; start button
Return
SubmitWebhook:
    Gui, Submit
    Gui, Destroy
    Webhook = true
    test:=GetUrlStatus(Webhook, 10)
    if (test = "-1") {
        WinHttpReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        WinHttpReq.Open("POST", Webhook, true)
        WinHttpReq.SetRequestHeader("Content-Type", "application/json")
        WinHttpReq.Send(DiscordSend("tessstwoord",UserID))
        Msgbox, 4, Vivace's Macro, Did you receive the ping?
        IfMsgBox no
        {
            Reload
            ExitApp
        } else {
            IniWrite, %Webhook%, settings.ini, Notifications, Webhook
            IniWrite, <@%UserID%>, settings.ini, Notifications, UserID
        }
    } else if (test = "") {
        MsgBox, 16, Vivace's Macro, Invalid link
        ExitApp
    } else {
        MsgBox, 16, Vivace's Macro, Timed out
        ExitApp
    }
    goto, main
Return
NotSubmitWebhook:
    Gui, Destroy
    Webhook = false
    goto, main
Return
CreateWebhookGui:
    Gui, Add, Text, y10,Webhook:  
    Gui, Add, Edit,  ym vWebhook ,
    Gui, Add, Button, ym gSubmitWebhook, Done
    Gui, Add, Button, ym gNotSubmitWebhook, NO
    Gui, Add, Text, xm,UserID:
    Gui, Add, Edit, x70 y30 Number vUserID, 
    Gui, Show,, Vivace's Macro
Return
LoadData:
    ;;Treadmill
    ; TS  = Treadmill Training
    ; TL = Treadmill Level
    ; TE = Treadmill Eat Option
    ; TD = Treadmill Duration Options
    ; TA = Treadmill Stamina Amount 
    IniRead, TS, settings.ini, Treadmill, TS
    IniRead, TL, settings.ini, Treadmill, TL
    IniRead, TE, settings.ini, Treadmill, TE
    IniRead, TD, settings.ini, Treadmill, TD
    IniRead, TA, settings.ini, Treadmill, TA

    ;; AdvTreadmill
    ; TASD = Stamina Detection
    ; TASS = Set Start Delay
    ; TASR = Set Rest Delay
    ; TAAC = Auto Clip 
    ; TAAL = Auto Leave 
    IniRead, TASD, settings.ini, AdvTreadmill, TASD
    IniRead, TASS, settings.ini, AdvTreadmill, TASS
    IniRead, TASR, settings.ini, AdvTreadmill, TASR
    IniRead, TAAC, settings.ini, AdvTreadmill, TAAC
    IniRead, TAAL, settings.ini, AdvTreadmill, TAAL

    ;;Weight
    ; WL = Weight Level
    ; WE = Weight Eat Option
    ; WD = Weight Duration Options
    ; WA = Weight Stamina Amount 
    IniRead, WL, settings.ini, Weight, WL
    IniRead, WE, settings.ini, Weight, WE
    IniRead, WD, settings.ini, Weight, WD
    IniRead, WA, settings.ini, Weight, WA

    ;; AdvWeight
    ; WASD = Stamina Detection
    ; WASR = Set Rest Delay
    ; WAAC = Auto Clip
    ; WAAL = Auto Leave
    IniRead, WASD, settings.ini, AdvWeight, WASD
    IniRead, WASR, settings.ini, AdvWeight, WASR
    IniRead, WAAC, settings.ini, AdvWeight, WAAC
    IniRead, WAAL, settings.ini, AdvWeight, WAAL

    ;;STRIKEPOWER
    ; SPR = Strike Power Ryhthm Options
    ; SPA = Stamina Amount
    ; SPD = Duration
    ; SPE = Eat options
    IniRead, SPR, settings.ini, StrikePower, SPR
    IniRead, SPA, settings.ini, StrikePower, SPA
    IniRead, SPD, settings.ini, StrikePower, SPD
    IniRead, SPE, settings.ini, StrikePower, SPE

    ;; AdvStrikePower
    ; SPAWS = Set Weave
    ; SPASR = Set Rest Delay
    ; SPAAC = Auto Clip
    ; SPAAL = Auto Leave
    IniRead, SPAWS, settings.ini, AdvStrikePower, SPAWS
    IniRead, SPASR, settings.ini, AdvStrikePower, SPASR
    IniRead, SPAAC, settings.ini, AdvStrikePower, SPAAC
    IniRead, SPAAL, settings.ini, AdvStrikePower, SPAAL


    ;;STRIKESPEED
    ; SSE = Eat options
    ; SSD = Duration
    IniRead, SSE, settings.ini, StrikeSpeed, SSE
    IniRead, SSD, settings.ini, StrikeSpeed, SSD

    ;; AdvStrikeSpeed
    ; SSALT = Log Training
    ; SSAAC = Auto Clip
    ; SSAAL = Auto Leave
    IniRead, SSALT, settings.ini, AdvStrikeSpeed, SSALT
    IniRead, SSAAC, settings.ini, AdvStrikeSpeed, SSAAC
    IniRead, SSAAL, settings.ini, AdvStrikeSpeed, SSAAL
Return
Minimize:
    ExitApp
Return
copy:
    Run, discord://discord.com/invite/4rxfjtnMGt
    Clipboard := "https://discord.com/invite/4rxfjtnMGt"
Return
git:
    Run, https://github.com/Cweamy/Mighty-Omega-Macro
Return
test:
    Showthis:="Button,TreadmillTab,TS,TL,TE,TD,TA,text1,text2,text3,text4,text5,text6,TASD,TASS,TASR,TAAC,TAAL" 
    Hidethis:="2Button,WeightTab,vtext1,vtext2,vtext3,vtext4,vtext5,WL,WE,WD,WA,WASD,WASR,WAAC,WAAL,SPTab,vvtext1,vvtext2,vvtext3,vvtext4,vvtext5,SPA,SPR,SPE,SPD,SPASR,SPAAC,SPAAL,SPAWS,3button"
    Loop,Parse,Showthis,`,
    {
        GuiControl, Show, %A_LoopField%
    }
    Loop,Parse,Hidethis,`,
    {
        GuiControl, Hide, %A_LoopField%
    }
Return
test2:
    Showthis:="2Button,WeightTab,vtext1,vtext2,vtext3,vtext4,vtext5,WL,WE,WD,WA,WASD,WASR,WAAC,WAAL"
    Hidethis:="Button,TreadmillTab,TS,TL,TE,TD,TA,text1,text2,text3,text4,text5,text6,TASD,TASS,TASR,TAAC,TAAL,SPTab,vvtext1,vvtext2,vvtext3,vvtext4,vvtext5,SPA,SPR,SPE,SPD,SPASR,SPAAC,SPAAL,SPAWS,3button"
    Loop, Parse, Hidethis, `,
    {
        GuiControl, Hide, %A_LoopField%
    }
    Loop, Parse, Showthis, `,
    {
        GuiControl, Show, %A_LoopField%
    }
Return
test3:
    Showthis:="SPTab,vvtext1,vvtext2,vvtext3,vvtext4,vvtext5,SPA,SPR,SPE,SPD,SPASR,SPAAC,SPAAL,SPAWS,3button"
    Hidethis:="2Button,WeightTab,vtext1,vtext2,vtext3,vtext4,vtext5,WL,WE,WD,WA,WASD,WASR,WAAC,WAAL,SPTab,vvtext1,vvtext2,vvtext3,vvtext4,vvtext5,Button,TreadmillTab,TS,TL,TE,TD,TA,text1,text2,text3,text4,text5,text6,TASD,TASS,TASR,TAAC,TAAL"
    Loop, Parse, Hidethis, `,
    {
        GuiControl, Hide, %A_LoopField%
    }
    Loop, Parse, Showthis, `,
    {
        GuiControl, Show, %A_LoopField%
    }
Return
SetOptions:
    GuiControl,, TASD, %TASD%
    GuiControl,, TASS, %TASS%
    GuiControl,, TASR, %TASR%
    GuiControl,, TAAC, %TAAC%
    GuiControl,, TAAL, %TAAL%

    GuiControl,, WASD, %WASD%
    GuiControl,, WASR, %WASR%
    GuiControl,, WAAC, %WAAC%
    GuiControl,, WAAL, %WAAL%

    GuiControl,, SPAWS, %SPAWS%
    GuiControl,, SPASR, %SPASR%
    GuiControl,, SPAAC, %SPAAC%
    GuiControl,, SPAAL, %SPAAL%
    ;; load option on settings.ini
    GuiControl, ChooseString, TS, %TS%
    GuiControl, ChooseString, TL, %TL%
    GuiControl, ChooseString, TE, %TE%
    GuiControl, ChooseString, TD, %TD%
    GuiControl, ChooseString, TA, %TA%
    GuiControl, ChooseString, WL, %WL%
    GuiControl, ChooseString, WE, %WE%
    GuiControl, ChooseString, WD, %WD%
    GuiControl, ChooseString, WA, %WA%
    GuiControl, ChooseString, SPA, %SPA%
    GuiControl, ChooseString, SPR, %SPR%
    GuiControl, ChooseString, SPE, %SPE%
    GuiControl, ChooseString, SPD, %SPD%
Return
RecordStuff:
    If (KeyCombo = "" or List = "" or KeyCombo = "ERROR" or List = "ERROR") {
        msgbox,,Vivace's Macro,You have incomplete information.
        ExitApp
    } else if (List != "" and List !="ERROR") {
        IniWrite, %List%, settings.ini, Record, RECTYPE
    }
    if ((KeyCombo = "F8") or (KeyCombo = "F12")) {
        IniWrite, {%KeyCombo%}, settings.ini, Record, RECKEY
    } else if (KeyCombo = "Win+Alt+G") {
        IniWrite, #!g, settings.ini, Record, RECKEY
    }
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
TreadEat:
    Slot:="1,2,3,4,5,6,7,8,9,0"
    gosub, SendSlot
    If (DidEat = false) {
        If (TE = "SlotEat") {
            If (Webhook = true) {
                WinHttpReq.Send(DiscordSend("You are out of food`, Slot",UserID))
                If (TAAL = 1) {
                    Sleep 10000
                    Process, Close, RobloxPlayerBeta.exe
                    WinHttpReq.Send(DiscordSend("Logged successfully",UserID))
                } else If (TAAL = 0) {
                    WinHttpReq.Send(DiscordSend("Auto Log is disabled`, macro has stopped",UserID)) 
                }
            } 
            ExitApp
        } else If (TE "Slot+Inventory") {
            Gosub, InventoryDrag
            Gosub, TreadEat
        }
    }
Return
SpEat:
    If (SPAWS = 1) or (eat = 2) {
        Slot:= "3,4,5,6,7,8,9,0"
    } else If (SPAWS = 0) {
        Slot:="2,3,4,5,6,7,8,9,0"
    }
    gosub, SendSlot
    If (DidEat = false) {
        If (SPE = "SlotEat") {
            If (Webhook = true) {
                WinHttpReq.Send(DiscordSend("You are out of food`, Slot",UserID))
                If (SPAAL = 1) {
                    Sleep 10000
                    Process, Close, RobloxPlayerBeta.exe
                    WinHttpReq.Send(DiscordSend("Logged successfully",UserID))
                } else If (SPAAL = 0) {
                    WinHttpReq.Send(DiscordSend("Auto Log is disabled`, macro has stopped",UserID))
                }
            }
            ExitApp
        }
    }
Return

WeightEat:

Return

SsEat:

Return

Dura1Eat:

Return

SendSlot:
    Loop, Parse, Slot, `,
    {
        Send %A_LoopField%
        ImageSearch,,, 60, 520, 760, 550, resource-main\Common use\slotequip.bmp
        If (ErrorLevel = 0) {
            gosub, eat
            DidEat = true
            Break
        } else {
            DidEat = false
        }
    }
Return

Eat:
    Loop,
    {
        PixelSearch,,, 119, 144, 110, 146, 0x3A3A3A, 40, Fast ; if the hunger isn't full
        If (ErrorLevel = 0) {
            Click, 405, 620
            ImageSearch,,, 60, 520, 760, 550, bin\Common use\slotequip.bmp
            If (ErrorLevel = 1) {
                Break
            }
        } else If (ErrorLevel = 1) {
            Break
        }
        ImageSearch,,, 20, 85, 170, 110, *20 bin\Common use\combat.bmp
        If (ErrorLevel = 0) {
            Gosub, RecordUsername
            Gosub, Waitforcombat
        }
    }
Return
InventoryDrag:
    sendsc("``") ;open inv
    MouseMove, 100, 480
    Sleep 600
    xx=95
    Loop = 10
    Loop, %Loop%
    {
        ImageSearch, x, y, 90, 195, 675, 500, *10 bin/Common Use/x5.bmp
        If (ErrorLevel = 0) {
            Sleep 40
            Click, %x%, %y%, Down
            Sleep 50
            Click, %xx%, 555, Up
            Sleep 60
            xx:=xx+70
        } else If (ErrorLevel = 1) {
            If (A_Index = 1) {
                If (Webhook = true) {
                    WinHttpReq.Send(DiscordSend("You are out of food`, Inventory",UserID))
                }
                ExitApp
            }
            Break
        }   
    }
    MouseMove, 100, 480
    sendsc("``") 
    Sleep 300
Return
RMT:
    tooltip
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
sendrhythm:
    sendsc("r")
Return
WaitSp:
    If (SPASR = "0") {
        SetTimer, findc, 9000
        Sleep 9000
        ;; loop check combat here
    } else If (SPASR = "1") {
        SetTimer, findc, %SPSRV%
        Sleep %SPSRV%
        ;; loop check combat here
    }
    HUH:=A_TickCount
Return  
findc:
    ImageSearch,,, 20, 85, 170, 110, *20 bin\Common use\combat.bmp
    If (ErrorLevel = 0) {
        If (TAAC = 1) {
            Gosub, RecordUsername
        }
        Gosub, Waitforcombat
    }
Return