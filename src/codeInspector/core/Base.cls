Class codeInspector.core.Base
{

ClassMethod IgnoreClass(pClassName, pIgnoredPackageList) As %Boolean [ Internal ]
{
	Set return = 0
	Set list = $LISTFROMSTRING(pIgnoredPackageList)

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
				Set indexProps = ""
				Set arrayProps = errorList.GetAt(index)
				While (arrayProps.GetNext(.indexProps) '= "")
				{
					Write $$$TAB_"> "_indexProps_": "_arrayProps.GetAt(indexProps),!
				}
				Write $$$NL
			}
		}
	}
}

ClassMethod ReturnJson(pArrayErrors) As %Stream.GlobalCharacter
{
	Set report = {}
	Set report.errors = []
	
	While (pArrayErrors.GetNext(.indexArray))
	{
		Set errorList = pArrayErrors.GetAt(indexArray)

		If ($ISOBJECT(errorList))
		{
			Set error = {}.%New()
			Set error.class = $PIECE(indexArray,"||",1)
			Set error.method = $PIECE(indexArray,"||",2)
			Set error.issues = []

			For index=1:1:errorList.Count()
			{
				Set itemError = errorList.GetAt(index)

				Set issue = {}.%New()
				Set issue.code = itemError.GetAt("Code")
				Set issue.description = itemError.GetAt("Description")
				Set issue.type = itemError.GetAt("Type")
				Do error.issues.%Push(issue)
			}

			Do report.errors.%Push(error)
		}
	}
	Set json = ##class(%Stream.GlobalCharacter).%New()
	Do report.%ToJSON(json)

	Return json
}

}
