# New-CPPMXMLFromCSV
Create Aruba Clearpass Policy Manager importable endpoint XML from CSV file.

## Usage
Execute the following commandline in a PowerShell Window after you have loaded the script:

	`New-CPPMXMLFromCSV.ps1 -SourceCSVFile "C:\temp\sample.csv" -DestinationXMLFile "C:\temp\export.xml"`

## Import CSV file import format
The CSV file provided for `-SourceCSVFile` parameter needs to be in the following format:

|macaddress       |macvendor      |compliance|source       |status|
|-----------------|---------------|----------|-------------|------|
|11:A5:1D:6C:A6:71|Intel Corporate|Compliant |Provider Name|Known |
|BD:6E:E2:E6:1C:2C|Intel Corporate|Compliant |Provider Name|Known |

Please use ";" as a delimter.

