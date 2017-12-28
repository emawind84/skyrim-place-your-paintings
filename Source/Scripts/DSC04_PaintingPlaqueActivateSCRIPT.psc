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
        Log("The Starting painting is " + StartingPainting)
        
        if (StartingPainting)
            if StartingPainting.Is3DLoaded()
                if StartingPainting.GetParentCell() == self.GetParentCell()
                    Log("Has a starting painting")
                    HandleStartingPainting()
                endif
            endif
        else
            Log("Doesn't have a starting painting")
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
            Log("Player activated the painting hook")

            QuestScript.Start()
            utility.wait(1)  ; give some time to the quest to start

            ReferenceAlias PaintingAlias = QuestScript.Painting
            Painting = PaintingAlias.GetRef()
            Log(Painting)
            If (Painting && Painting.GetParentCell() == self.GetParentCell())
                Log("Painting.IsLocked => " + Painting.IsLocked())
                Log("Painting.GetDistance => " + Painting.GetDistance(PlayerRef))
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

Function HandleWeaponPlacement(bool ForStartingPainting = FALSE)
    ; Grabs the weapon from the player and places it in the correct place.

    int Count = 0
    While(!Painting.Is3DLoaded()) && (Count < 10)
        ; Have to wait to make sure the item is dropped before setting it's motion type, or else I get a "Object has no 3D" error.
        Utility.Wait(0.1)
        Count += 1
    EndWhile

    Painting.SetMotionType(Motion_Keyframed, false)
    ; Tell the weapon to ignore all forms of physic interaction
    Log("Disabling physics on " + Painting)
    
    TriggerMarker = GetLinkedRef(WRackTrigger)

    ;Painting.MoveToNode(TriggerMarker, "BowPivot01")
    Painting.MoveToNode(TriggerMarker, "ShieldPivot01")
    Painting.SetAngle(TriggerMarker.GetAngleX(), TriggerMarker.GetAngleY(), TriggerMarker.GetAngleZ())

    ;Log("TriggerMarker.GetTriggerObjectCount() " + TriggerMarker.GetTriggerObjectCount())
    ;If (TriggerMarker.GetTriggerObjectCount() > 0)
    ;    self.Disable()
    ;endif
    
    TriggerMarker = NONE

EndFunction

Function HandleStartingPainting()
    Painting = StartingPainting
    HandleWeaponPlacement(TRUE)
EndFunction

Function Log(String msg, String modname="DSC04")
    Debug.Trace("[" + modname + "] " + self + " " + msg)
EndFunction