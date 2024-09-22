Class codeInspector.rules.BaseRule [ Abstract ]
{

ClassMethod Execute(pMethodContent As %Stream.GlobalCharacter, pIdMethod As %String, ByRef pArrayErrors As %ArrayOfObjectsWithClassName) [ CodeMode = objectgenerator ]
{
  If (%classname '= "codeInspector.rules.BaseRule") {
    $$$THROWONERROR(Status,$$$ERROR($$$GeneralError, "Method "_%method.Name _ " not implemented by class " _ %classname))
  }
  
  Quit $$$OK
}

ClassMethod IncrementStatusError(ByRef pArrayErrors As %ArrayOfObjectsWithClassName, pIdMethod As %String, pType As %String, pContentLine As %String, pErrorDescription As %String(MAXLEN="2500")) [ Final ]
{
	
	Set errorList = pArrayErrors.GetAt(pIdMethod)
	
	If ('$ISOBJECT(errorList))
	{
		Set errorList = ##class(%ListOfDataTypes).%New()
	}
	
	Set alerts = ""
	
	Set:(pType '= "") alerts = alerts_$LISTBUILD($$$TAB_"> Type: "_$ZSTRIP((pType),"<>W"))
	Set:(pContentLine '= "") alerts = alerts_$LISTBUILD($$$TAB_"> Code: "_$ZSTRIP((pContentLine),"<>W"))
	Set:(pErrorDescription '= "") alerts = alerts_$LISTBUILD($$$TAB_"> Description: "_pErrorDescription)
	
	Set msg = $LISTTOSTRING(alerts,$$$NL)_$$$NL
	
	$$$THROWONERROR(Status,errorList.Insert(msg))
	$$$THROWONERROR(Status,pArrayErrors.SetAt(errorList,pIdMethod))
}

}
