$PackageName = "run-once"
$Version = "1"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName.log" -Force
try{
    # Check if Task exist with correct version
    $task_existing = Get-ScheduledTask -TaskName $PackageName -ErrorAction SilentlyContinue
    if($task_existing.Description -like "Version $Version*"){


        ############################################################################################
        #   YOUR CODE TO RUN ONCE

        Certutil -deletehellocontainer

        #   END RUN ONCE CODE
        ############################################################################################

        # Delete ScheduledTask
        Unregister-ScheduledTask -TaskName $PackageName -Confirm:$false

        # Delete Script
        Remove-Item -Path $MyInvocation.MyCommand.Source

    }else{
        # script path
        $script_path = "$Path_4netIntune\Data\$PackageName.ps1"
        # get and save file content
        Get-Content -Path $($PSCommandPath) | Out-File -FilePath $script_path -Force
        
        # Register scheduled task to run at startup
        $schtaskDescription = "Version $Version"
        $trigger = New-ScheduledTaskTrigger -AtStartup
        $principal= New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType "ServiceAccount" -RunLevel "Highest"
        $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$script_path`""
        $settings= New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        Register-ScheduledTask -TaskName $PackageName -Trigger $trigger -Action $action -Principal $principal -Settings $settings -Description $schtaskDescription -Force
    }
}catch{
    Write-Error $_
}

Stop-Transcript