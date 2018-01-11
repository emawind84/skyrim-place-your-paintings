Scriptname DSC04_PaintingMarkerTriggerSCRIPT extends ObjectReference  

import game
import debug
import utility

Keyword Property WRackActivator Auto

FormList Property DSC04PaintingList01 Auto

FormList Property DSC04PlateList01 Auto

FormList Property DSC04DefaultHookableList01 Auto

Keyword Property DSC04DisableParent Auto

Keyword Property DSC04EnableParent Auto

Keyword Property DSC04HookableDefault Auto

Keyword Property DSC04HookableDefault02 Auto

Keyword Property DSC04HookableDefault03 Auto

Keyword Property DSC04HookablePainting Auto

Keyword Property DSC04HookablePlate Auto

;The activator we must disable if there is already something in this trigger
ObjectReference Property ActivatorRef Auto Hidden

Bool Property AlreadyInit Auto Hidden

ObjectReference Property EnableParentRef Auto Hidden

ObjectReference Property DisableParentRef Auto Hidden

Actor Property PlayerRef Auto

Keyword Property DSC04Hookable Auto

ObjectReference CurrentObjectRef

EVENT OnReset()
    AlreadyInit = FALSE
    ;Log("DARYL - " + self + " running OnReset() and AlreadyInit = " + AlreadyInit)
endEVENT

EVENT OnUpdate()
    ToggleMarker()

    ;Log("OnUpdate - GetTriggerObjectCount => " + GetTriggerObjectCount())
    if self.IsEnabled() && GetTriggerObjectCount() == 0
        ActivatorRef = GetLinkedRef(WRackActivator)
        if ActivatorRef && ActivatorRef.IsDisabled()
            ;Log("Enabling activator")
            ActivatorRef.Enable()

            ; required since the oncellattach event in the activator might get fired 
            ; when this ref is still disabled, and the starting painting/item is not handled
            ActivatorRef.RegisterForSingleUpdate(0)
        endif
    else
        ActivatorRef = GetLinkedRef(WRackActivator)
        if ActivatorRef && ActivatorRef.IsEnabled()
            ;Log("Disabling activator")
            ActivatorRef.Disable()
        endif
    endif
    ActivatorRef = NONE

    if PlayerRef.IsInLocation(self.GetCurrentLocation())
    ; since ontriggerleave doesn't get fired most of the times
    ; we force an update so we check again if the activator have to be enabled or disabled
        RegisterForSingleUpdate(2)
    endif
endEVENT

EVENT OnCellAttach()
    Log("running OnCellAttach() and AlreadyInit = " + AlreadyInit)
    Reset()  ; reset the position of the marker
    RegisterForSingleUpdate(2)
    
    if CurrentObjectRef
        Log("replacing current object => " + CurrentObjectRef)
        HandleObjectPlacement(CurrentObjectRef)
    endif
endEVENT

EVENT OnTriggerEnter(objectReference akTriggerRef)
    ;debug.MessageBox("OnTriggerEnter " + triggerRef)
    Log("OnTriggerEnter " + akTriggerRef)
    Log("GetTriggerObjectCount => " + GetTriggerObjectCount())
    if IsHookable(akTriggerRef)
        
        ; we save the object so it can be placed again on cell load
        CurrentObjectRef = akTriggerRef

        ActivatorRef = GetLinkedRef(WRackActivator)
        if ActivatorRef
            ActivatorRef.Disable()
        endif
        ActivatorRef = NONE
        akTriggerRef.Lock(TRUE)
    endif
    
endEVENT

EVENT OnTriggerLeave(objectReference akTriggerRef)
    ;debug.MessageBox("OnTriggerLeave " + akTriggerRef)
    Log("OnTriggerLeave " + akTriggerRef)
    Log("GetTriggerObjectCount => " + GetTriggerObjectCount())
    if IsHookable(akTriggerRef)

        if CurrentObjectRef == akTriggerRef
            CurrentObjectRef = NONE
        endif

        ActivatorRef = GetLinkedRef(WRackActivator)
        if ActivatorRef
            ActivatorRef.Enable()
        endif
        ActivatorRef = NONE
        akTriggerRef.Lock(FALSE)
    endif
endEVENT

Function ToggleMarker()
    EnableParentRef = GetLinkedRef(DSC04EnableParent)
    DisableParentRef = GetLinkedRef(DSC04DisableParent)
    ;Log("EnableParentRef => " + EnableParentRef)
    ;Log("DisableParentRef => " + DisableParentRef)

    bool bEnable = TRUE
    if EnableParentRef
        if EnableParentRef.IsDisabled()
            bEnable = FALSE
        endif
    endif

    if DisableParentRef
        if DisableParentRef.IsEnabled()
            bEnable = FALSE
        endif
    endif

    if bEnable && self.IsDisabled()
        self.Enable()
    elseif bEnable == FALSE && self.IsEnabled()
        self.Disable()
    endif

    ;Log("Marker enabled => " + self.IsEnabled())

    EnableParentRef = NONE
    DisableParentRef = NONE
EndFunction

bool Function IsHookable(ObjectReference akObjRef)
    bool hookable = FALSE
    hookable = hookable || DSC04PaintingList01.HasForm(akObjRef.GetBaseObject())
    hookable = hookable || DSC04PlateList01.HasForm(akObjRef.GetBaseObject())
    hookable = hookable || DSC04DefaultHookableList01.HasForm(akObjRef.GetBaseObject())
    hookable = hookable || akObjRef.HasKeyword(DSC04Hookable)
    Log("IsHookable " + akObjRef + " => " + hookable)
    return hookable
EndFunction

Function HandleObjectPlacement(ObjectReference akObjRef)
    if !SetReferenceMotionType(akObjRef, Motion_Keyframed)
        Log("MotionType cannot be set, returning...")
        return
    endif
    
    ObjectReference TriggerMarker = self
    ;akObjRef.TranslateToRef(TriggerMarker, 1000.0)
    ;akObjRef.SplineTranslateToRefNode(TriggerMarker, "ShieldPivot01", 1.0, 1000.0)
    if DSC04PlateList01.HasForm(akObjRef.GetBaseObject()) || akObjRef.HasKeyword(DSC04HookablePlate)
        akObjRef.MoveToNode(TriggerMarker, "PlatePivot01")
    elseif DSC04PaintingList01.HasForm(akObjRef.GetBaseObject()) || akObjRef.HasKeyword(DSC04HookablePainting)
        akObjRef.MoveToNode(TriggerMarker, "PaintingPivot01")
    elseif akObjRef.HasKeyword(DSC04HookableDefault02)
        akObjRef.MoveToNode(TriggerMarker, "DefaultPivot02")
    elseif akObjRef.HasKeyword(DSC04HookableDefault03)
        akObjRef.MoveToNode(TriggerMarker, "DefaultPivot03")
    else
        akObjRef.MoveToNode(TriggerMarker, "DefaultPivot01")
    endif
    ;akObjRef.SetAngle(TriggerMarker.GetAngleX(), TriggerMarker.GetAngleY(), TriggerMarker.GetAngleZ())
    ;SetReferenceMotionType(akObjRef, Motion_Keyframed)
    ;Log("TriggerMarker.GetTriggerObjectCount() " + TriggerMarker.GetTriggerObjectCount())
    ;If (TriggerMarker.GetTriggerObjectCount() > 0)
    ;    self.Disable()
    ;endif
EndFunction

bool Function SetReferenceMotionType(ObjectReference akObjRef, int iMotionType)
    int Count = 0
    While(!akObjRef.Is3DLoaded()) && (Count < 10)
        ; Have to wait to make sure the item is dropped before setting it's motion type, or else I get a "Object has no 3D" error.
        Utility.Wait(0.1)
        Count += 1
    EndWhile

    if akObjRef.Is3DLoaded()
        akObjRef.SetMotionType(iMotionType, false)
        ; Tell the obj ref to ignore all forms of physic interaction
        Log("Disabling physics on " + akObjRef)
    else
        return FALSE
    endif
    return TRUE
EndFunction

Function Log(String msg, String modname="DSC04")
    ;Debug.Trace("[" + modname + "] " + self + " " + msg)
EndFunction