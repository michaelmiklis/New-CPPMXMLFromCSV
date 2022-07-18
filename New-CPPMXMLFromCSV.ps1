######################################################################
## (C) 2022 Michael Miklis
##
##
## Filename:      New-CPPMXMLFromCSV.ps1
##
## Version:       1.0
##
## Release:       Final
##
## Requirements:  -none-
##
## Description:   The New-CPEMXMLFromCSV CMDlet creates a XML file
##                from a given CSV that can be imported in Aruba
##                Clearpass Policy Manager for new endpoints.
##
## This script is provided 'AS-IS'.  The author does not provide
## any guarantee or warranty, stated or implied.  Use at your own
## risk. You are free to reproduce, copy & modify the code, but
## please give the author credit.
##
####################################################################

 
<#
    .SYNOPSIS
    Converts CSV containing macaddresses to XML file

    .DESCRIPTION
    The New-CPEMXMLFromCSV CMDlet creates a XML file
    from a given CSV that can be imported in Aruba
    Clearpass Policy Manager for new endpoints.

    .PARAMETER SourceCSVFile
    Full path to the given import.csv file

    .PARAMETER DestinationXMLFile
    Full path to the export xml file

    .EXAMPLE
    New-CPPMXMLFromCSV -SourceCSVFile "C:\temp\sample.csv" -DestinationXMLFile "C:\temp\export.xml"

#>

param (
    [parameter(Mandatory = $true)][string]$SourceCSVFile,
    [parameter(Mandatory = $true)][string]$DestinationXMLFile
)

Set-PSDebug -Strict
Set-StrictMode -Version latest

[System.XML.XMLDocument]$xml = New-Object -TypeName System.Xml.XmlDocument
$xmlDeclatation = $xml.CreateXmlDeclaration("1.0", "UTF-8", "yes")
$xml.InsertBefore( $xmlDeclatation, $xml.DocumentElement)

[System.XML.XMLElement]$xmlTipsContents = $xml.CreateElement("TipsContents")
$xmlTipsContents.SetAttribute("xmlns", "http://www.avendasys.com/tipsapiDefs/1.0")
$xml.AppendChild($xmlTipsContents)

[System.XML.XMLElement]$xmlEndpoints = $xml.CreateElement("Endpoints")
$xmlTipsContents.AppendChild($xmlEndpoints)

$CSVEndpoints = Import-Csv -Path $SourceCSVFile -Delimiter ";"

foreach ($Endpoint in $CSVEndpoints)
{   
    [System.XML.XMLElement]$xmlEndpoint = $xml.CreateElement("Endpoint")
    $xmlEndpoint.SetAttribute("macVendor", $Endpoint.macvendor)
    $xmlEndpoint.SetAttribute("macAddress", $Endpoint.macaddress.Replace(":", "").tolower())
    $xmlEndpoint.SetAttribute("status", $Endpoint.status)
    $xmlEndpoints.AppendChild($xmlEndpoint)

    [System.XML.XMLElement]$xmlEndpointTags = $xml.CreateElement("EndpointTags")
    $xmlEndpointTags.SetAttribute("tagName", "Description")
    $xmlEndpointTags.SetAttribute("tagValue", $Endpoint.macaddress.Replace(":", "").tolower())
    $xmlEndpoint.AppendChild($xmlEndpointTags)

    [System.XML.XMLElement]$xmlEndpointTags = $xml.CreateElement("EndpointTags")
    $xmlEndpointTags.SetAttribute("tagName", "Compliance")
    $xmlEndpointTags.SetAttribute("tagValue", $Endpoint.compliance)
    $xmlEndpoint.AppendChild($xmlEndpointTags)

    [System.XML.XMLElement]$xmlEndpointTags = $xml.CreateElement("EndpointTags")
    $xmlEndpointTags.SetAttribute("tagName", "Source")
    $xmlEndpointTags.SetAttribute("tagValue", $Endpoint.source)
    $xmlEndpoint.AppendChild($xmlEndpointTags)
}

$xml.Save($DestinationXMLFile)