Scriptname DSC04_PlayerAliasScript extends ReferenceAlias
{Script used in maintenance quest}

DSC04_SupportQuestSCRIPT Property QuestScript Auto

Event OnPlayerLoadGame()
    QuestScript.Maintenance()
EndEvent