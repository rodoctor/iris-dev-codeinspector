Class codeInspector.utl.XData Extends %RegisteredObject
{

ClassMethod GenerateXDataString(pClassName As %String, pXDataName As %String = "") As %String [ Internal ]
{
	Set xdataID= pClassName_"||"_pXDataName
   	Set xdata=##class(%Dictionary.CompiledXData).%OpenId(xdataID,,.Status)
   	If $$$ISERR(Status) Throw ##class(%Exception.StatusException).CreateFromStatus(Status)

	Quit xdata.Data.Read(xdata.Data.Size)
}

}
