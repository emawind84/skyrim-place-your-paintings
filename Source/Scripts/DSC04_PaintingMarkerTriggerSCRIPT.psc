Scriptname DSC04_PaintingMarkerTriggerSCRIPT extends ObjectReference  

import game
import debug
import utility

Keyword Property WRackActivator Auto

;The activator we must disable if there is already something in this trigger
ObjectReference Property ActivatorRef Auto Hidden

Int Property numInTrig Auto Hidden

Bool Property AlreadyInit Auto Hidden

FormList Property DSC04PaintingList Auto

Int InTrigger = 0

EVENT OnReset()
    AlreadyInit = FALSE
    ;Log("DARYL - " + self + " running OnReset() and AlreadyInit = " + AlreadyInit)
endEVENT

EVENT OnUpdate()
    Log("GetTriggerObjectCount => " + GetTriggerObjectCount())
    if GetTriggerObjectCount() == 0
        ActivatorRef = GetLinkedRef(WRackActivator)
        if ActivatorRef
            ActivatorRef.Enable()
        endif
    else
        ActivatorRef = GetLinkedRef(WRackActivator)
        if ActivatorRef
            ActivatorRef.Disable()
        endif
    endif
    ActivatorRef = NONE
    RegisterForSingleUpdate(2)
endEVENT

EVENT OnLoad()
    Log("running OnLoad() and AlreadyInit = " + AlreadyInit)
    if (AlreadyInit == FALSE) && (self.IsEnabled())
        ActivatorRef = GetLinkedRef(WRackActivator)
        if (ActivatorRef)
            Log("The Activator Ref is " + ActivatorRef)
            ActivatorRef.Enable()
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

Function Log(String msg, String modname="DSC04")
    Debug.Trace("[" + modname + "] " + self + " " + msg)
EndFunction