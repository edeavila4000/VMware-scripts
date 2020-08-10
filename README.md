# VMware-scripts
Script to pull vm information from vcenter via powershell. The script will connect to vcenter, do a get-vm and out put two spreadsheets, one for the hosts and one of the guest VMs. 
For the guest VM's it pulls the VMname, powerstate, NumCPU's, MemoryGB, MemMax (over 7 days), MemMin (over 7 days), CPUMax (over 7 days), CPUAvg (over 7 days and CPUMin (over 7 days). You can maninpulate the days it pulls by altering the code to fit your needs. 



Skip to content
Pull requests
Issues
Marketplace
Explore
@Ernesto4000
Learn Git and GitHub without any code!

Using the Hello World guide, you’ll start a branch, write comments, and open a pull request.
Ernesto4000 /
VMware-scripts

1
0

    0

Code
Issues
Pull requests
Actions
Projects
Wiki
Security
Insights

    Settings

VMware-scripts/vcenter powershell script.ps1
@Ernesto4000
Ernesto4000 Add files via upload
Latest commit a905ab6 1 hour ago
History
1 contributor
47 lines (40 sloc) 2.22 KB




#Connect-VIServer <server> -User user -Password 
$allvms = @()
$allhosts = @()
$hosts = Get-VMHost
$vms = Get-Vm

foreach($vmHost in $hosts){
  $hoststat = "" | Select HostName, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin
  $hoststat.HostName = $vmHost.name
  
  $statcpu = Get-Stat -Entity ($vmHost)-start (get-date).AddDays(-7) -Finish (Get-Date)-MaxSamples 10 -stat cpu.usage.average
  $statmem = Get-Stat -Entity ($vmHost)-start (get-date).AddDays(-7) -Finish (Get-Date)-MaxSamples 10 -stat mem.usage.average

  $cpu = $statcpu | Measure-Object -Property value -Average -Maximum -Minimum
  $mem = $statmem | Measure-Object -Property value -Average -Maximum -Minimum
  
  $hoststat.CPUMax = $cpu.Maximum.ToString("##.##")
  $hoststat.CPUAvg = $cpu.Average.ToString("##.##")
  $hoststat.CPUMin = $cpu.Minimum.ToString("##.##")
  $hoststat.MemMax = $mem.Maximum.ToString("##.##")
  $hoststat.MemAvg = $mem.Average.ToString("##.##")
  $hoststat.MemMin = $mem.Minimum.ToString("##.##")
  $allhosts += $hoststat
}
$allhosts | Select HostName, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin | Export-Csv "Hosts.csv" -noTypeInformation

foreach($vm in $vms){
  $vmstat = "" | Select VmName, PowerState, NumCPUs, MemoryGB, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin
  $vmstat.VmName = $vm.name
  $vmstat.Powerstate = $vm.powerstate
  $vmstat.NumCPUs = $vm.NumCPU
  $vmstat.MemoryGB = $vm.MemoryGB
  $statcpu = Get-Stat -Entity ($vm)-start (get-date).AddDays(-7) -Finish (Get-Date)-MaxSamples 10 -stat "cpu.usage.average"
  $statmem = Get-Stat -Entity ($vm)-start (get-date).AddDays(-7) -Finish (Get-Date)-MaxSamples 10 -stat "mem.usage.average"

  $cpu = $statcpu | Measure-Object -Property value -Average -Maximum -Minimum
  $mem = $statmem | Measure-Object -Property value -Average -Maximum -Minimum
  
  $vmstat.CPUMax = $cpu.Maximum.ToString("##.##")
  $vmstat.CPUAvg = $cpu.Average.ToString("##.##")
  $vmstat.CPUMin = $cpu.Minimum.ToString("##.##")
  $vmstat.MemMax = $mem.Maximum.ToString("##.##")
  $vmstat.MemAvg = $mem.Average.ToString("##.##")
  $vmstat.MemMin = $mem.Minimum.ToString("##.##")
  $allvms += $vmstat
}
$allvms | Select VmName, PowerState, NumCPUs, MemoryGB, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin | Export-Csv "VMs.csv" -noTypeInformation

    © 2020 GitHub, Inc.
    Terms
    Privacy
    Security
    Status
    Help

    Contact GitHub
    Pricing
    API
    Training
    Blog
    About


