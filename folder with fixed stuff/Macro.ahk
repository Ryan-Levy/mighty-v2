
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
;; idk why i don't move this down instead making it go subordinate 


If (A_ScreenDPI != 96) { ;; checking scale and layout
    MsgBox,	16,Vivace's Macro, Your Scale `& layout settings need to be on 100`%
    ;; might add a option that ask if you want to use 100% scale
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
    Gui, Add, Button, ym gLnowebhook, NO
    Gui, Add, Text, xm,UserID:
    Gui, Add, Edit, x70 y30 Number vUserID, 
    Gui, Show,, Vivace's Macro
    Return
    Lnowebhook:
        Gui, Destroy
        Webhook = false
        Gosub, Skip1
    Return
    SubmitWebhook:
        Gui, Submit
        Gui, Destroy
        Webhook = true
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
            } else {
                IniWrite, %Webhook%, settings.ini, Notifications, Webhook
                IniWrite, <@%UserID%>, settings.ini, Notifications, UserID
            }
        }
        Gosub, Skip1
    Return
} else {
    Webhook = True
    req := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    req.Open("POST", webhook, true)
    req.SetRequestHeader("Content-Type", "application/json")

    ;;req.send(DiscordSend("tessstwoord",ping))

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

;; finish load
goto, run ;; run gui
loadsave:
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
    ;; show gui
    Gui, Show , h300 w700, Vivace's Macro
    WinSet, Region, 0-0 h300 w700 R15-15,Vivace's Macro
Return

;;
StartTread:
    Gui, Submit
    Gui, Destroy
    Tooltip, 1
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
    Tooltip, 2
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
    } else {
        Goto, Skip3
    }

    Skip3:
    Tooltip, 3
    If (TASS = 1) {
        Gui, Add, Text, y10,Start Delay Enabled:
        Gui, Add, Edit, Number ym vTASS,
        Gui, Add, Button, ym gstacss, Done
        Gui, Show,, Vivace's Macro
        Return
    } else {
        TASSV = 0
        Goto, Skip4
    }
    
    Skip4:
    Tooltip, 4
    If (TASR = 1) {
        Gui, Add, Text, y10,Rest Delay Enabled:
        Gui, Add, Edit, Number ym vTASRV,
        Gui, Add, Button, ym gstasrv, Done
        Gui, Show,, Vivace's Macro
        Return
    } else {
        TASRV = 9000
        Goto, Skip5
    }
    Skip5:
    Tooltip, 5
    Goto, TreadmillStart
Return

StartSP:
    Gui, Submit
    Gui, Destroy
    IniWrite, %SPR%, settings.ini, StrikePower, SPR
    IniWrite, %SPA%, settings.ini, StrikePower, SPA
    IniWrite, %SPD%, settings.ini, StrikePower, SPD
    IniWrite, %SPE%, settings.ini, StrikePower, SPE
    IniWrite, %SPAWS%, settings.ini, AdvStrikePower, SPAWS
    IniWrite, %SPASR%, settings.ini, AdvStrikePower, SPASR
    IniWrite, %SPAAC%, settings.ini, AdvStrikePower, SPAAC
    IniWrite, %SPAAL%, settings.ini, AdvStrikePower, SPAAL
    
    Goto, StartSPMac
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
#Include,  %A_WorkingDir%/resource-main/function.ahk 
#Include, %A_WorkingDir%/resource-main/Gui.ahk
#Include, %A_WorkingDir%\resource-main\include\treadmill.ahk
#Include, %A_WorkingDir%\resource-main\include\strikepower.ahk
$l::ExitApp
$k::Pause
$j::Reload