Class codeInspector.rules.BaseRule [ Abstract ]
{

ClassMethod Execute(pMethodContent As %Stream.GlobalCharacter, pIdMethod As %String, ByRef pArrayErrors As %ArrayOfObjectsWithClassName) [ CodeMode = objectgenerator ]
{
  If (%classname '= "codeInspector.rules.BaseRule") {
    $$$THROWONERROR(Status,$$$ERROR($$$GeneralError, "Method "_%method.Name _ " not implemented by class " _ %classname))
  }
  
  Quit $$$OK
}

ClassMethod IncrementStatusError(ByRef pArrayErrors As %ArrayOfObjectsWithClassName, pIdMethod As %String = "", pType As %String, pContentLine As %String = "", pErrorDescription As %String(MAXLEN="2500") = "") [ Final ]
{
	Set Status = $$$OK
	Set errorList = pArrayErrors.GetAt(pIdMethod)
	
	If ('$ISOBJECT(errorList))
	{
		Set errorList = ##class(%ListOfDataTypes).%New()
	}

	Set alerts = ##class(%ArrayOfDataTypes).%New()
	
	Set:(pType '= "") Status = alerts.SetAt(($ZSTRIP((pType),"<>W")),"Type")
	Set:(pContentLine '= "") Status = alerts.SetAt(($ZSTRIP((pContentLine),"<>W")),"Code")
	Set:(pErrorDescription '= "") Status = alerts.SetAt(pErrorDescription,"Description")
	
	$$$THROWONERROR(Status,errorList.Insert(alerts))
	$$$THROWONERROR(Status,pArrayErrors.SetAt(errorList,pIdMethod))
}

}
