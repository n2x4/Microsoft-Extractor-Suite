# This contains functions to display or collect the inbox and transport rules.

$date = [datetime]::Now.ToString('yyyyMMddHHmmss') 
$curDir = Get-Location
$tRulesout = "\Output\Rules\"+$date+"_"+"TransportRules.csv"
$mRulesout = "\Output\Rules\"+$date+"_"+"MailboxRules.csv"
$outputDirectory = Join-Path $curDir $tRulesout
$outputDirectoryM = Join-Path $curDir $mRulesout

function Show-TransportRules
{
<#
    .SYNOPSIS
    Shows the transport rules in your organization.

    .DESCRIPTION
    Shows the transport rules in your organization.
    
    .Example
    Show-TransportRules
#>
	$transportRules = Get-TransportRule | Select-Object -Property Name,Description,CreatedBy,WhenChanged,State
	
	if ($null -ne $transportRules) {
		write-LogFile -Message "[INFO] Checking all TransportRules"
		foreach ($rule in $transportRules) {
			write-LogFile -Message "[INFO] Found a TransportRule" -Color "Green"
			write-LogFile -Message "Rule Name $($rule.name)" -Color "Yellow"
			write-LogFile -Message "Rule CreatedBy: $($rule.CreatedBy)" -Color "Yellow"
			write-LogFile -Message "When Changed: $($rule.WhenChanged)" -Color "Yellow"
			write-LogFile -Message "Rule State: $($rule.State)" -Color "Yellow"
			write-LogFile -Message "Description: $($rule.Description)" -Color "Yellow"
		}
	}
}

function Get-TransportRules
{
<#
    .SYNOPSIS
    Collects all transport rules in your organization.

    .DESCRIPTION
    Collects all transport rules in your organization.
	The output will be written to a CSV file called "TransportRules.csv".
    
    .Example
    Get-TransportRules
#>
	$outputDir = "Output\Rules"
	if (!(test-path $outputDir)) {
		write-LogFile -Message "[INFO] Creating the following directory: $outputDir"
		New-Item -ItemType Directory -Force -Name $outputDir | Out-Null
	}
		
	$transportRules = Get-TransportRule | Select-Object -Property Name,Description,CreatedBy,WhenChanged,State
	
	if ($null -ne $transportRules) {
		$transportRules | export-csv -NoTypeInformation $outputDirectory
		write-LogFile -Message "[INFO] Transport rules are collected and writen to: $outputDirectory" -Color "Green"
	}
}

function Show-MailboxRules
{
<#
    .SYNOPSIS
    Shows the mailbox rules in your organization.

    .DESCRIPTION
    Shows the mailbox rules in your organization.
	
	.Parameter UserIds
    UserIds is the Identity parameter specifies the Inbox rule that you want to view.
    
    .Example
    Show-MailboxRules -UserIds "HR@invictus-ir.com,Test@Invictus-ir.com"
#>
	[CmdletBinding()]
	param(
		[string]$UserIds
	)
		
	$amountofRules = 0
	if ($UserIds -eq "") {		
		Get-mailbox -resultsize unlimited  |
		ForEach-Object {
			write-LogFile -Message "[INFO] Checking $($_.alias)..."
			
			$inboxrule = Get-inboxrule -Mailbox $_.alias  
			if ($inboxrule) {
				write-LogFile -Message "[INFO] Found InboxRule(s) for: $($_.alias)..." -Color "Green"
				foreach($rule in $inboxrule){
					$amountofRules = $amountofRules + 1
					write-LogFile -Message "Username: $($_.alias)" -Color "Yellow"
					write-LogFile -Message "RuleName: $($rule.name)" -Color "Yellow"
					write-LogFile -Message "RuleEnabled: $($rule.Enabled)" -Color "Yellow"
					write-LogFile -Message "CopytoFolder: $($rule.CopyToFolder)" -Color "Yellow"
					write-LogFile -Message "MovetoFolder: $($rule.MoveToFolder)" -Color "Yellow"
					write-LogFile -Message "RedirectTo $($rule.RedirectTo)" -Color "Yellow"
					write-LogFile -Message "ForwardTo: $($rule.ForwardTo)" -Color "Yellow"
					write-LogFile -Message "TextDescription: $($rule.Description)" -Color "Yellow"
				}
			}
		}
	}

	else {	
		if ($UserIds -match ",") {
			$UserIds.Split(",") | Foreach {
				$user = $_
				Write-Output ('[INFO] Checking {0}...' -f $user)
				
				$inboxrule = get-inboxrule -Mailbox $user 
				if ($inboxrule) {
					write-LogFile -Message "[INFO] Found InboxRule(s) for: $UserIds..." -Color "Green"
					foreach($rule in $inboxrule){
						$amountofRules = $amountofRules + 1
						write-LogFile -Message "Username: $user" -Color "Yellow"
						write-LogFile -Message "RuleName: $($rule.name)" -Color "Yellow"
						write-LogFile -Message "RuleEnabled: $($rule.Enabled)" -Color "Yellow"
						write-LogFile -Message "CopytoFolder: $($rule.CopyToFolder)" -Color "Yellow"
						write-LogFile -Message "MovetoFolder: $($rule.MoveToFolder)" -Color "Yellow"
						write-LogFile -Message "RedirectTo $($rule.RedirectTo)" -Color "Yellow"
						write-LogFile -Message "ForwardTo: $($rule.ForwardTo)" -Color "Yellow"
						write-LogFile -Message "TextDescription: $($rule.Description)" -Color "Yellow"
					}
				}
			}
		}
				
		else {
			Write-Output ('[INFO] Checking {0}...' -f $UserIds)
			$inboxrule = get-inboxrule -Mailbox $UserIds 
			if ($inboxrule) {
				write-LogFile -Message "[INFO] Found InboxRule(s) for: $UserIds..." -Color "Green"
				foreach($rule in $inboxrule){
					$amountofRules = $amountofRules + 1
					write-LogFile -Message "Username: $UserIds" -Color "Yellow"
					write-LogFile -Message "RuleName: $($rule.name)" -Color "Yellow"
					write-LogFile -Message "RuleEnabled: $($rule.Enabled)" -Color "Yellow"
					write-LogFile -Message "CopytoFolder: $($rule.CopyToFolder)" -Color "Yellow"
					write-LogFile -Message "MovetoFolder: $($rule.MoveToFolder)" -Color "Yellow"
					write-LogFile -Message "RedirectTo $($rule.RedirectTo)" -Color "Yellow"
					write-LogFile -Message "ForwardTo: $($rule.ForwardTo)" -Color "Yellow"
					write-LogFile -Message "TextDescription: $($rule.Description)" -Color "Yellow"
				}
			}
		}
	}
		
	write-LogFile -Message "[INFO] A total of $amountofRules InboxRules found" -Color "Green"
}

function Get-MailboxRules
{
<#
    .SYNOPSIS
    Collects all the mailbox rules in your organization.

    .DESCRIPTION
    Collects all the mailbox rules in your organization.
	The output will be written to a CSV file called "InboxRules.csv".
	
	.Parameter UserIds
    UserIds is the Identity parameter specifies the Inbox rule that you want to view.
    
    .Example
	Get-MailboxRules -UserIds Test@Invictus-ir.com
    Get-MailboxRules -UserIds "HR@invictus-ir.com,Test@Invictus-ir.com"
#>
	[CmdletBinding()]
	param(
		[string]$UserIds
	)
	
	$RuleList = @()
	$outputdir = "Output\Rules"	
	if (!(test-path $outputdir)) {
		write-LogFile -Message "[INFO] Creating the following directory: $outputDir"
		New-Item -ItemType Directory -Force -Name $outputdir | Out-Null
	}
	
	$amountofRules = 0
	if ($UserIds -eq "") {		
		$totalRules = 0
		Get-mailbox -resultsize unlimited  |
		ForEach-Object {
			Write-Output ('[INFO] Checking {0}...' -f $_.alias)
			
			$inboxrule = Get-inboxrule -Mailbox $_.alias  
			if ($inboxrule) {
				$amountofRules = 0
				foreach ($rule in $inboxrule) {
					$tempval = [pscustomobject]@{
						UserName = $_.alias
						RuleName = $rule.name           
						RuleEnabled = $rule.Enabled
						CopytoFolder = $rule.CopyToFolder
						MovetoFolder = $rule.MoveToFolder
						RedirectTo = $rule.RedirectTo
						ForwardTo = $rule.ForwardTo
						TextDescription = $rule.Description
                     }

					$RuleList += $tempval
					$amountofRules = $amountofRules + 1
					$totalRules = $totalRules + 1
					
				}

				$RuleList | export-CSV $outputDirectoryM -Append -NoTypeInformation
				write-LogFile -Message "[INFO] Found $amountofRules InboxRule(s) for: $($_.alias)..." -Color "Yellow"
				write-LogFile -Message "[INFO] Collecting $amountofRules InboxRule(s) for: $($_.alias)..." -Color "Yellow"
			}
		} 	
	}
	
	else {	
		if ($UserIds -match ",") {
			$UserIds.Split(",") | Foreach {
				$User = $_
	
				Write-Output ('[INFO] Checking {0}...' -f $User)
				$inboxrule = get-inboxrule -Mailbox $User
				if ($inboxrule) {
					$amountofRules = 0
					foreach ($rule in $inboxrule) {
						$tempval = [pscustomobject]@{
							UserName = $User
							RuleName = $rule.name           
							RuleEnabled = $rule.Enabled
							CopytoFolder = $rule.CopyToFolder
							MovetoFolder = $rule.MoveToFolder
							RedirectTo = $rule.RedirectTo
							ForwardTo = $rule.ForwardTo
							TextDescription = $rule.Description
						}

						$RuleList += $tempval
						$amountofRules = $amountofRules + 1
						$totalRules = $totalRules + 1
					}
					
					$RuleList | export-CSV $outputDirectoryM -Append -NoTypeInformation
					write-LogFile -Message "[INFO] Found $amountofRules InboxRule(s) for: $User..." -Color "Yellow"
					write-LogFile -Message "[INFO] Collecting $amountofRules InboxRule(s) for: $User..." -Color "Yellow"
				}
			}
		}
		else {
			Write-Output ('[INFO] Checking {0}...' -f $UserIds)
			$inboxrule = get-inboxrule -Mailbox $UserIds 
			if ($inboxrule) {
				write-host ('[INFO] Found InboxRule(s) for: {0}...' -f $UserIds) -ForegroundColor Yellow
				foreach($rule in $inboxrule){
					$amountofRules = $amountofRules + 1
					$tempval = [pscustomobject]@{
							UserName = $UserIds
							RuleName = $rule.name           
							RuleEnabled = $rule.Enabled
							CopytoFolder = $rule.CopyToFolder
							MovetoFolder = $rule.MoveToFolder
							RedirectTo = $rule.RedirectTo
							ForwardTo = $rule.ForwardTo
							TextDescription = $rule.Description
						}

						$RuleList += $tempval
						$totalRules = $totalRules + 1
					}
					
					$RuleList | export-CSV $outputDirectoryM -Append -NoTypeInformation
					write-LogFile -Message "[INFO] Collecting $amountofRules InboxRule(s) for: $UserIds..." -Color "Yellow"
				
			}
		}
	}

	write-LogFile -Message "[INFO] A total of $totalRules InboxRules found" -Color "Green"
}
