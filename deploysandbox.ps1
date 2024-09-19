function CreateDir{
    #Will check for a directory and create it if it doesn't exists
    param(
        [string]$destination
        
    )
    
    #Create Downloads Folder
    if (-Not (Test-Path $destination)) {
        Write-Host "Creating Directory: $destination"
        $a= New-Item -Type Directory $destination
       }

    }

function extractZip{
param(
        [string]$url,
        [string]$targetpath,
        [string]$product,
        [string]$filename,
        [string]$sourcedir
        )

    $targetfile = "$sourcedir\\$filename"
    #Extract SysInternals
    if (-Not (Test-Path  $targetpath)) {
        write-host "Extracting $targetfile to: $targetpath"
        Expand-Archive -LiteralPath $targetfile -DestinationPath $targetpath
}
}
  
function DownloadFile{
    param(
        [string]$url,
        [string]$downloadpath,
        [string]$product,
        [string]$filename
    )
    #Create destination directory
    CreateDir -destination $downloadpath
    
    $destination = "$downloadpath\\$filename"
           
    if (-Not (Test-Path $destination)) {
        Write-Host "[*] Downloading $product"
        Write-Host "    Url:  $url"
        Write-Host "    Path: $destination"

        $wc = New-Object net.webclient
        $wc.Downloadfile($url, $destination)

        Write-Host "[+] Downloaded"
        }
    else {
       Write-Host "[*] Already downloaded"
    }
  
}


function InstallProduct{
    param(
        [string]$filename,
        [string]$sourcelocation,
        [string]$product,
        [string]$install_args,
        [string]$checkpath
    )
    $installfile = "$sourcelocation\\$filename"
    
    
    if (-Not (Test-Path checkpath)) {
        Write-Host "[*] Installing $product"
        Write-Host "    Install command: $installfile $install_args"
        Start-Process -FilePath $installfile -ArgumentList $install_args
        Write-Host "[+] Install Command Executed"
        }
    else {
       Write-Host "[*] Already downloaded"
    }
    
    
}

cls
# Download and Import the support files CSV
$template = "default_win10.csv"
$template_download = "$env:TEMP\$template"
Invoke-WebRequest "https://raw.githubusercontent.com/losttroll/azuresandbox/main/$template" -OutFile $template_download

$csvData = Import-Csv -Path $template_download
$file_destination = "c:\\td1"

# Iterate through each row in the CSV
foreach ($row in $csvData) {
    $download_folder = "c:\\td1"

    # Access columns by their header names
    $product = $row.product
    $install_path = $row.install_path
    $file_name = $row.install_file_name
    $mode = $row.mode
    $override_destination = $row.override_file_destination
    $operation = $row.operation
    $install_args = $row.install_args
    $operation_location = $row.operation_location

    #Handle file path for configuration files in installation
     if ($install_args.Contains("FILEDESTINATION")) {
        
        $install_args = $install_args.Replace("FILEDESTINATION", $download_folder)
        write-host "Install Path Updated to:  $install_args"
        }

    #Handle file path for local install paths
     if ($install_path.Contains("FILEDESTINATION")) {
        
        $install_path = $install_path.Replace("FILEDESTINATION", $download_folder)
        write-host "Install Arguments Updated to:  $install_path"
        }

    #overside source
    if ($override_destination.Length -gt 1) {
        write-host "Overriding Source"
        if ($override_destination.Contains("FILEDESTINATION")) {
        
        $override_destination = $override_destination.Replace("FILEDESTINATION", $download_folder)
        write-host "Source Files updated to:  $download_folder"
        }

        #write-host  1, $file_destination
        #write-host 2, $override_destination
        $download_folder = $override_destination
    }
     

    #Download or copy file
    if ($mode -in @("install", "extract", "download")) {
        if ($operation -eq "web_download") {
        DownloadFile -url $operation_location -downloadpath $file_destination -filename $file_name -product $product
            }
        }

    #Extract file
    if ($mode -in @("extract")) {
        extractZip -targetpath $install_path -product $product -filename $file_name -sourcedir $file_destination

        }  
    
    #Install file
    if ($mode -in @("install")) {
         InstallProduct -filename $file_name -sourcelocation $file_destination -product $product -install_args $install_args -checkpath $install_path
         }

    }
