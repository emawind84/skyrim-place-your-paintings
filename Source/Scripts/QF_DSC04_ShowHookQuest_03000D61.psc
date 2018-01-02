;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 12
Scriptname QF_DSC04_ShowHookQuest_03000D61 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Hook03
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Hook03 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Hook01
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Hook01 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Hook02
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Hook02 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Hook05
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Hook05 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Hook06
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Hook06 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Hook07
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Hook07 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Hook11
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Hook11 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Hook04
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Hook04 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Hook08
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Hook08 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Hook10
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Hook10 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Hook09
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Hook09 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Hook12
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Hook12 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
if Alias_Hook01.GetReference() == None
  SetStage(20)
  return
endif
SetObjectiveDisplayed(10)
SetActive(TRUE)
utility.wait(30)
SetObjectiveDisplayed(10, FALSE)
SetStage(30)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
NoHookFound.Show()
SetStage(30)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Message Property NoHookFound  Auto  
