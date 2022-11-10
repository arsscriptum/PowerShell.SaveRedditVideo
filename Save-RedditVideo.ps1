
<#
#̷𝓍   𝓐𝓡𝓢 𝓢𝓒𝓡𝓘𝓟𝓣𝓤𝓜
#̷𝓍   🇵​​​​​🇴​​​​​🇼​​​​​🇪​​​​​🇷​​​​​🇸​​​​​🇭​​​​​🇪​​​​​🇱​​​​​🇱​​​​​ 🇸​​​​​🇨​​​​​🇷​​​​​🇮​​​​​🇵​​​​​🇹​​​​​ 🇧​​​​​🇾​​​​​ 🇬​​​​​🇺​​​​​🇮​​​​​🇱​​​​​🇱​​​​​🇦​​​​​🇺​​​​​🇲​​​​​🇪​​​​​🇵​​​​​🇱​​​​​🇦​​​​​🇳​​​​​🇹​​​​​🇪​​​​​.🇶​​​​​🇨​​​​​@🇬​​​​​🇲​​​​​🇦​​​​​🇮​​​​​🇱​​​​​.🇨​​​​​🇴​​​​​🇲​​​​​
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="url", Position=0)]
    [string]$Url       
)

$ShowNotifPath = Join-Path "$PSScriptRoot\systray" "ShowSystemTrayNotification.ps1"
. "$ShowNotifPath"
Import-Module  "$PSScriptRoot\lib\NativeProgressBar.dll" -Force

$FatalError = $False
try{
    Get-Command 'Register-AsciiProgressBar' -ErrorAction Stop | Out-Null 
    Get-Command 'Unregister-AsciiProgressBar' -ErrorAction Stop | Out-Null 
    Get-Command 'Write-AsciiProgressBar' -ErrorAction Stop | Out-Null 
    Get-Command 'Show-SystemTrayNotification' -ErrorAction Stop | Out-Null 
}catch [Exception]{
    Write-Host "[MISSING DEPENDENCY] " -f DarkRed -n
    Write-Host "$_" -f DarkYellow
    Write-Host "Make sure to include:`n==> `"$PSScriptRoot\lib\NativeProgressBar.dll`"`n==> `"$ShowNotifPath`"" -f DarkRed
    $FatalError = $True
}
if($FatalError){
    return
}

function Save-OnlineFileWithProgress{

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$True, Position=0)]
        [string]$Url,
        [Parameter(Mandatory=$True, Position=1)]
        [Alias('Destination', 'p')]
        [string]$Path    
    ) 
    try{
        new-item -path $Path -ItemType 'File' -Force | Out-Null
        remove-item -path $Path -Force | Out-Null

        $Script:ProgressTitle = 'STATE: DOWNLOAD'
        $uri = New-Object "System.Uri" "$Url"
        $request = [System.Net.HttpWebRequest]::Create($Url)
        $request.PreAuthenticate = $false
        $request.Method = 'GET'
        $request.Headers = New-Object System.Net.WebHeaderCollection
        $request.Headers.Add('User-Agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36')

        # 15 second timeout
        $request.set_Timeout(15000) 

        # Cache Policy : no cache
        $request.CachePolicy                  = New-Object Net.Cache.RequestCachePolicy([Net.Cache.RequestCacheLevel]::NoCacheNoStore)

        # create the Stream, FileStream and WebResponse objects
        [System.Net.WebResponse]$response     = $request.GetResponse()
        [System.IO.Stream]$responseStream     = $response.GetResponseStream()
        [System.IO.FileStream]$targetStream   = [System.IO.FileStream]::new($Path, [System.IO.FileMode]::Create)
        [long]$total_bytes                    = [System.Math]::Floor($response.get_ContentLength())
        [long]$total_kilobytes                = [System.Math]::Floor($total_bytes/1024)

        $buffer                               = new-object byte[] 10KB
        $count                                = $responseStream.Read($buffer,0,$buffer.length)
        $dlkb                                 = 0
        $downloadedBytes                      = $count

        Register-AsciiProgressBar -Size 60

        while ($count -gt 0){
           $targetStream.Write($buffer, 0, $count)
           $count                   = $responseStream.Read($buffer,0,$buffer.length)
           $downloadedBytes         = $downloadedBytes + $count
           $dlkb                    = $([System.Math]::Floor($downloadedBytes/1024))
           $msg                     = "Downloaded $dlkb Kb of $total_kilobytes Kb"
           $perc                    = (($downloadedBytes / $total_bytes)*100)
           if(($perc -gt 0)-And($perc -lt 100)){
                Write-AsciiProgressBar $perc $msg 50 2 "White" "DarkGray"
           }
        }
        Unregister-AsciiProgressBar
        
        $targetStream.Flush()
        $targetStream.Close()
        $targetStream.Dispose()
        $responseStream.Dispose()
    }catch{
        Show-ExceptionDetails $_ -ShowStack
    }
}



function Get-RedditVideoUrl{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="url", Position=0)]
        [string]$Url  
    )

    try{
        $Null =  Add-Type -AssemblyName System.webURL -ErrorAction Stop | Out-Null    
    }catch{}
    

   try{    
        $urlToEncode = $Url
        $encodedURL = [System.Web.HttpUtility]::UrlEncode($urlToEncode) 

        Write-Verbose "The encoded url is: $encodedURL"

        #Encode URL code ends here

        $RequestUrl = "https://www.redditsave.com/info?url=$encodedURL"

        Write-Verbose "Invoke-RestMethod -Uri `"$RequestUrl`" -Method 'GET'"
        $Content = Invoke-RestMethod -Uri "$RequestUrl" -Method 'GET'

        $i = $Content.IndexOf('"https://sd.redditsave.com/download.php')
        $j = $Content.IndexOf('"',$i+1)
        $l = $j-$i
        $RequestUrl = $Content.Substring($i+1, $l-1)

        Write-Output "$RequestUrl"
    }catch{
        Show-ExceptionDetails $_ -ShowStack
    }
}


function Save-RedditVideo{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="url", Position=0)]
        [string]$Url,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, HelpMessage="Destination Directory where the files are saved", Position=1)]
        [string]$DestinationPath,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, HelpMessage="If set, will open the file afer download")]
        [switch]$OpenAfterDownload          
    )
<#
.SYNOPSIS
    Retrieve the download URL for a REDDIT video and download the file
.DESCRIPTION
    Retrieve the download URL for a REDDIT video and download the file for viewing pleasure
.PARAMETER Url
    The Url of the page where the video is located
.PARAMETER DestinationPath
    Destination Directory where the files are saved
.PARAMETER OpenAfterDownload
    If set, will open the file afer download

.EXAMPLE
    Save-RedditVideo.ps1 -Url "https://www.reddit.com/r/ukraine/comments/yqwngl/volodymyr_zelenskyy_official_nov_9th_2022_about/"


.NOTES
    Author: Guillaume Plante
    Last Updated: October 2022
#>
    try{
        $Null =  Add-Type -AssemblyName System.webURL -ErrorAction Stop | Out-Null    
    }catch{}
    

   try{    
        if($PSBoundParameters.ContainsKey("DestinationPath") -eq $False){
            $MyVideos = [environment]::getfolderpath("myvideos")
            $RedditVideoPath = Join-Path $MyVideos 'reddit'
            if(-not(Test-Path -Path $RedditVideoPath -PathType Container)){
                $Null = New-Item -Path $RedditVideoPath -ItemType "Directory" -Force -ErrorAction Ignore 
            }
            $DestinationPath = $RedditVideoPath

        }else{
            if( -not ( Test-Path -Path $DestinationPath -PathType Container)) { throw "DestinationPath argument does not exists ; "}
        }

        [string]$DestinationFile = New-RandomFilename -Path $DestinationPath  -Extension 'mp4'
        [Uri]$ParsedUrlObject = $Url
        $sgm_list = $ParsedUrlObject.Segments
        $sgm_list_count = $sgm_list.Count
        if($sgm_list_count -gt 0){
            $UrlFileName = $sgm_list[$sgm_list_count-1] + '.mp4'
            $UrlFileName = $UrlFileName.Replace('/','')
            $DestinationFile = Join-Path $DestinationPath $UrlFileName
        }

        $DownloadVideoUrl = Get-RedditVideoUrl $Url
        $WgetExe          = Get-WGetExecutable

        Write-Verbose "DestinationPath  : $DestinationPath"
        Write-Verbose "DestinationFile  : $DestinationFile"
        Write-Verbose "DownloadVideoUrl : $DownloadVideoUrl"

        Write-Host -n -f DarkRed "[RedditVideo] " ; Write-Host -f DarkYellow "Please wait...."

        #Save-OnlineFileWithProgress $DownloadVideoUrl $DestinationFile

        $Title = "Download Completed"
        $IconPath = Join-Path "$PSScriptRoot\ico" "download2.ico"

        Show-SystemTrayNotification "Saved $DestinationFile" $Title $IconPath -Duration $Duration

       
        if($OpenAfterDownload){
            start "$DestinationFile"
        }
        "$DestinationFile"
    }catch{
        Show-ExceptionDetails $_ -ShowStack
    }
}

cls
Save-RedditVideo $Url