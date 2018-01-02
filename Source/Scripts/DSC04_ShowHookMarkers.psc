Scriptname DSC04_ShowHookMarkers extends activemagiceffect  

import utility

Actor Property PlayerREF Auto

Quest Property QuestScript Auto

Event OnEffectStart(Actor Target, Actor Caster)
    if QuestScript.IsStopped()
        QuestScript.Start()
        QuestScript.SetStage(10)
        utility.wait(1)
    else
        Debug.Notification("I need a little time to remember where I placed them.")
    endif
EndEvent