Class codeInspector.env.Installer Extends %Projection.AbstractProjection [ CompileAfter = codeInspector.env.Config ]
{

ClassMethod CreateProjection(classname As %String) As %Status [ CodeMode = generator, ForceGenerate ]
{
    Try
    {
        Set namespace = $NAMESPACE

        zn "%SYS"

        Do ##class(codeInspector.env.Config).MapCodeInspector(namespace)
        Do ##class(codeInspector.env.Config).CreateWebApplication(namespace)

        zn namespace
    } 
    Catch(e) 
    {
        Set Status = e.AsStatus()
        Set msg = $System.Status.GetErrorText(Status)
        Write msg_$$$NL
        zn namespace
    }
	
	Return $$$OK
}

}
