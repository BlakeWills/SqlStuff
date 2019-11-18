## Based on the original: https://www.sqlskills.com/blogs/jonathan/the-adventureworks2008r2-books-online-random-workload-generator/

param(
	[Parameter(Mandatory)]
	[string]$ServerName,
	[Parameter(Mandatory)]
	[string]$DBName,
	[Parameter(Mandatory)]
	[string]$Username,
	[Parameter(Mandatory)]
	[string]$Password,
	[Parameter(Mandatory=$false)]
	[int]$parallelism=1,
	[Parameter(Mandatory=$false)]
	[int]$sleepIntervalMs=100
)

# Split the input on the delimeter 
$Queries = Get-Content -Delimiter "---------" -Path "AdventureWorks2017BOLWorkload.sql" 

$conString="Server=$ServerName;User ID=$Username;Password=$Password;Database=$DBName"
Write-Host "$conString"

$runWorkloadScriptBlock = {
    param(
        [string]$conString,
        [string[]]$Queries,
        [int]$sleepIntervalMs,
        [bool]$logExecutions=$false
    )

    while($true) {
        try {
            # Pick a Random Query from the input object 
            $Query = Get-Random -InputObject $Queries;
    
            $con = New-Object System.Data.SqlClient.SqlConnection
            $con.ConnectionString = $conString
            $con.Open()
    
            $cmd = New-Object System.Data.SqlClient.SqlCommand
            $cmd.CommandText = $Query
            $cmd.Connection = $con
    
            $cmd.ExecuteNonQuery();
        }
        finally {
            $cmd.Dispose()
            $con.Close()
            $con.Dispose()
        }

        if($logExecutions) {
            $querySampleChars = [Math]::Min($Query.Length, 250)
            Write-Host "Executed: $($Query.Substring(0, $querySampleChars))"
        }
        
        Start-Sleep -Milliseconds $sleepIntervalMs
    }
}

if($parallelism -eq 1) {
    $log=$true
    Invoke-Command -ScriptBlock $runWorkloadScriptBlock -ArgumentList $conString, $Queries, $sleepIntervalMs, $log
}
else {
    for($i = 0; $i -lt $parallelism; $i++) {
        Start-Job -ScriptBlock $runWorkloadScriptBlock -ArgumentList $conString, $Queries, $sleepIntervalMs
    }
}

## to stop running if parallelism -gt 1:
# Get-Job | Stop-Job