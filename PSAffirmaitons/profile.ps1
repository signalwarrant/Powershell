$uri = "https://raw.githubusercontent.com/signalwarrant/Powershell/master/PSAffirmaitons/affirmations.json" 

# Testing Affirmations
$restContent = Invoke-RestMethod -Uri $uri 
$restContent | Get-Random -Count 1