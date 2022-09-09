f1::
;; Half HP
Loop,
{
    ;arr := ["runturn","dash"] ;; random run array
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
    ; ImageSearch ;; for combat
} ;Until ErrorLevel = 1

return
runfunction(direction) {
    if (direction = 1) { ; left
        sc("w", 2)sc("w", 3)sc("w", 1)
        send {left down}
        sleep 2000
        send {left up}
        sc("w", 2)
    } else if (direction = 2) { ; right
        sc("w", 2)sc("w", 3)sc("w", 1)
        send {right down}
        sleep 2000
        send {right up}
        sc("w", 2)
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
    Sleep 500
}
siderunfunction(direction) {
    If (direction = 1) { ; a key
        sc("w", 2)sc("w", 3)sc("w", 1)sc("a", 1)
        send, {up}
        sleep 1000
        sc("w", 2)sc("a", 2)
    } else If (direction = 2) {
        sc("w", 2)sc("w", 3)sc("w", 1)sc("d", 1)
        send, {up}
        sleep 1000
        sc("w", 2)sc("d", 2)
    }
    Sleep 100
}

Send {w up}w{w down}{left down} ;; run
	Sleep 2000
	send {w up}{left up}
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
delete::Suspend