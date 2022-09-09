f1::

SetMouseDelay, 5
RECTYPE = "Record"
RECKEY = "{F12}"

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
    vale = 105
    vald = 540
    Loop,
    {
        ImageSearch,, y, 730, %vale%, 740, %vald%, *50 name.png
        If (ErrorLevel = 0) {
            y:=y+14
            MouseMove, 730, %y%
            vale:=vale+y+14
            Sleep 300
        } else If (ErrorLevel = 1) {
            Break
        }
    }
    
    Click, 805, 160, Down
    Click, 805, 285, Up

    MouseMove, 765, 125
    vale = 105
    Loop,
    {
        ImageSearch,, y, 730, %vale%, 740, %vald%, *50 name.png
        If (ErrorLevel = 0) {
            y:=y+14
            MouseMove, 730, %y%
            vale:=vale+y+14
            Sleep 300
        } else If (ErrorLevel = 1) {
            Break
        }
    }

    If (RECTYPE = "Record") {
        Send %RECKEY%
    } else if (RECTYPE = "Shadow") {
        Send %RECKEY%
    }
return

f2::MouseMove, 500, 0, 50, r

end::Reload