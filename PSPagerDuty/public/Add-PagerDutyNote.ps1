function Add-PagerDutyNote {
    <#
        .SYNOPSIS
            Add a new PagerDuty note for the specified incident from the v2 REST API
        .DESCRIPTION
            Add a new PagerDuty note for the specified incident from the v2 REST API
    
            See PagerDuty documentation for more information:
            https://developer.pagerduty.com/api-reference/b3A6Mjc0ODE1MA-create-a-note-on-an-incident
        .PARAMETER Id
            The Id of the incident (Accept pipeline input)
        .PARAMETER Content
            The note content
        .PARAMETER From
            The email address of a valid user associated with the account making the request
        .PARAMETER Proxy
            Uses a proxy server for the request, rather than connecting directly to the internet resource. Enter the Uniform Resource Identifier (URI) of a network proxy server
        .PARAMETER Token
            PagerDuty API token
        .EXAMPLE
            Add-PagerDutyNote -Id Q3O56I5GV3A7CU -Token REDACTED -From 'name@company.com' -Content 'Note content' -Proxy "http://myproxy.com:3128"
    #>
    [cmdletbinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Id,
        [string]$Content,
        [string]$From,
        [string]$Token = $Script:PSPagerDutyConfig.Token,
        [ValidateScript({if ([System.Uri]::IsWellFormedUriString($_, [System.UriKind]::Absolute)) {
            $true
        } else {
            throw "$_ is not a valid uri format."
        }})]
        [System.Uri]$Proxy=$Script:PSPagerDutyConfig.Proxy
    )
    $Headers = @{
        "Accept" = "application/vnd.pagerduty+json;version=2"
        "Authorization" = "Token token=$Token"
        "Content-Type" = "application/json"
        "From" = "$From"
    }
    $uri = "https://api.pagerduty.com/incidents/${Id}/notes"
    
    $Payload = @{
        note = @{
            content = $Content
        }
    }

    $json = $Payload | ConvertTo-Json -Compress

    $RestMethodParams = @{ 
        Method      = 'Post';
        Uri         = $Uri;
        Headers     = $Headers;
        Body        = $json;
    }
    if ($Proxy) {
        $RestMethodParams.Add("Proxy", $Proxy)
    }
    
    Invoke-RestMethod @RestMethodParams
    }
