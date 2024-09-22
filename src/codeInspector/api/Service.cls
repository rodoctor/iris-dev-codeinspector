Class codeInspector.api.Service Extends %CSP.REST
{

Parameter UseSession As Integer = 1;

Parameter NOCHARSETCONVERT = 1;

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/" Method="GET" Call="Report" Cors="false" />
</Routes>
}

ClassMethod Report() As %Boolean
{
    Try
    {   
        Set originNs = $NAMESPACE
        Set %response.ContentType = "application/json;charset=UTF-8"

        Do ..ValidateRequiredParams()

        Set namespace = $GET(%request.Data("namespace", 1),0)
        Do ..ValidateNamespace(namespace)
        
        Set packages = $GET(%request.Data("packages", 1),0)
        Set ignoredpackages = $GET(%request.Data("ignoredpackages", 1),0)

        zn namespace
    	Set json = ##class(codeInspector.Main).Execute(packages,ignoredpackages,1)
        While ('json.AtEnd)
        {
            Write json.Read()
        }

        zn originNs
    }
	Catch(e)
    {
        zn originNs
        Set Status = e.AsStatus()
        Set msg = $System.Status.GetOneErrorText(Status)
        write "{""ErrorDescription"":"_msg_"}"
    }
    Quit $$$OK
}

ClassMethod ValidateRequiredParams()
{
    Set params = $LISTFROMSTRING("namespace,packages",",")

    For i=1:1:$LISTLENGTH(params)
    {
        Set param = $LISTGET(params,i)
        Set value = $GET(%request.Data(param, 1),"")
        
        If (value = "")
        {
            Set msg = "The '"_param_"' parameter is required and must be set."
            $$$THROWONERROR(Status,$$$ERROR(5001,msg))
        }
    }
}

ClassMethod ValidateNamespace(pNamespace)
{
    Set namespaceExists = ##class(%SYS.Namespace).Exists(pNamespace)
    If (namespaceExists = 0)
    {
        Set msg = "The namespace '"_pNamespace_"' doesn't exist."
        $$$THROWONERROR(Status,$$$ERROR(5001,msg))
    }
}

}
