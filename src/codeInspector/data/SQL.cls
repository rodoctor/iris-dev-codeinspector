Class codeInspector.data.SQL
{

ClassMethod SearchMethodList(pClassName As %String) As %SQL.StatementResult [ Internal ]
{
	Set sql = ##class(codeInspector.utl.XData).GenerateXDataString("codeInspector.data.SQL","SQLSearchMethod")
	Quit ##class(%SQL.Statement).%ExecDirect(,sql,pClassName,pClassName)
}

ClassMethod SearchRules() As %SQL.StatementResult [ Internal ]
{
	Set sql = ##class(codeInspector.utl.XData).GenerateXDataString("codeInspector.data.SQL","SQLSearchRules")
	Quit ##class(%SQL.Statement).%ExecDirect(,sql)
}

XData SQLSearchMethod [ MimeType = application/sql ]
{
SELECT 
		ID1 As IDMethod
	FROM 
		%Dictionary.CompiledMethod
	WHERE parent = ?
	AND origin  = ?
}

XData SQLSearchRules [ MimeType = application/sql ]
{
SELECT 
	ID As ClassId
FROM 
	%Dictionary.CompiledClass
WHERE 
	Super = 'codeInspector.rules.BaseRule'
}

}
