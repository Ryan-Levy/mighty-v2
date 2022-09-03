MsgBox, Space bar is ExitApp for now
#Persistent
#SingleInstance, force
#NoEnv
SetCapsLockState, Off ;; uncapslock
;; faster load
SetBatchLines, -1
SetKeyDelay, -1
SetMouseDelay, -1
;; coord mode
CoordMode, Pixel, Window
CoordMode, Mouse, Window
;; Drag gui
OnMessage(0x201, "WM_LBUTTONDOWN")
;;

IniRead, Webhook, settings.ini, Notifications, Webhook
IniRead, UserID, settings.ini, Notifications, UserID
if ((Webhook = "ERROR") or (UserID = "ERROR") or (UserID = "<@>") or (Webhook = "") or (UserID = "")) {
    Gui, Add, Text, y10,Webhook:  
    Gui, Add, Edit,  ym vWebhook ,
    Gui, Add, Button, ym gc, Done
    Gui, Add, Text, xm,UserID:
    Gui, Add, Edit,  x70 y30 vUserID, 
    Gui, Show,, Vivace's Macro
} else {
    goto, b
}

;; webhook gui required

Return
c:
    Gui, Submit
    Gui, Destroy
    test:=GetUrlStatus(Webhook, 10)		; 200
    If (test = "") {
        MsgBox, 16, Vivace's Macro, Invalid link
        ExitApp
    } else {
        req := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        req.Open("POST", Webhook, true)
        req.SetRequestHeader("Content-Type", "application/json")
        firsttimechecking=
        (
            {
                "username": "i love vivace's macro",
                "content": "<@%UserID%> test"
            }
        )
        req.Send(firsttimechecking)
        Msgbox, 4, Vivace's Macro, Did you receive the ping?
        IfMsgBox no
        {
            Reload
            ExitApp
        }
        IniWrite, %Webhook%, settings.ini, Notifications, Webhook
    }
    IniWrite, <@%UserID%>, settings.ini, Notifications, UserID
    goto, b
return
b:
;;

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

If (A_ScreenDPI != 96) { ;; checking scale and layout
    MsgBox,	16,Vivace's Macro, Your Scale `& layout settings need to be on 100`%
    ExitApp
}

if !FileExist("resource-main") { ;download image resource
    Tooltip, Downloading resource file. . .
    UrlDownloadToFile, https://github.com/Cweamy/resource/archive/refs/heads/main.zip, %A_WorkingDir%\resource.zip
    myzip := A_WorkingDir "\resource.zip"	
    unzipfolder := A_WorkingDir "\"	
    Unz(myzip, unzipfolder) ;auto extract file function
    FileDelete, resource.zip ; delete zip file
    Tooltip
    MsgBox, Downloaded 
}

if WinExist("Ahk_exe RobloxPlayerBeta.exe") { ;; find roblox
    WinActivate ; active roblox
    WinGetPos,,,W,H,A
    If ((W >= A_ScreenWidth ) & (H >= A_ScreenHeight)) {
        Send {F11}
        Sleep 100
    }
    if ((W > 816) or ( H > 638)) {
        WinMove, Ahk_exe RobloxPlayerBeta.exe,,,, 800, 599 
    }     
} else {
    MsgBox,16,Vivace's Macro,Roblox not active,3
    ; ExitApp
}

Gui, -Caption
Gui, +AlwaysOnTop
Gui, Add, Text, x30 y8, Vivace's Macro



;; - - - treadmill
Gui, Add, Picture, w20 h20 x5 y5, %A_WorkingDir%/resource-main/bin/ico.ico
;; group picture 
Gui, Add, Picture, ggit w16 h16 X620 y10, git.png
Gui, Add, Picture, gcopy w16 h16 X645 y10, discord.png
Gui, Add, Picture, gminimize w16 h16 X670 y10, Minimize.png
Gui, Add, Picture, gtest w32 h32 x10 y30 , Treadmill.png
Gui, Add, Picture, gtest2 w32 h32 x10 y75 , Weight.png
Gui, Add, Picture, gtest3 w32 h32 x10 y110 , sp.png
Gui, Add, Picture, gtest2 w32 h32 x10 y155 , ss.png

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

Gui, Add, Checkbox, vSPASR ,Set Rest Delay
Gui, Add, Checkbox, vSPAAC ,Auto Clip 
Gui, Add, Checkbox, vSPAAL ,Auto Leave 

Gui, Add, Button,xm+321 ym+240 v3button gStartSP ,Done ;; start button
;; load option on settings.ini

GuiControl, Hide, SPTab

GuiControl, Hide, vvtext1
GuiControl, Hide, vvtext2
GuiControl, Hide, vvtext3
GuiControl, Hide, vvtext4
GuiControl, Hide, vvtext5

GuiControl, Hide, SPA
GuiControl, Hide, SPR
GuiControl, Hide, SPE
GuiControl, Hide, SPD

GuiControl, Hide, SPASR
GuiControl, Hide, SPAAC
GuiControl, Hide, SPAAL

GuiControl, Hide, 3button
;;


GuiControl, Hide, 2Button
GuiControl, Hide, WeightTab
GuiControl, Hide, vtext1
GuiControl, Hide, vtext2
GuiControl, Hide, vtext3
GuiControl, Hide, vtext4
GuiControl, Hide, vtext5
GuiControl, Hide, WL
GuiControl, Hide, WE
GuiControl, Hide, WD
GuiControl, Hide, WA
GuiControl, Hide, WASD
GuiControl, Hide, WASR
GuiControl, Hide, WAAC
GuiControl, Hide, WAAL
;;
GuiControl, Hide, Button
GuiControl, Hide, TreadmillTab 
GuiControl, Hide, TS
GuiControl, Hide, TL
GuiControl, Hide, TE
GuiControl, Hide, TD
GuiControl, Hide, TA
GuiControl, Hide, text1
GuiControl, Hide, text2
GuiControl, Hide, text3
GuiControl, Hide, text4
GuiControl, Hide, text5
GuiControl, Hide, text6
GuiControl, Hide, TASD
GuiControl, Hide, TASS
GuiControl, Hide, TASR
GuiControl, Hide, TAAC
GuiControl, Hide, TAAL

;; load saved ddl
GuiControl, Choose, TS, %TS%
GuiControl, Choose, TL, %TL%
GuiControl, Choose, TE, %TE%
GuiControl, Choose, TD, %TD%
GuiControl, Choose, TA, %TA%

GuiControl, Choose, WL, %WL%
GuiControl, Choose, WE, %WE%
GuiControl, Choose, WD, %WD%
GuiControl, Choose, WA, %WA%

If (WASD = "ERROR") {
    WASD = 0
}
If (WASR = "ERROR") {
    WASR = 0
}
If (WAAC = "ERROR") {
    WAAC = 0
} 
If (WAAL = "ERROR") {
    WAAL = 0
}

If (TASD = "ERROR") {
    TASD = 0
}
If (TASS = "ERROR") {
    TASS = 0
}
If (TASR = "ERROR") {
    TASR = 0
}
If (TAAC = "ERROR") {
    TAAC = 0
}   
IF (TAAL = "ERROR") {
    TAAL = 0
}
    
;; adv control


GuiControl,, TASD, %TASD%
GuiControl,, TASS, %TASS%
GuiControl,, TASR, %TASR%
GuiControl,, TAAC, %TAAC%
GuiControl,, TAAL, %TAAL%

GuiControl,, WASD, %WASD%
GuiControl,, WASR, %WASR%
GuiControl,, WAAC, %WAAC%
GuiControl,, WAAL, %WAAL%


Gui, Show , h300 w700, Vivace's Macro

WinSet, Region, 0-0 h300 w700 R15-15,Vivace's Macro

Return

test:

    GuiControl, Show, Button
    GuiControl, Show, TreadmillTab 
    GuiControl, Show, TS
    GuiControl, Show, TL
    GuiControl, Show, TE
    GuiControl, Show, TD
    GuiControl, Show, TA
    GuiControl, Show, text1 
    GuiControl, Show, text2
    GuiControl, Show, text3
    GuiControl, Show, text4
    GuiControl, Show, text5
    GuiControl, Show, text6
    GuiControl, Show, TASD
    GuiControl, Show, TASS
    GuiControl, Show, TASR
    GuiControl, Show, TAAC
    GuiControl, Show, TAAL

    GuiControl, Hide, 2Button
    GuiControl, Hide, WeightTab
    GuiControl, Hide, vtext1
    GuiControl, Hide, vtext2
    GuiControl, Hide, vtext3
    GuiControl, Hide, vtext4
    GuiControl, Hide, vtext5
    GuiControl, Hide, WL
    GuiControl, Hide, WE
    GuiControl, Hide, WD
    GuiControl, Hide, WA
    GuiControl, Hide, WASD
    GuiControl, Hide, WASR
    GuiControl, Hide, WAAC
    GuiControl, Hide, WAAL
    GuiControl, Hide, SPTab
    GuiControl, Hide, vvtext1
    GuiControl, Hide, vvtext2
    GuiControl, Hide, vvtext3
    GuiControl, Hide, vvtext4
    GuiControl, Hide, vvtext5
    GuiControl, Hide, SPA
    GuiControl, Hide, SPR
    GuiControl, Hide, SPE
    GuiControl, Hide, SPD
    GuiControl, Hide, SPASR
    GuiControl, Hide, SPAAC
    GuiControl, Hide, SPAAL
    GuiControl, Hide, 3button
Return
test2:
    GuiControl, Hide, Button
    GuiControl, Hide, TreadmillTab 
    GuiControl, Hide, TS
    GuiControl, Hide, TL
    GuiControl, Hide, TE
    GuiControl, Hide, TD
    GuiControl, Hide, TA
    GuiControl, Hide, text1
    GuiControl, Hide, text2
    GuiControl, Hide, text3
    GuiControl, Hide, text4
    GuiControl, Hide, text5
    GuiControl, Hide, text6
    GuiControl, Hide, TASD
    GuiControl, Hide, TASS
    GuiControl, Hide, TASR
    GuiControl, Hide, TAAC
    GuiControl, Hide, TAAL
    GuiControl, Hide, SPTab
    GuiControl, Hide, vvtext1
    GuiControl, Hide, vvtext2
    GuiControl, Hide, vvtext3
    GuiControl, Hide, vvtext4
    GuiControl, Hide, vvtext5
    GuiControl, Hide, SPA
    GuiControl, Hide, SPR
    GuiControl, Hide, SPE
    GuiControl, Hide, SPD
    GuiControl, Hide, SPASR
    GuiControl, Hide, SPAAC
    GuiControl, Hide, SPAAL
    GuiControl, Hide, 3button

    GuiControl, Show, 2Button
    GuiControl, Show, WeightTab
    GuiControl, Show, vtext1
    GuiControl, Show, vtext2
    GuiControl, Show, vtext3
    GuiControl, Show, vtext4
    GuiControl, Show, vtext5
    GuiControl, Show, WL
    GuiControl, Show, WE
    GuiControl, Show, WD
    GuiControl, Show, WA
    GuiControl, Show, WASD
    GuiControl, Show, WASR
    GuiControl, Show, WAAC
    GuiControl, Show, WAAL
Return
test3:
    GuiControl, Hide, 2Button
    GuiControl, Hide, WeightTab
    GuiControl, Hide, vtext1
    GuiControl, Hide, vtext2
    GuiControl, Hide, vtext3
    GuiControl, Hide, vtext4
    GuiControl, Hide, vtext5
    GuiControl, Hide, WL
    GuiControl, Hide, WE
    GuiControl, Hide, WD
    GuiControl, Hide, WA
    GuiControl, Hide, WASD
    GuiControl, Hide, WASR
    GuiControl, Hide, WAAC
    GuiControl, Hide, WAAL
    GuiControl, Hide, Button
    GuiControl, Hide, TreadmillTab 
    GuiControl, Hide, TS
    GuiControl, Hide, TL
    GuiControl, Hide, TE
    GuiControl, Hide, TD
    GuiControl, Hide, TA
    GuiControl, Hide, text1
    GuiControl, Hide, text2
    GuiControl, Hide, text3
    GuiControl, Hide, text4
    GuiControl, Hide, text5
    GuiControl, Hide, text6
    GuiControl, Hide, TASD
    GuiControl, Hide, TASS
    GuiControl, Hide, TASR
    GuiControl, Hide, TAAC
    GuiControl, Hide, TAAL
    

    GuiControl, Show, SPTab
    GuiControl, Show, vvtext1
    GuiControl, Show, vvtext2
    GuiControl, Show, vvtext3
    GuiControl, Show, vvtext4
    GuiControl, Show, vvtext5
    GuiControl, Show, SPA
    GuiControl, Show, SPR
    GuiControl, Show, SPE
    GuiControl, Show, SPD
    GuiControl, Show, SPASR
    GuiControl, Show, SPAAC
    GuiControl, Show, SPAAL
    GuiControl, Show, 3button
Return
Minimize:
    ExitApp
Return
copy:
    Run, https://discord.com/invite/4rxfjtnMGt
Return
git:
    Run, https://github.com/Cweamy/Mighty-Omega-Macro
Return





StrikePower:

StrikeSpeed:

SoloDura:

DuoDura:

TrainMusce:

TrainStamina:

LoseFat:

LoseMuscle:

Weight1:
    Gui, Submit
    Gui, Destroy
    Goto, w1
Return
StartSP:

Return
StartWeight:
    Gui, Submit
    Gui, Destroy
    IniWrite, %WL%, settings.ini, Weight, WL
    IniWrite, %WE%, settings.ini, Weight, WE
    IniWrite, %WD%, settings.ini, Weight, WD
    IniWrite, %WA%, settings.ini, Weight, WA
    IniWrite, %WASD%, settings.ini, AdvWeight, WASD
    IniWrite, %WASR%, settings.ini, AdvWeight, WASR
    IniWrite, %WAAC%, settings.ini, AdvWeight, WAAC
    IniWrite, %WAAL%, settings.ini, AdvWeight, WAAL
    Eatingtype = 1
    If (WD = "Fatigue Estimate")
    {
        Gui, Add, Text, y10,How Many Round:
        Gui, Add, Edit, ym vRound number,
        Gui, Add, Button, ym gWeight1, Done 
        Gui, Show,, Vivace's Macro
        Return
    }
    w1:
    If (WAAC = 1) {
        IniRead, KeyCombo, settings.ini, Record, RECKEY
        IniRead, List, settings.ini, Record, RECTYPE
        if (KeyCombo = "" or List = "" or KeyCombo = "ERROR" or List = "ERROR") {
            Gui, Add, Text, y10,Record Key:
            Gui, Add, DDL, +Theme ym vKeyCombo , Win+Alt+G|F8|F12
            Gui, Add, Button, ym gSaveRec1, Done
            Gui, Add, Text, xm,Record Type:
            Gui, Add, DDL, +Theme x79 y30 vList, Record|ShadowPlay
            Gui, Show,, Vivace's Macro
            Return
        }
    }
    w2:
    If (WASR = 1) {
        Gui, Add, Text, y10,Rest Delay Enabled:
        Gui, Add, Edit, Number ym,
        Gui, Add, Button, ym gWcd, Done
        Gui, Show,, Vivace's Macro
        Return
    } else {
        TASRV = 9000
    }
    w3:
    ;; weight
    Loop,
    {
        Gosub, CheckWeight
        If (WE != "None") {
            PixelSearch,,, 55, 145, 56, 145, 0x3A3A3A, 40, Fast ; Hungry
            If ErrorLevel = 0
            {
                Click, 400, 455 ; Leave weight
                Sleep 500
                Gosub, autoeat
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
        ImageSearch,,, 20, 120, 260, 140, *10 %A_WorkingDir%/resource-main/weight/Stamina.bmp
        If ErrorLevel = 0
        {
            PixelSearch,,, 410, 355, 411, 356, 0x98FF79, 30, Fast ;if green hand isn't in middle
            If ErrorLevel = 1
            {
                If (WL = "Auto")
                {
                    levely = 400
                    levell = 6
                    error = 0
                    Loop,
                    {
                        ImageSearch,,, 390, 240, 430, 390, %A_WorkingDir%/resource-main/weight/w%levell%.bmp
                        If ErrorLevel = 0
                        {
                            Click, 470 , %levely%, 10
                            Click, 10
                            Sleep 100
                            tooltip, choosed %levell%
                            Break
                        } else {
                            levell--
                            levely:=levely-30
                            if levely <= 220
                            {
                                levely = 40
                                levell = 6
                                error++
                                if error <= 50
                                {
                                    ;Broken = true
                                    msgbox, Level Not Found
                                }
                            }
                        }
                    }
                    If (WL = 6)
                    {
                        Click, 470, 400, 10 
                    }
                    If (WL = 5)
                    {
                        Click, 470, 370, 10
                    }
                    If (TL = 4)
                    {
                        Click, 470, 340, 10
                    }
                    If (TL = 3)
                    {
                        Click, 470, 310, 10
                    }
                    If (TL = 2)
                    {
                        Click, 470, 280, 10
                    }
                    If (TL = 1)
                    {
                        Click, 470, 250, 10
                    }
                    Sleep 300
                    tooltip
                }
                HandCheck:=A_TickCount
                Loop,
                {
                    HandCheck1 := A_TickCount - HandCheck
                    PixelSearch,,, 410, 355, 411, 356, 0x98FF79, 30, Fast
                    If ErrorLevel = 0
                    {
                        Click , 410, 355, 10
                        Break
                    }
                    If (HandCheck1 > 10000)
                    {
                        Msgbox, Not Found Hand Money Ranout
                    }
                }
                WeightTask := A_TickCount
                Loop,
                {
                    TaskTimer := A_TickCount - WeightTask
                    ImageSearch, PosX, PosY, 250, 220, 560, 440, *25 %A_WorkingDir%\resource-main\weight\yellow.png
                    If ErrorLevel = 0
                    {
                        PosX:=PosX+5
                        PosY:=PosY+5
                        Click, %PosX%, %PosY%, 10
                        Sleep 50
                        MouseMove, 400, 540
                        Sleep 10
                    }
                    ;; Stam Detect
                    If (WASD = 1)
                    {
                        If (WA = "High")
                        {
                            PixelSearch ,,, 40, 130, 40, 133, 0x3A3A3A, 40, Fast
                            If ErrorLevel = 0
                            {
                                Gosub, WaitWeight
                            }
                        }
                        If (WA = "Medium")
                        {
                            PixelSearch ,,, 40, 130, 50, 133, 0x3A3A3A, 40, Fast
                            If ErrorLevel = 0
                            {
                                Gosub, WaitWeight
                            }
                        }
                        If (WA = "Low")
                        {
                            PixelSearch ,,, 40, 130, 60, 133, 0x3A3A3A, 40, Fast
                            If ErrorLevel = 0
                            {
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
                    ;; 

                }
            }
        }
        ;; Combat Detect
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
        TaskTimer := A_TickCount - TreadmillTask
        Tooltip, %TaskSleep% %TaskTimer%
        If (TaskSleep > DefaultWait)
        {
            Break
        }
        If (TaskTimer > 65000)
        {
            Break
        }
        If (TaskTimer > 55000)
        {
            Click, 400, 391
        }
    }
    Tooltip,
Return
CheckWeight:
    if WinExist("Ahk_exe RobloxPlayerBeta.exe")
    {
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
Wcd:
    Gui, Submit
    Gui, Destroy
    Goto, w3
Return
StartTread:
    ;MsgBox, ALOALAOALO
    Gui, Submit
    Gui, Destroy
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
    Eatingtype = 1
    If (TD = "Fatigue Estimate")
    {
        Gui, Add, Text, y10,How Many Round:
        Gui, Add, Edit, ym vRound number,
        Gui, Add, Button, ym gHELLO, Done 
        Gui, Show,, Vivace's Macro
        Return
    }
    go1:
    If (TAAC = 1) {
        IniRead, KeyCombo, settings.ini, Record, RECKEY
        IniRead, List, settings.ini, Record, RECTYPE
        if (KeyCombo = "" or List = "" or KeyCombo = "ERROR" or List = "ERROR") {
            Gui, Add, Text, y10,Record Key:
            Gui, Add, DDL, +Theme ym vKeyCombo , Win+Alt+G|F8|F12
            Gui, Add, Button, ym gSaveRec, Done
            Gui, Add, Text, xm,Record Type:
            Gui, Add, DDL, +Theme x79 y30 vList, Record|ShadowPlay
            Gui, Show,, Vivace's Macro
            Return
        }
    }
    go:
    If (TASS = 1) {
        Gui, Add, Text, y10,Start Delay Enabled:
        Gui, Add, Edit, Number ym vTASS,
        Gui, Add, Button, ym gXDDD, Done
        Gui, Show,, Vivace's Macro
        Return
    } else {
        TASSV = 0
    }
    go2:
    If (TASR = 1) {
        Gui, Add, Text, y10,Rest Delay Enabled:
        Gui, Add, Edit, Number ym vTASRV,
        Gui, Add, Button, ym gXDDDD, Done
        Gui, Show,, Vivace's Macro
        Return
    } else {
        TASRV = 9000
    }
    go3:
    ;;; treadmill part
    Loop,
    {
        Gosub, CheckTreadmill
        PixelSearch,,, 55, 145, 56, 145, 0x3A3A3A, 40, Fast ; Hungry
        If ErrorLevel = 0
        {
            If (TE != "None")
            {   
                Click, 410, 345 ; Leave Treadmill
                Sleep 1000
                gosub, AutoEat
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
        ImageSearch,,, 20, 120, 260, 140, *10 %A_WorkingDir%/resource-main/treadmill/Stamina.bmp
        If ErrorLevel = 0
        {
            If (TS = "Stamina")
            {
                Click, 290, 310, 20
            } 
            If (TS = "RunningSpeed")
            {
                Click, 520, 310, 20
            }
            wait := A_TickCount
            Loop,
            {
                PixelSearch,,, 339, 249, 340, 250, 0x5A5A5A,, Fast
                If ErrorLevel = 0
                {
                    Break
                }
                PixelSearch,,, 410, 355, 411, 356, 0x98FF79, 30, Fast
                If ErrorLevel = 0
                {
                    Break
                } 
            } Until A_TickCount - wait > 3000
            Sleep 300
            PixelSearch,,, 410, 355, 411, 356, 0x98FF79, 30, Fast
            If ErrorLevel = 1
            {
                If (TL = "Auto")
                {
                    levely = 370
                    levell = 5
                    error = 0
                    Loop,
                    {
                        ImageSearch,,, 390, 240, 430, 390, %A_WorkingDir%/resource-main/treadmill/level%levell%.bmp
                        If ErrorLevel = 0
                        {
                            Click, 470 , %levely%, 10

                            Break
                        } else {
                            levell--
                            levely:=levely-30
                            if levely <= 220
                            {
                                levely = 370
                                levell = 5
                                error++
                                if error <= 50
                                {
                                    ;Broken = true
                                    Level=
                                    (
                                        {
                                            "username": "i love vivace's macro",
                                            "content": "%id% You are pushed away from treadmill!",
                                            "embeds": null
                                        }
                                    )
                                    req.Send(Level)
                                    If (TAAC = 1) {
                                        Gosub, Clipper
                                    }
                                }
                            }
                        }
                    } 
                }
                If (TL = 5)
                {
                    Click, 470, 370, 10
                }
                If (TL = 4)
                {
                    Click, 470, 340, 10
                }
                If (TL = 3)
                {
                    Click, 470, 310, 10
                }
                If (TL = 2)
                {
                    Click, 470, 280, 10
                }
                If (TL = 1)
                {
                    Click, 470, 250, 10
                }
            }
            Sleep 300
            HandCheck:=A_TickCount
            Loop,
            {
                HandCheck1 := A_TickCount - HandCheck
                PixelSearch,,, 410, 355, 411, 356, 0x98FF79, 30, Fast
                If ErrorLevel = 0
                {
                    Click , 410, 355, 10
                    Break
                }
                If (HandCheck1 > 10000)
                {
                    Msgbox, Not Found Hand Money Ranout
                }
            }
            Sleep 3000
            button := "w,a,s,d"
            TreadmillTask := A_TickCount
            If (TASS = 1)
            {
                Sleep %TASSV%
            }
            Loop, ; treadmill 
            {
                TaskTimer := A_TickCount - TreadmillTask
                Loop, Parse, button, `,
                {
                    ImageSearch,,, 200, 240, 600, 300, *50 %A_WorkingDir%\resource-main\treadmill\%A_LoopField%.bmp
                    If ErrorLevel = 0
                    {
                        If A_LoopField = w
                        {
                            keyw := "w"
                            keyw := format("sc{:x}", getKeySC(keyw))
                            Send {%keyw%}
                        }
                        If A_LoopField = a
                        {
                            keya := "a"
                            keya := format("sc{:x}", getKeySC(keya))
                            Send {%keya%}
                        }
                        Send, %A_LoopField%
                        Break
                    }
                } ; stam detect
                If (TASD = 1)
                {
                    If (TA = "High")
                    {
                        PixelSearch ,,, 40, 130, 40, 133, 0x3A3A3A, 40, Fast
                        If ErrorLevel = 0
                        {
                            Gosub, WaitTreadmill
                        }
                    }
                    If (TA = "Medium")
                    {
                        PixelSearch ,,, 40, 130, 50, 133, 0x3A3A3A, 40, Fast
                        If ErrorLevel = 0
                        {
                            Gosub, WaitTreadmill
                        }
                    }
                    If (TA = "Low")
                    {
                        PixelSearch ,,, 40, 130, 60, 133, 0x3A3A3A, 40, Fast
                        If ErrorLevel = 0
                        {
                            Gosub, WaitTreadmill
                        }
                    }
                }
                If (TaskTimer > 55000)
                {
                    Click, 400, 290
                }
                If (TaskTimer > 65000) 
                {
                    Break
                }
            } 
        }
        PixelSearch,,, 55, 145, 56, 145, 0x3A3A3A, 40, Fast ; Hungry
        If ErrorLevel = 0
        {
            If (STE != "None")
            {   
                Click, 410, 345 ; Leave Treadmill
                Sleep 1000
                gosub, AutoEat
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
        Pixelsearch,,, 79, 98, 80, 99, 0x38388E, 10, Fast ; Combat Tag 
        if ErrorLevel = 0
        {
            send {o down}
            Sleep 1000
            Send {o up}
            If (TAAC = 1)
            {
                If record = true
                {
                    Send %bind%
                }
                PixelSearch,,, 565, 90, 566 , 91, 0xFFFFFF, 10
                IF ErrorLevel = 1
                {
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
                if instant = true
                {
                    Send %bind%
                } 
                if record = true
                {
                    Send %bind%
                }
                Click, 805, 285, Down
                Click, 805, 410, Up
                MouseMove, 765, 125
                MouseMove, 0, 79, 20, r
            }
            MsgBox, Macro Ruined
        }
        ;; auto log for fatigue estimate
    }
Return
WaitTreadmill:
    If (TASR = "0")
    {
        DefaultWait:=9000
    }
    If (TASR = "1")
    {
        DefaultWait:=TASRV
    }
    TimerSleep := A_TickCount
    Loop,
    {
        TaskSleep := A_TickCount - TimerSleep
        TaskTimer := A_TickCount - TreadmillTask
        Tooltip, %TaskSleep% %TaskTimer%
        If (TaskSleep > DefaultWait)
        {
            Break
        }
        If (TaskTimer > 65000)
        {
            Break
        }
        If (TaskTimer > 55000)
        {
            Click, 400, 290
        }
    }
    Tooltip,
Return
Clipper:
    IniRead, RECTYPE, seittngs.ini, Record, RECTYPE
    IniRead, RECKEY, seittngs.ini, Record, RECKEY
    ;; RECTYPE=ShadowPlay
    ;; RECKEY=Win+Alt+G

    If RECTYPE = "Record"
    {
        Send %RECKEY%
    }
    PixelSearch,,, 565, 90, 566 , 91, 0xFFFFFF, 10
    IF ErrorLevel = 1
    {
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
    if instant = true
    {
        Send %bind%
    } 
    if record = true
    {
        Send %bind%
    }
    Click, 805, 285, Down
    Click, 805, 410, Up
    MouseMove, 765, 125
    MouseMove, 0, 79, 20, r
Return
AutoEat:
    If Eatingtype = 1
    {
        Slot:="1,2,3,4,5,6,7,8,9,0"
    }
    If Eatingtype = 2
    {
        Slot:="2,3,4,5,6,7,8,9,0"
    }
    If Eatingtype = 3
    {
        Slot:="3,4,5,6,7,8,9,0"
    }
    Loop, Parse, Slot, `,
    {
        Send %A_LoopField%
        Sleep 150
        ImageSearch,,, 60, 520, 760, 550, %A_WorkingDir%/resource-main/slotequip.bmp
        If ErrorLevel = 0
        {
            Loop, 
            {
                PixelSearch, x, y, 119, 144, 110, 146, 0x3A3A3A, 40, Fast
                If ErrorLevel = 0
                {
                    Click, 405, 620
                    ImageSearch,,, 60, 520, 760, 550, %A_WorkingDir%/resource-main/slotequip.bmp
                    If ErrorLevel = 1
                    {
                        Goto, AutoEat
                    }
                }
                If ErrorLevel = 1
                {
                    Return
                }
            }
        }
    }
    If Eatingtype = 1
    {
        If (TE = "SlotEat")
        {
            MsgBox, Not Found Any Food Left In Slot
        }
    }


    If Eatingtype = 1
    {
        If (TE = "Slot+Inventory") ;; open slot
        {
            gosub, grave
            MouseMove, 100, 480
            Sleep 600
            if Eatingtype = 1
            {
                xx=95
                Loop = 10
            }
            gosub, draginventory
            MouseMove, 100, 480
            gosub, grave
            Sleep 300
            goto, AutoEat
        }
    }
Return
CheckTreadmill:
    if WinExist("Ahk_exe RobloxPlayerBeta.exe")
    {
        WinActivate
        WinGetPos,,,W,H,A
        If ((W >= A_ScreenWidth ) & (H >= A_ScreenHeight))
        {
            Send {F11}
            Sleep 100
        }
        if ((W > 816) & ( H > 638))
        {
            WinMove, Ahk_exe RobloxPlayerBeta.exe,,,, 800, 599 
        }
        
    } else {
        MsgBox,,Vivace's Macro,Roblox not active,3
        ExitApp
    }
Return
draginventory:
Loop, %Loop%
{
    ImageSearch, x, y, 90, 195, 675, 500, *10 %A_WorkingDir%/resource-main/x5.bmp
    If ErrorLevel = 0
    {
        Sleep 40
        Click, %x%, %y%, Down
        Sleep 50
        Click, %xx%, 555, Up
        Sleep 60
        xx:=xx+70
    }
    if ErrorLevel = 1
    {
        If (A_Index = 1) {
            MsgBox, Food ran out of inventory + Break
            ExitApp
        }
        Break
    }   
}
Return
grave:
    keygrave := "``"
    keygrave := format("sc{:x}", getKeySC(keygrave))
    send {%keygrave%}
Return
SaveRec:
    Gui, Submit
    Gui, Destroy
    If (KeyCombo = "" or List = "" or KeyCombo = "ERROR" or List = "ERROR") {
        msgbox,,Vivace's Macro,You have incomplete information.
        ExitApp
    }
    if ((KeyCombo = "F8") or (KeyCombo = "F12")) {
        IniWrite, {%KeyCombo%}, settings.ini, Record, RECKEY
    } else if (KeyCombo = "Win+Alt+G") {
        IniWrite, #!g, settings.ini, Record, RECKEY
    }
    IniWrite, %List%, settings.ini, Record, RECTYPE
    goto, go
Return
SaveRec1:
    Gui, Submit
    Gui, Destroy
    If (KeyCombo = "" or List = "" or KeyCombo = "ERROR" or List = "ERROR") {
        msgbox,,Vivace's Macro,You have incomplete information.
        ExitApp
    }
    if ((KeyCombo = "F8") or (KeyCombo = "F12")) {
        IniWrite, {%KeyCombo%}, settings.ini, Record, RECKEY
    } else if (KeyCombo = "Win+Alt+G") {
        IniWrite, #!g, settings.ini, Record, RECKEY
    }
    IniWrite, %List%, settings.ini, Record, RECTYPE
    goto, w2
Return
HELLO: 
    Gui, Submit
    Gui, Destroy
    Goto, go1   
Return

XDDD:
    Gui, Submit
    Gui, Destroy
    Goto, go2
Return
XDDDD:
    Gui, Submit
    Gui, Destroy
    Goto, go3
Return


GuiClose:
ExitApp


;; function

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
space::ExitApp