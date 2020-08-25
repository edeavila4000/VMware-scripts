# VMware-scripts
Script to pull vm information from vcenter via powershell. The script will connect to vcenter, do a get-vm and out put two spreadsheets, one for the hosts and one of the guest VMs. 
For the guest VM's it pulls the VMname, powerstate, NumCPU's, MemoryGB, MemMax (over 7 days), MemMin (over 7 days), CPUMax (over 7 days), CPUAvg (over 7 days and CPUMin (over 7 days). You can maninpulate the average days on lines 40 and 41.

Pre-requistes
Requires VMware PowerCLI which you can download here:

https://www.powershellgallery.com/packages/VMware.PowerCLI/12.0.0.15947286


Click on Go to File to view the code.

