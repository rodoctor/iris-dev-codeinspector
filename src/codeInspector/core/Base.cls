Class codeInspector.core.Base
{

ClassMethod IgnoreClass(pClassName, IgnoredPackages) As %Boolean [ Internal ]
{
	Set return = 0
	Set list = $LISTFROMSTRING(IgnoredPackages)

	For index=1:1:$LISTLENGTH(list)
	{
		Set ignorePackage = $LISTGET(list,index)
		
		If $FIND(pClassName,ignorePackage)
		{
			Set return = 1
			Return return
		}
		
	}
	Quit return
}

ClassMethod ClassValidator(pClassName, ByRef pRulesStatus) [ Internal ]
{

	#DIM resultSet As %SQL.StatementResult

	Set resultSet = ##class(codeInspector.data.SQL).SearchMethodList(pClassName)
	
	While resultSet.%Next()
	{
		Do ..MethodValidator(resultSet.%Get("IDMethod"),.pRulesStatus)
	}
}

ClassMethod MethodValidator(pIdMethod, ByRef pRulesStatus) [ Internal ]
{
	#DIM streamMethod As %Stream.TmpCharacter
	
	Set IdMethod = pIdMethod
	Set dictionaryMethod = ##Class(%Dictionary.CompiledMethod).%OpenId(IdMethod)
	Set streamMethod = dictionaryMethod.Implementation
	
	Set rsRegras = ##class(codeInspector.data.SQL).SearchRules()
	While rsRegras.%Next()
	{
		Do streamMethod.Rewind()
		
		Set classId = rsRegras.ClassId
		Do $CLASSMETHOD(classId,"Execute",streamMethod,IdMethod,.pRulesStatus)
	}
}

ClassMethod DisplayErrorsInOutput(pArrayErrors As %ArrayOfObjectsWithClassName) [ Internal ]
{
	While (pArrayErrors.GetNext(.indexArray))
	{
		Set errorList = pArrayErrors.GetAt(indexArray)
		
		If ($ISOBJECT(errorList))
		{
			Write ("ERROR: ("_indexArray_")"),!
			For index=1:1:errorList.Count()
			{
				Write errorList.GetAt(index),!
			}
		}
	}
}

}
