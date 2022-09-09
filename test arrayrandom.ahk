
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


end::Reload
delete::Suspend