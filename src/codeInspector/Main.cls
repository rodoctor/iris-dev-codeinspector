Class codeInspector.Main Extends codeInspector.core.Base
{

/// <summary>
/// The `Execute` method runs the CodeInspector to validate classes based on predefined rules.
/// It processes each provided package, identifies the associated classes, and applies validations,
/// excluding the ones that should be ignored.
/// </summary>
/// <params>
/// 	<ul>
/// 		<li><b>pPackages</b> - Comma-separated list of packages to be inspected.</li>
/// 		<li><b>IgnoredPackages</b> - Comma-separated list of packages to be ignored during execution.</li>
/// 	</ul>
/// </params>
/// <example>
/// Do ##class(codeInspector.Main).Execute("package.A,package.B","package.C")
/// </example>
ClassMethod Execute(pPackages As %String, IgnoredPackages As %String)
{
	Try
	{
		WRITE !!,"Initiating CodeInspector execution",!!
		
		Set arrayErrors = ##class(%ArrayOfObjectsWithClassName).%New()
		Set arrayErrors.ElementType = "%ListOfDataTypes"
		
		Set packageList = $LISTFROMSTRING(pPackages)
		For indexPackage=1:1:$LISTLENGTH(packageList)
		{
			Set packageName = $LISTGET(packageList,indexPackage)
			$$$THROWONERROR(Status,$System.OBJ.GetPackageList(.classList,packageName))

			Set class = $ORDER(classList(""))
			
			While (class'="") 
			{
				If ('..IgnoreClass(class,IgnoredPackages))
				{
					Do ..ClassValidator(class,.arrayErrors)
				}

				Set class = $ORDER(classList(class))
			}
		}
		Do ..DisplayErrorsInOutput(arrayErrors)
	}
	Catch(e)
	{
		Set Status = e.AsStatus()
		WRITE !, $System.Status.GetErrorText(Status)
	}
	WRITE !!,"Execution completed",!!
}

}
