Scriptname DSC04_PaintingPlaqueActivateSCRIPT extends ObjectReference Hidden 
{Activating this causes the players currently equipped weapon to be placed on the rack}

import debug
import utility

DSC04_PaintingQuestSCRIPT Property QuestScript Auto

Bool Property AlreadyInit Auto Hidden
{If true this reference won't run it's intialization a second time}

Keyword Property WRackTrigger Auto

ObjectReference Property TriggerMarker Auto Hidden

ObjectReference Property StartingPainting Auto Hidden

ObjectReference Property Painting Auto Hidden

Actor Property PlayerRef Auto

Message Property DSC04_NoPaintingToPlace Auto;

;-------------------------------------------
Event OnUpdate()
    TriggerMarker = GetLinkedRef(WRackTrigger)
    Log("The TriggerMarker is " + TriggerMarker)
    If (TriggerMarker) && (TriggerMarker.IsEnabled()) && (TriggerMarker.GetTriggerObjectCount() == 0)
        Self.Enable()
    endif
    
    if (TriggerMarker) && (AlreadyInit == FALSE) && (TriggerMarker.IsEnabled())
        StartingPainting = GetLinkedRef()
        Log("The Starting object is " + StartingPainting)
        
        if (StartingPainting)
            if StartingPainting.Is3DLoaded()
                if StartingPainting.GetParentCell() == self.GetParentCell()
                    Log("Has a starting object")
                    HandleStartingPainting()
                endif
            endif
        else
            Log("Doesn't have a starting object")
            ;Do nothing
        endif

        AlreadyInit = TRUE
    else
        ;Do nothing
    endif

    TriggerMarker = NONE
EndEvent

EVENT OnCellLoad()
    Log("running OnCellLoad() and AlreadyInit = " + AlreadyInit)
    RegisterForSingleUpdate(0)
    Log("finishing OnCellLoad() and AlreadyInit = " + AlreadyInit)
endEVENT

Auto STATE EmptyRack
    EVENT onActivate(ObjectReference TriggerRef)
        if (TriggerRef == Game.GetPlayer() as Actor)
        ; Only the player can activate this
            Log("Player activated the object hook")

            QuestScript.Start()
            utility.wait(0.2)  ; give some time to the quest to start

            ReferenceAlias PaintingAlias = QuestScript.Painting
            Painting = PaintingAlias.GetRef()
            Log("Object to hook " + Painting)
            If (Painting && Painting.GetParentCell() == self.GetParentCell())
                Log("Object.IsLocked => " + Painting.IsLocked())
                Log("Object.GetDistance => " + Painting.GetDistance(PlayerRef))
                HandleWeaponPlacement()
            Else
                DSC04_NoPaintingToPlace.Show()
            EndIf

            QuestScript.Stop()
            QuestScript.Reset()
            Painting = NONE

        endif
    endEVENT
endSTATE

Function HandleWeaponPlacement(bool bForStartingPainting = FALSE)
    TriggerMarker = GetLinkedRef(WRackTrigger)
    
    if TriggerMarker as DSC04_PaintingMarkerTriggerSCRIPT
        (TriggerMarker as DSC04_PaintingMarkerTriggerSCRIPT).HandleObjectPlacement(Painting)
    endif
    
    TriggerMarker = NONE

EndFunction

Function HandleStartingPainting()
    Painting = StartingPainting
    HandleWeaponPlacement(TRUE)
EndFunction

Function Log(String msg, String modname="DSC04")
    ;Debug.Trace("[" + modname + "] " + self + " " + msg)
EndFunction