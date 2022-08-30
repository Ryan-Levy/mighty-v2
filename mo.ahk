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
Gui, Add, Picture, gtest2 w32 h32 x10 y110 , sp.png
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


;; load option on settings.ini


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

GuiControl, Choose, TS, %TS%
GuiControl, Choose, TL, %TL%
GuiControl, Choose, TE, %TE%
GuiControl, Choose, TD, %TD%
GuiControl, Choose, TA, %TA%
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
    

GuiControl,, TASD, %TASD%
GuiControl,, TASS, %TASS%
GuiControl,, TASR, %TASR%
GuiControl,, TAAC, %TAAC%
GuiControl,, TAAL, %TAAL%

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




Treadmill: ;//

Weight: ;//

StrikePower:

StrikeSpeed:

SoloDura:

DuoDura:

TrainMusce:

TrainStamina:

LoseFat:

LoseMuscle:

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
        }
    }

    If (TASS = 1) {
        InputBox, TASSV, Vivace's Macro, You have Set Start Delay Enabled `nPlease Enter InputBox *only number *Default value is 0,, 300, 150
        If ErrorLevel = 1
        {
            msgbox,,Vivace's Macro,You have incomplete information.
            ExitApp
        }
        If ErrorLevel = 0
        {
            If TASSV is not number
            {
                msgbox,,Vivace's Macro,You have invalid format.
                ExitApp
            }
        }
    } else {
        TASSV = 0
    }
    If (TASR = 1) {
        InputBox, TASRV, Vivace's Macro, You have Set Rest Delay Enabled `nPlease Enter InputBox *only number *Default value is 9000,, 300, 150
        If ErrorLevel = 1
        {
            msgbox,,Vivace's Macro,You have incomplete information.
            ExitApp
        }
        If ErrorLevel = 0
        {
            If TASRV is not number
            {
                msgbox,,Vivace's Macro,You have invalid format.
                ExitApp
            }
        }
    } else {
        TASRV = 9000
    }

Return

SaveRec:
    Gui, Submit, Destroy
    If (KeyCombo = "" or List = "" or KeyCombo = "ERROR" or List = "ERROR")
    {
        msgbox,,Vivace's Macro,You have incomplete information.
        ExitApp
    }
    IniWrite, %List%, settings.ini, Record, RECTYPE
    IniWrite, %KeyCombo%, settings.ini, Record, RECKEY
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
