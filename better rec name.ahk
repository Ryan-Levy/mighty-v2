CoordMode, Mouse, Window

f1::
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

    vale = 108
    Loop, 14
    {
        y:=vale+14
        MouseMove, 765, %y%
        vale:=vale+31
        Sleep 150
    }

    Click, 805, 160, Down
    Click, 805, 285, Up

    vale = 108
    Loop, 14
    {
        y:=vale+14
        MouseMove, 765, %y%
        vale:=vale+31
        Sleep 150
    }

    If (RECTYPE = "Record") {
        Send %RECKEY%
    } else if (RECTYPE = "Shadow") {
        Send %RECKEY%
    }
return

f2::MouseMove, 500, 0, 50, r

end::Reload