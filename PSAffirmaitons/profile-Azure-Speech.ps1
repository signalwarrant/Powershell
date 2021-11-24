$apikey = Get-Content -Path "C:\Users\Dave\Documents\key.txt"
$uri = "https://raw.githubusercontent.com/signalwarrant/Powershell/master/PSAffirmaitons/affirmations.json"
$mp3File = 'C:\Users\Dave\Documents\affirm.mp3'

# Grab the Azure Cognitive services bearer token
Get-SpeechToken -Key $apikey -Region 'eastus'

# Testing Affirmations
$restContent = Invoke-RestMethod -Uri $uri 
$text = $restContent | Get-Random -Count 1

# Convert the text to speech
Convert-TextToSpeech -Voice en-US-JennyNeural -Text $text -Path $mp3File

# Play the mp3
Add-Type -AssemblyName presentationCore
$mediaPlayer = New-Object system.windows.media.mediaplayer
$mediaPlayer.open($mp3File)
$mediaPlayer.Play()

$text