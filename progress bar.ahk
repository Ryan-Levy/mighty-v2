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
con = 0

Gui, -Caption
Gui, +AlwaysOnTop
Gui, Add, Text,+Center w180 x0 y0 Center Border,Welcome to Vivace's Macro
Gui, Add, Text, w180 x0 y15 Center,J to Exit P to Pause
Gui, Add, Text, w180 x0 y30 Center vStatus, HELLP
Gui, Show, w180 h50,Vivace's Macro
Return

f1::
Field:= "1.0.0 - Start Macro,1.0.1 - Downloading Virus,1.0.2 - Destroying Windows,sus,1.0.3 - Joke"
Loop, Parse, Field, `,
{
    GuiControl,,Status, %A_LoopField%
    Sleep 2000
}
Return
WM_LBUTTONDOWN() {
	PostMessage, 0xA1, 2
}