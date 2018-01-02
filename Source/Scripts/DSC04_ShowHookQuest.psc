Scriptname DSC04_ShowHookQuest extends Quest  

Bool Property AlreadyInit Auto Hidden

Event OnInit()
    if AlreadyInit == FALSE
        debug.MessageBox("If the markers don't show up in the room, I should probably try to disable my other quests.")
        AlreadyInit = TRUE
    endif
EndEvent

Event OnReset()
    AlreadyInit = FALSE
EndEvent
