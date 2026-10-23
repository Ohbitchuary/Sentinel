# Made by Misfit, free for use.
# The most common ports used by Monero/Bitcoin mining pools
$MiningPorts = @(3333, 4444, 5555, 7777, 8332, 14444)

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       NETWORK SENTINEL BY MISFIT" -ForegroundColor Magenta
Write-Host "       SEARCHING.. SEEK AND DESTROY!" -ForegroundColor Magenta
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to terminate loop.`n"

while ($true) {
    # Fetch active outbound TCP connections using native, allowed objects
    $Connections = Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue | 
        Where-Object { $_.RemotePort -in $MiningPorts }

    if ($Connections) {
        # Trigger visual alert warning
        Clear-Host
        Write-Host "[!!! ALERT !!!] ANOMALY DETECTED!" -ForegroundColor Red
        Write-Host "-------------------------------------------------------" -ForegroundColor Red
        
        foreach ($Conn in $Connections) {
            # Safely query the process name using its system ID
            $ProcName = (Get-Process -Id $Conn.OwningProcess -ErrorAction SilentlyContinue).Name
            Write-Host "  -> Process:   $ProcName (PID: $($Conn.OwningProcess))" -ForegroundColor White
            Write-Host "  -> Remote IP: $($Conn.RemoteAddress):$($Conn.RemotePort)" -ForegroundColor Yellow
            Write-Host "-------------------------------------------------------" -ForegroundColor DarkGray
        }
    } else {
        # System is running clean, print a periodic timestamp status update
        $Timestamp = Get-Date -Format "HH:mm:ss"
        Write-Host "[$Timestamp] Network status clean. Nothing to report.." -ForegroundColor Green
    }

    # Pause the thread for 5 seconds before checking again
    Start-Sleep -Seconds 5
}
