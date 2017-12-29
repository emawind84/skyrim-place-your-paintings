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

;The activator we must disable if there is already something in this trigger
ObjectReference Property ActivatorRef Auto Hidden

Bool Property AlreadyInit Auto Hidden

ObjectReference Property EnableParentRef Auto Hidden

ObjectReference Property DisableParentRef Auto Hidden

Actor Property PlayerRef Auto

Keyword Property DSC04Hookable Auto

Int InTrigger = 0

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
            ActivatorRef.RegisterForSingleUpdate(2)
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
    RegisterForSingleUpdate(2)
endEVENT

EVENT OnTriggerEnter(objectReference triggerRef)
    ;debug.MessageBox("OnTriggerEnter " + triggerRef)
    Log("OnTriggerEnter " + triggerRef)
    Log("GetTriggerObjectCount => " + GetTriggerObjectCount())
    if IsHookable(triggerRef)
        ActivatorRef = GetLinkedRef(WRackActivator)
        if ActivatorRef
            ActivatorRef.Disable()
        endif
        ActivatorRef = NONE
        triggerRef.Lock(TRUE)
    endif
    
endEVENT

EVENT OnTriggerLeave(objectReference triggerRef)
    ;debug.MessageBox("OnTriggerLeave " + triggerRef)
    Log("OnTriggerLeave " + triggerRef)
    Log("GetTriggerObjectCount => " + GetTriggerObjectCount())
    if IsHookable(triggerRef)
        ActivatorRef = GetLinkedRef(WRackActivator)
        if ActivatorRef
            ActivatorRef.Enable()
        endif
        ActivatorRef = NONE
        triggerRef.Lock(FALSE)
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

bool Function IsHookable(ObjectReference refObj)
    bool hookable = FALSE
    hookable = hookable || DSC04PaintingList01.HasForm(refObj.GetBaseObject())
    hookable = hookable || DSC04PlateList01.HasForm(refObj.GetBaseObject())
    hookable = hookable || DSC04DefaultHookableList01.HasForm(refObj.GetBaseObject())
    hookable = hookable || refObj.HasKeyword(DSC04Hookable)
    Log("IsHookable " + refObj + " => " + hookable)
    return hookable
EndFunction

Function Log(String msg, String modname="DSC04")
    Debug.Trace("[" + modname + "] " + self + " " + msg)
EndFunction