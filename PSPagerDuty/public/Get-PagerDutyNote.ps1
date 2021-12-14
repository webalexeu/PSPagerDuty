function Get-PagerDutyNote {
    <#
        .SYNOPSIS
            Get PagerDuty notes for the specified incident from the v2 REST API
        .DESCRIPTION
            Get PagerDuty notes for the specified incident from the v2 REST API

            See PagerDuty documentation for more information:
            https://developer.pagerduty.com/api-reference/b3A6Mjc0ODE0OQ-list-notes-for-an-incident
        .PARAMETER Id
            The Id of the incident (Accept pipeline input)
        .PARAMETER Proxy
            Uses a proxy server for the request, rather than connecting directly to the internet resource. Enter the Uniform Resource Identifier (URI) of a network proxy server
        .PARAMETER Token
            PagerDuty API token
        .EXAMPLE
            Get-PagerDutyNote -Id Q3O56I5GV3A7CU -Token REDACTED -Proxy "http://myproxy.com:3128"
    #>
    [cmdletbinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Id,
        [string]$Token = $Script:PSPagerDutyConfig.Token,
        [ValidateScript({if ([System.Uri]::IsWellFormedUriString($_, [System.UriKind]::Absolute)) {
            $true
        } else {
            throw "$_ is not a valid uri format."
        }})]
        [System.Uri]$Proxy=$Script:PSPagerDutyConfig.Proxy
    )
    Begin {
    }

    Process {
        $Headers = @{
            "Accept" = "application/vnd.pagerduty+json;version=2"
            "Authorization" = "Token token=$Token"
            "Content-Type" = "application/json"
        }
        $uri = "https://api.pagerduty.com/incidents/${Id}/notes"

        $RestMethodParams = @{
            Method      = 'Get';
            Uri         = $Uri;
            Headers     = $Headers;
        }
        if ($Proxy) {
            $RestMethodParams.Add("Proxy", $Proxy)
        }

        $Response = $null
        $Response=Invoke-RestMethod @RestMethodParams
        ConvertFrom-PagerDutyData -InputObject $Response.notes
    }

    End {
    }
}
