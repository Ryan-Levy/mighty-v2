goto, Start
Return

run:
    Gui, -Caption
    Gui, +AlwaysOnTop
    Gui, Add, Text, x30 y8, Vivace's Macro

    ;; - - - treadmill
    Gui, Add, Picture, w20 h20 x5 y5, %A_WorkingDir%/resource-main/bin/ico.ico
    ;; group picture 
    Gui, Add, Picture, ggit w16 h16 X620 y10, %A_WorkingDir%/resource-main/bin/git.png
    Gui, Add, Picture, gcopy w16 h16 X645 y10, %A_WorkingDir%/resource-main/bin/discord.png
    Gui, Add, Picture, gminimize w16 h16 X670 y10, %A_WorkingDir%/resource-main/bin/Minimize.png
    Gui, Add, Picture, gtest w32 h32 x10 y30 , %A_WorkingDir%/resource-main/bin/tab/Treadmill.png
    Gui, Add, Picture, gtest2 w32 h32 x10 y75 , %A_WorkingDir%/resource-main/bin/tab/Weight.png
    Gui, Add, Picture, gtest3 w32 h32 x10 y110 , %A_WorkingDir%/resource-main/bin/tab/sp.png
    Gui, Add, Picture, gtest2 w32 h32 x10 y155 , %A_WorkingDir%/resource-main/bin/tab/ss.png

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

    Gui, Add, Checkbox, vSPASR ,Set Rest Delay
    Gui, Add, Checkbox, vSPAAC ,Auto Clip 
    Gui, Add, Checkbox, vSPAAL ,Auto Leave 

    Gui, Add, Button,xm+321 ym+240 v3button gStartSP ,Done ;; start button
    ;;---- -end sp
    goto, loadsave
return

Minimize:
    ExitApp
Return
copy:
    Run, https://discord.com/invite/4rxfjtnMGt
Return
git:
    Run, https://github.com/Cweamy/Mighty-Omega-Macro
Return

test:
    Showthis:="Button,TreadmillTab,TS,TL,TE,TD,TA,text1,text2,text3,text4,text5,text6,TASD,TASS,TASR,TAAC,TAAL" 
    Hidethis:="2Button,WeightTab,vtext1,vtext2,vtext3,vtext4,vtext5,WL,WE,WD,WA,WASD,WASR,WAAC,WAAL,SPTab,vvtext1,vvtext2,vvtext3,vvtext4,vvtext5,SPA,SPR,SPE,SPD,SPASR,SPAAC,SPAAL,3button"
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
    Hidethis:="Button,TreadmillTab,TS,TL,TE,TD,TA,text1,text2,text3,text4,text5,text6,TASD,TASS,TASR,TAAC,TAAL,SPTab,vvtext1,vvtext2,vvtext3,vvtext4,vvtext5,SPA,SPR,SPE,SPD,SPASR,SPAAC,SPAAL,3button"
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
    Showthis:="SPTab,vvtext1,vvtext2,vvtext3,vvtext4,vvtext5,SPA,SPR,SPE,SPD,SPASR,SPAAC,SPAAL,3button"
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