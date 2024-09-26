Class codeInspector.env.Config Extends %RegisteredObject
{

ClassMethod CreateWebApplication(pFromNS = "")
{
    zn "%SYS" 
    Set application = "/codeinspector"
    Set Status = $$$OK
    
    Set spec("AutheEnabled") = $$$AutheUnauthenticated
    Set spec("NameSpace") = pFromNS
    Set spec("Description") = "Api CodeInspector Rest Installer"
    Set spec("IsNameSpaceDefault") = $$$NO
    Set spec("DispatchClass") = "codeInspector.api.Service"
    Set spec("MatchRoles") = ":%All"

    If ('##class(Security.Applications).Exists(application)) {
        Write !!, "Creating the web application """_application_""""
        $$$THROWONERROR(Status,##class(Security.Applications).Create(application, .spec))
        Write !, "Web application """_application_""" has been created.",!
    }
    Else {
        Write !!, "Updating the web application """_application_""""
        $$$THROWONERROR(Status,##class(Security.Applications).Modify(application, .spec))
        Write !, "Web application """_application_""" has been updated.",!
    }
    zn pFromNS
}

ClassMethod MapCodeInspector(pFromNS = "")
{
    zn "%SYS"

	Set namespace = "%ALL"
	Set package = "codeInspector"
    Do ##class(Config.Namespaces).Get(pFromNS, .installNSProps)
    Set properties("Database") = installNSProps("Routines")

	If ('##class(Config.MapPackages).Exists(namespace,package))
	{ 
		Write !,"Creating mapping of package """_package_""" for all namespaces."
		$$$THROWONERROR(Status, ##class(Config.MapPackages).Create(namespace,package,.properties))
        Write !, "Mapping of package """_package_""" has been created."
	}

    zn pFromNS
}

}
