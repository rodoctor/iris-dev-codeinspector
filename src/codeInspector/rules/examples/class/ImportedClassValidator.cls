Class codeInspector.rules.examples.class.ImportedClassValidator Extends codeInspector.rules.BaseRule
{

ClassMethod Execute(pMethodContent As %Stream.GlobalCharacter, pIdMethod As %String, ByRef pArrayErrors As %ArrayOfObjectsWithClassName)
{
	While ('pMethodContent.AtEnd)
	{
		Set lineContent = pMethodContent.ReadLine()
		
		Set className = ..RecoverClassName(lineContent)
		
		If (className [ "%")
		{
			Continue
		}
		
		If (className '= "")
		{
			If ('##class(%Dictionary.CompiledClass).%ExistsId(className))
			{
                Set type = "Missing Dependency"
				Set errorDescription = "The class ("_className_") was not found in the environment."
				Do ..IncrementStatusError(.pArrayErrors,pIdMethod,type,lineContent,errorDescription)
			}
		}
	}
}

ClassMethod RecoverClassName(pLine As %String) As %String
{
	Set regex = "(?<=\#\#class\().*?(?=\))"
    Set obj = ##class(%Regex.Matcher).%New(regex,pLine)
    Do obj.Locate()
    
    Quit obj.Group
}

}
