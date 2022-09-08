ping=<@849979051393548318>
webhook=
req := ComObjCreate("WinHttp.WinHttpRequest.5.1")
req.Open("POST", webhook, true)
req.SetRequestHeader("Content-Type", "application/json")

req.send(DiscordSend("tessstwoord",ping))

MsgBox, Done why this doesn't work wth

DiscordSend(m,p) {
    postdata={"username":"i love vivace's macro","content":"%p% %m%"}
    return postdata
}