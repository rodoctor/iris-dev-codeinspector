Class codeInspector.env.Installer [ CompileAfter = codeInspector.env.Config, LegacyInstanceContext ]
{

ClassMethod Install()
{
    Try
    {
        Set namespace = $NAMESPACE

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
}

}
