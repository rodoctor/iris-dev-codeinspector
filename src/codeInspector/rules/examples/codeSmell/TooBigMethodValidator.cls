Class codeInspector.rules.examples.codeSmell.TooBigMethodValidator Extends codeInspector.rules.BaseRule
{

ClassMethod Execute(pMethodContent As %Stream.GlobalCharacter, pIdMethod As %String, ByRef pArrayErrors As %ArrayOfObjectsWithClassName)
{
	Set lineCount = 0
	While ('pMethodContent.AtEnd)
	{
		Do pMethodContent.ReadLine()
		Set lineCount = $INCREMENT(lineCount)
	}
	
	If (lineCount >= 50)
	{	
        Set type = "Bad Smell"
        Set errorDescription = "Method is too large, consider refactoring. It contains ("_lineCount_") lines."
		
        Do ..IncrementStatusError(.pArrayErrors,pIdMethod,type,,errorDescription)
	}
}

}
