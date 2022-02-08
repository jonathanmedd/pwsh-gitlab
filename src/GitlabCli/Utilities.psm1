# Inspired by https://gist.github.com/awakecoding/acc626741704e8885da8892b0ac6ce64
function ConvertTo-PascalCase
{
    param(
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [string] $Value
    )

    # https://devblogs.microsoft.com/oldnewthing/20190909-00/?p=102844
    return [regex]::replace($Value.ToLower(), '(^|_)(.)', { $args[0].Groups[2].Value.ToUpper()})
}

function ConvertTo-SnakeCase
{
    param(
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [string] $Value
    )

    return [regex]::replace($Value, '(?<=.)(?=[A-Z])', '_').ToLower()
}

function ConvertTo-UrlEncoded {
    param (
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [string]
        $Value
    )
    [System.Net.WebUtility]::UrlEncode($Value)
}

function Invoke-GitlabApi {
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $HttpMethod,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $Path,

        [Parameter(Position=2, Mandatory=$false)]
        [hashtable]
        $Query = @{},

        [Parameter(Mandatory=$false)]
        [hashtable]
        $Body = @{},

        [Parameter()]
        [int]
        $MaxPages = 1,

        [Parameter()]
        [string]
        $Api = 'v4',

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [switch]
        $WhatIf
    )

    if ($SiteUrl) {
        Write-Debug "Attempting to resolve site using $SiteUrl"
        $Site = Get-GitlabConfiguration | Select-Object -ExpandProperty Sites | Where-Object Url -eq $SiteUrl | Select-Object -First 1
    }
    if (-not $Site) {
        Write-Debug "Attempting to resolve site using local git context"
        $Site = Get-GitlabConfiguration | Select-Object -ExpandProperty Sites | Where-Object Url -eq $(Get-LocalGitContext).Site | Select-Object -First 1
   
        if (-not $Site) {
            $Site = Get-DefaultGitlabSite
            Write-Debug "Using default site ($($Site.Url))"
        }
    }
    $GitlabUrl = $Site.Url
    $AccessToken = $Site.AccessToken

    $Headers = @{
        'Accept' = 'application/json'
    }
    if ($AccessToken) {
        $Headers['Authorization'] = "Bearer $AccessToken"
    } else {
        throw "GitlabCli: environment not configured`nSee https://github.com/chris-peterson/pwsh-gitlab#getting-started for details"
    }

    if (-not $GitlabUrl.StartsWith('http')) {
        $GitlabUrl = "https://$GitlabUrl"
    }

    $SerializedQuery = ''
    $Delimiter = '?'
    if($Query.Count -gt 0) {
        foreach($Name in $Query.Keys) {
            $Value = $Query[$Name]
            if ($Value) {
                $SerializedQuery += $Delimiter
                $SerializedQuery += "$Name="
                $SerializedQuery += [System.Net.WebUtility]::UrlEncode($Value)
                $Delimiter = '&'
            }
        }
    }
    $Uri = "$GitlabUrl/api/$Api/$Path$SerializedQuery"

    $RestMethodParams = @{}
    if($MaxPages -gt 1) {
        $RestMethodParams['FollowRelLink'] = $true
        $RestMethodParams['MaximumFollowRelLink'] = $MaxPages
    }
    if ($Body.Count -gt 0) {
        $RestMethodParams.ContentType = 'application/json'
        $RestMethodParams.Body        = $Body | ConvertTo-Json
    }

    if($WhatIf) {
        $SerializedParams = ""
        if($RestMethodParams.Count -gt 0) {
            $SerializedParams = $RestMethodParams.Keys | 
                ForEach-Object {
                    "-$_ `"$($RestMethodParams[$_])`""
                } |
                Join-String -Separator " "
            $SerializedParams += " "
        }
        Write-Host "$HttpMethod $Uri $SerializedParams"
    }
    else {
        $Result = Invoke-RestMethod -Method $HttpMethod -Uri $Uri -Header $Headers @RestMethodParams
        if($MaxPages -gt 1) {
            # Unwrap pagination container
            $Result | ForEach-Object { 
                Write-Output $_
            }
        }
        else {
            Write-Output $Result
        }
    }
}

function Add-AliasedProperty {
    param (
        [PSCustomObject]
        [Parameter(Mandatory=$true, Position = 0)]
        $On,

        [string]
        [Parameter(Mandatory=$true)]
        $From,

        [string]
        [Parameter(Mandatory=$true)]
        $To
    )
    
    if ($null -ne $On.$To -and -NOT (Get-Member -Name $On.$To -InputObject $On)) {
        $On | Add-Member -MemberType NoteProperty -Name $From -Value $On.$To
    }
}

function New-WrapperObject {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $InputObject,

        [Parameter(Position=0,Mandatory=$false)]
        [string]
        $DisplayType
    )
    Begin{}
    Process {
        foreach ($item in $InputObject) {
            $Wrapper = New-Object PSObject
            $item.PSObject.Properties |
                Sort-Object Name |
                ForEach-Object {
                    $Wrapper | Add-Member -MemberType NoteProperty -Name $($_.Name | ConvertTo-PascalCase) -Value $_.Value
                }
            
            # aliases for common property names
            Add-AliasedProperty -On $Wrapper -From 'Url' -To 'WebUrl'
            
            if ($DisplayType) {
                $Wrapper.PSTypeNames.Insert(0, $DisplayType)
                $TypeShortName = $DisplayType.Split('.') | Select-Object -Last 1
                $IdentityPropertyName = $Wrapper.Iid ? 'Iid' : 'Id'
                Add-AliasedProperty -On $Wrapper -From "$($TypeShortName)Id" -To $IdentityPropertyName
            }
            Write-Output $Wrapper
        }
    }
    End{}
}

function Open-InBrowser {
    [CmdletBinding()]
    [Alias('go')]
    param(
        [Parameter(ValueFromPipeline=$True)]
        $Object
    )

    if (-not $Object) {
        # do nothing
    } elseif ($Object -is [string]) {
        Start-Process $Object
    } elseif ($Object.WebUrl -and $Object.WebUrl -is [string]) {
        Start-Process $Object.WebUrl
    }
}

function ValidateGitlabDateFormat {
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [string]
        $DateString
    )
    if($DateString -match "\d\d\d\d-\d\d-\d\d") {
        $true
    } else {
        throw "$DateString is invalid. The date format expected is YYYY-MM-DD"
    }
}
