Scriptname DSC04_SupportQuestSCRIPT extends Quest  

String Version
String Property ModName = "DSC" Auto
String Property FullModName = "Disco Mod" Auto

Event OnInit()
    Maintenance() ; OnPlayerLoadGame will not fire the first time
    RegisterForSingleUpdate(2)
EndEvent

Event OnUpdate()
    Log("OnUpdate fired")
    ;RegisterForSingleUpdate(2)
EndEvent

Function Maintenance()
    If Version != "1.0"
        Version = "1.0"
        Debug.Notification(FullModName + " v" + Version)
        ; Update Code
    EndIf
    ; Other maintenance code that only needs to run once per save load
EndFunction

Function Log(String msg, String modname="")
    Debug.Trace("[" + (modname || ModName) + "] " + self + " " + msg)
EndFunction