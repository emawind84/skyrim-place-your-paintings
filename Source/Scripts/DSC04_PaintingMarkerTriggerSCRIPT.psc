Scriptname DSC04_PaintingMarkerTriggerSCRIPT extends ObjectReference  

import game
import debug
import utility

Keyword Property WRackActivator Auto

FormList Property DSC04PaintingList Auto

Keyword Property DSC04DisableParent Auto

Keyword Property DSC04EnableParent Auto

;The activator we must disable if there is already something in this trigger
ObjectReference Property ActivatorRef Auto Hidden

Bool Property AlreadyInit Auto Hidden

ObjectReference Property EnableParentRef Auto Hidden

ObjectReference Property DisableParentRef Auto Hidden

Actor Property PlayerRef Auto

Int InTrigger = 0

EVENT OnReset()
    AlreadyInit = FALSE
    ;Log("DARYL - " + self + " running OnReset() and AlreadyInit = " + AlreadyInit)
endEVENT

EVENT OnUpdate()
    ;Log("OnUpdate - GetTriggerObjectCount => " + GetTriggerObjectCount())
    if self.IsEnabled() && GetTriggerObjectCount() == 0
        ActivatorRef = GetLinkedRef(WRackActivator)
        if ActivatorRef
            ;Log("Enabling activator")
            ActivatorRef.Enable()
        endif
    else
        ActivatorRef = GetLinkedRef(WRackActivator)
        if ActivatorRef
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

EVENT OnCellLoad()
    Log("running OnCellAttach() and AlreadyInit = " + AlreadyInit)
    ToggleMarker()

    if (AlreadyInit == FALSE) && (self.IsEnabled())
        ActivatorRef = GetLinkedRef(WRackActivator)
        if (ActivatorRef)
            Log("The Activator Ref is " + ActivatorRef)
            ActivatorRef.Enable()
            ; required since the oncellattach event in the activator might get fired 
            ; when this ref is still disabled, and the starting painting/item is not handled
            ;ActivatorRef.RegisterForSingleUpdate(2)
        endif
        ActivatorRef = NONE
        AlreadyInit = TRUE
    else
        ;Do nothing
    endif

    Log("finishing OnLoad() and AlreadyInit = " + AlreadyInit)
    Log("GetTriggerObjectCount => " + GetTriggerObjectCount())
    RegisterForSingleUpdate(2)
endEVENT

auto STATE WaitingForReference

    EVENT OnTriggerEnter(objectReference triggerRef)
        Log("OnTriggerEnter " + triggerRef)
        Log("GetTriggerObjectCount => " + GetTriggerObjectCount())
        if (DSC04PaintingList.HasForm(triggerRef.GetBaseObject()))
            ActivatorRef = GetLinkedRef(WRackActivator)
            if ActivatorRef
                ActivatorRef.Disable()
            endif
            ActivatorRef = NONE
            triggerRef.Lock(TRUE)
        endif
        
    endEVENT

    EVENT OnTriggerLeave(objectReference triggerRef)
        Log("OnTriggerLeave " + triggerRef)
        Log("GetTriggerObjectCount => " + GetTriggerObjectCount())
        if DSC04PaintingList.HasForm(triggerRef.GetBaseObject())
            ActivatorRef = GetLinkedRef(WRackActivator)
            if ActivatorRef
                ActivatorRef.Enable()
            endif
            ActivatorRef = NONE
            triggerRef.Lock(FALSE)
        endif
    endEVENT
endSTATE

Function ToggleMarker()
    EnableParentRef = GetLinkedRef(DSC04EnableParent)
    DisableParentRef = GetLinkedRef(DSC04DisableParent)
    Log("EnableParentRef => " + EnableParentRef)
    Log("DisableParentRef => " + DisableParentRef)

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

    if bEnable
        self.Enable()
    else
        self.Disable()
    endif

    Log("Marker enabled => " + self.IsEnabled())

    EnableParentRef = NONE
    DisableParentRef = NONE
EndFunction

Function Log(String msg, String modname="DSC04")
    Debug.Trace("[" + modname + "] " + self + " " + msg)
EndFunction