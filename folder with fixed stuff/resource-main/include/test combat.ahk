F1::
Waitforcombat:
    ImageSearch,,, 20, 85, 170, 110, *20 combat.bmp
    If (ErrorLevel = 0) {
        tooltip found combat
        Loop,
        {
            Sleep 30
            ImageSearch,,, 20, 85, 170, 110, *20 combat.bmp
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
            ImageSearch,,, 670, 45, 755, 55, *5 gripped.bmp
            If (ErrorLevel = 0) {
                Tooltip, Gripped
                Return
            }
        } 
    }
    CombatTask := A_TickCount
    Loop,
    {
        ImageSearch,,, 20, 85, 170, 110, *20 combat.bmp
        If (ErrorLevel = 0) {
            Goto, Waitforcombat
        }
        tooltip, Combat Is Gone
    } Until A_TickCount - CombatTask > 5000
    tooltip, Combat Is Gone
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
end::Reload