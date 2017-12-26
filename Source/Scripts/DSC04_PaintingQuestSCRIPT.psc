Scriptname DSC04_PaintingQuestSCRIPT extends Quest

import game
import debug
import utility
import quest

ReferenceAlias Property Painting Auto

Quest Property QuestScript Auto Hidden

Event OnInit()
    Log("Started")
    QuestScript = self

    RegisterForSingleUpdate(2)
EndEvent

Event OnReset()
    Log("OnReset")
    Log(Painting)
EndEvent

Event OnUpdate()
    ;RegisterForSingleUpdate(1)
    ;HandleWeaponPlacement()
EndEvent

State Done
EndState

Function Log(String msg, String modname="DSC04")
    Debug.Trace("[" + modname + "] " + self + " " + msg)
EndFunction