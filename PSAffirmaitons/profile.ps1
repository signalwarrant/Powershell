# Testing Affirmations
$restContent = Invoke-RestMethod -Uri ""
$randomAffirmation = $restContent | Get-Random -Count 1
$randomAffirmation