InputBox, webhook, ,Test link


Test:=GetUrlStatus(webhook, 10)		; 200
If (Test = "") {
    MsgBox, 16, Vivace's Macro, Invalid link
}
If (Test = "") {
    MsgBox, 16, Vivace's Macro, Link Work
}
GetUrlStatus( URL, Timeout = -1 )
{
    ComObjError(0)
    static WinHttpReq := ComObjCreate("WinHttp.WinHttpRequest.5.1")

    WinHttpReq.Open("HEAD", URL, True)
    WinHttpReq.Send()
    WinHttpReq.WaitForResponse(Timeout) ; Return: Success = -1, Timeout = 0, No response = Empty String

    Return, WinHttpReq.Status()
}