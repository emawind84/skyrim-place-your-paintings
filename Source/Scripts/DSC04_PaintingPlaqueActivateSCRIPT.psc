Scriptname DSC04_PaintingPlaqueActivateSCRIPT extends ObjectReference Hidden 
{Activating this causes the players currently equipped weapon to be placed on the rack}

import debug
import utility

DSC04_PaintingQuestSCRIPT Property QuestScript Auto

Bool Property AlreadyInit Auto Hidden
{If true this reference won't run it's intialization a second time}

Keyword Property WRackTrigger Auto

Keyword Property DSC04HookableDefault Auto

Keyword Property DSC04HookableDefault02 Auto

Keyword Property DSC04HookablePainting Auto

Keyword Property DSC04HookablePlate Auto

ObjectReference Property TriggerMarker Auto Hidden

ObjectReference Property StartingPainting Auto Hidden

ObjectReference Property Painting Auto Hidden

FormList Property DSC04PlateList01 Auto

FormList Property DSC04PaintingList01 Auto

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
            utility.wait(1)  ; give some time to the quest to start

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

Function HandleWeaponPlacement(bool ForStartingPainting = FALSE)
    if !SetReferenceMotionType(Painting, Motion_Keyframed)
        Log("MotionType cannot be set, returning...")
        return
    endif
    
    TriggerMarker = GetLinkedRef(WRackTrigger)
    ;Painting.TranslateToRef(TriggerMarker, 1000.0)
    ;Painting.SplineTranslateToRefNode(TriggerMarker, "ShieldPivot01", 1.0, 1000.0)
    if DSC04PlateList01.HasForm(Painting.GetBaseObject()) || Painting.HasKeyword(DSC04HookablePlate)
        Painting.MoveToNode(TriggerMarker, "PlatePivot01")
    elseif DSC04PaintingList01.HasForm(Painting.GetBaseObject()) || Painting.HasKeyword(DSC04HookablePainting)
        Painting.MoveToNode(TriggerMarker, "PaintingPivot01")
    elseif Painting.HasKeyword(DSC04HookableDefault02)
        Painting.MoveToNode(TriggerMarker, "DefaultPivot02")
    else
        Painting.MoveToNode(TriggerMarker, "DefaultPivot01")
    endif
    ;Painting.SetAngle(TriggerMarker.GetAngleX(), TriggerMarker.GetAngleY(), TriggerMarker.GetAngleZ())
    ;SetReferenceMotionType(Painting, Motion_Keyframed)
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

bool Function SetReferenceMotionType(ObjectReference refObj, int iMotionType)
    int Count = 0
    While(!refObj.Is3DLoaded()) && (Count < 10)
        ; Have to wait to make sure the item is dropped before setting it's motion type, or else I get a "Object has no 3D" error.
        Utility.Wait(0.1)
        Count += 1
    EndWhile

    if refObj.Is3DLoaded()
        refObj.SetMotionType(iMotionType, false)
        ; Tell the obj ref to ignore all forms of physic interaction
        Log("Disabling physics on " + refObj)
    else
        return FALSE
    endif
    return TRUE
EndFunction

Function Log(String msg, String modname="DSC04")
    Debug.Trace("[" + modname + "] " + self + " " + msg)
EndFunction