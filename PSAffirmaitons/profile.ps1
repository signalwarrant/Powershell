# Testing Affirmations
$restContent = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/signalwarrant/Powershell/master/PSAffirmaitons/affirmations.json"
$restContent | Get-Random -Count 1