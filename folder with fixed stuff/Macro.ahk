
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
#Include,  %A_WorkingDir%/resource-main/function.ahk
Start2:
#Include, %A_WorkingDir%/resource-main/Gui.ahk
Start:

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

;; Check for webhook 
IniRead, Webhook, settings.ini, Notifications, Webhook
IniRead, UserID, settings.ini, Notifications, UserID
if ((Webhook = "ERROR") or (UserID = "ERROR") or (UserID = "<@>") or (Webhook = "") or (UserID = "")) {
    Gui, Add, Text, y10,Webhook:  
    Gui, Add, Edit,  ym vWebhook ,
    Gui, Add, Button, ym gSubmitWebhook, Done
    Gui, Add, Text, xm,UserID:
    Gui, Add, Edit, x70 y30 Number vUserID, 
    Gui, Show,, Vivace's Macro
    Return
    SubmitWebhook:
    {
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
        Goto, Skip1
    }
    Return
}
Skip1:
;; Start Read Saved Data from settings.ini

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
;; finish load
goto, run ;; run gui
loadsave:
    Hidethis:="SPTab,vvtext1,vvtext2,vvtext3,vvtext4,vvtext5,SPA,SPR,SPE,SPD,SPASR,SPAAC,SPAAL,3button,2Button,WeightTab,vtext1,vtext2,vtext3,vtext4,vtext5,WL,WE,WD,WA,WASD,WASR,WAAC,WAAL,Button,TreadmillTab,TS,TL,TE,TD,TA,text1,text2,text3,text4,text5,text6,TASD,TASS,TASR,TAAC,TAAL"
    Loop, Parse, Hidethis, `,
    {
        GuiControl, Hide, %A_LoopField%
    }
    ;; load saved ddl
    CheckBox:="SPASR,SPAAC,WASD,WASR,WAAC,WALL,TASD,TASS,TASR,TAAC,TAAL"
    Loop, Parse, CheckBox, `,
    {
        If (%A_LoopField% = "ERROR") {
            %A_LoopField% = 0
        }
    }

    GuiControl,, TASD, %TASD%
    GuiControl,, TASS, %TASS%
    GuiControl,, TASR, %TASR%
    GuiControl,, TAAC, %TAAC%
    GuiControl,, TAAL, %TAAL%
    GuiControl,, WASD, %WASD%
    GuiControl,, WASR, %WASR%
    GuiControl,, WAAC, %WAAC%
    GuiControl,, WAAL, %WAAL%
    ;; load option on settings.ini
    GuiControl, Choose, TS, %TS%
    GuiControl, Choose, TL, %TL%
    GuiControl, Choose, TE, %TE%
    GuiControl, Choose, TD, %TD%
    GuiControl, Choose, TA, %TA%
    GuiControl, Choose, WL, %WL%
    GuiControl, Choose, WE, %WE%
    GuiControl, Choose, WD, %WD%
    GuiControl, Choose, WA, %WA%
    GuiControl, Choose, SPA, %SPA%
    GuiControl, Choose, SPR, %SPR%
    GuiControl, Choose, SPE, %SPR%
    GuiControl, Choose, SPD, %SPR%
    ;; show gui
    Gui, Show , h300 w700, Vivace's Macro
    WinSet, Region, 0-0 h300 w700 R15-15,Vivace's Macro
Return

;;
StartTread:
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
    If (TD = "Fatigue Estimate") {
        Gui, Add, Text, y10,How Many Round:
        Gui, Add, Edit, ym vRound number,
        Gui, Add, Button, ym gtd, Done 
        Gui, Show,, Vivace's Macro
        Return
        td:
        {
            Gui, Submit
            Gui, Destroy
            goto, Skip2
        }
        Return
    }
    Skip2:
    If (TAAC = 1) {
        IniRead, KeyCombo, settings.ini, Record, RECKEY
        IniRead, List, settings.ini, Record, RECTYPE
        if (KeyCombo = "" or List = "" or KeyCombo = "ERROR" or List = "ERROR") {
            Gui, Add, Text, y10,Record Key:
            Gui, Add, DDL, +Theme ym vKeyCombo , Win+Alt+G|F8|F12
            Gui, Add, Button, ym gLekker, Done
            Gui, Add, Text, xm,Record Type:
            Gui, Add, DDL, +Theme x79 y30 vList, Record|ShadowPlay
            Gui, Show,, Vivace's Macro
            Return
        }
        Lekker:
        {
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
            Goto, Skip3
        }
        Return
    }
    Skip3:
    If (TASS = 1) {
        Gui, Add, Text, y10,Start Delay Enabled:
        Gui, Add, Edit, Number ym vTASS,
        Gui, Add, Button, ym gstass, Done
        Gui, Show,, Vivace's Macro
        Return
        stass:
        {
            Gui, Submit
            Gui, Destroy
            Goto, Skip4
        }
        Return
    } else {
        TASSV = 0
    }
    Skip4:
    If (TASR = 1) {
        Gui, Add, Text, y10,Rest Delay Enabled:
        Gui, Add, Edit, Number ym vTASRV,
        Gui, Add, Button, ym gstasrv, Done
        Gui, Show,, Vivace's Macro
        Return
        stasrv:
        {
            Gui, Submit
            Gui, Destroy
            Goto, Skip5
        }
        Return
    } else {
        TASRV = 9000
    }
    Skip5:
    #Include, %A_WorkingDir%\resource-main\include\treadmill.ahk

Return

StartSP:
    Gui, Submit
    Gui, Destroy

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
    If (WD = "Fatigue Estimate") {
        Gui, Add, Text, y10, How Many Round:
        Gui, Add, Edit, ym vRound number,
        Gui, Add, Button, ym, gwd, Done
        Gui, Show,, Vivace's Macro
        Return
        wd:
        {
            Gui, Submit
            Gui, Destroy
            Goto, Skipw
        }
        Return
    }
    Skipw:
    If (WAAC = 1) {
        IniRead, KeyCombo, settings.ini, Record, RECKEY
        IniRead, List, settings.ini, Record, RECTYPE
        if (KeyCombo = "" or List = "" or KeyCombo = "ERROR" or List = "ERROR") {
            Gui, Add, Text, y10,Record Key:
            Gui, Add, DDL, +Theme ym vKeyCombo , Win+Alt+G|F8|F12
            Gui, Add, Button, ym gLekkerw, Done
            Gui, Add, Text, xm,Record Type:
            Gui, Add, DDL, +Theme x79 y30 vList, Record|ShadowPlay
            Gui, Show,, Vivace's Macro
            Return
        }
        Lekkerw:
        {
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
            Goto, Skipw1
        }
        Return
    }
    Skipw1:
    If (WASR = 1) {
        Gui, Add, Text, y10,Rest Delay Enabled:
        Gui, Add, Edit, Number ym vTASRV,
        Gui, Add, Button, ym gswasrv, Done
        Gui, Show,, Vivace's Macro
        Return
        swasrv:
        {
            Gui, Submit
            Gui, Destroy
            Goto, Skipw2
        }
        Return
    } else {
        WASRV = 9000
    }
    Skipw2:
    #Include, %A_WorkingDir%\resource-main\include\weight.ahk
Return
;; function


$space::ExitApp