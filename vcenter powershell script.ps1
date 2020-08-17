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
  $vmstat = "" | Select VmName, PowerState, GuestId, VMHost, NumCPUs, MemoryGB, UsedSpaceGB, ProvisionedSpaceGB, HarddiskGB, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin
  $vmstat.VmName = $vm.name
  $vmstat.Powerstate = $vm.powerstate
  $vmstat.GuestId = $vm.GuestId
  $vmstat.VMHost = $vm.VMHost
  $vmstat.NumCPUs = $vm.NumCPU
  $vmstat.MemoryGB = $vm.MemoryGB
  $vmstat.UsedSpaceGB = $vm.UsedSpaceGB.ToString("##.##")
  $vmstat.ProvisionedSpaceGB = $vm.ProvisionedSpaceGB.ToString("##.##")

  $vmstat.HarddiskGB = (Get-HardDisk -VM $vm | Measure-Object -Sum CapacityGB).Sum.ToString("##.##")

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
$allvms | Select VmName, PowerState, GuestId, VMHost, NumCPUs, MemoryGB, UsedSpaceGB, ProvisionedSpaceGB, HarddiskGB, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin | Export-Csv "VMs10.csv" -noTypeInformation
