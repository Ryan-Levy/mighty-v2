

f1::
IniRead, Combo, settings.ini, Record, RECKEY
If (Combo = "Win+Alt+G") {
    Send #!g
}
If (Combo = "F8") {
    Send {f8}
}
If (Combo = "F12") {
    Send {f12}
}
Return 
