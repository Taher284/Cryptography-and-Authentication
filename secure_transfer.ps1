# ===================================================================
# ICS Mini Project: Multi-Layer Secure Transfer System
# Tools: OpenSSL, GPG, SHA256, MD5, bcrypt, Steghide
# Author: Taher Piplodwala
# ===================================================================

# ------------------------
# STEP 0: AUTO-INSTALL BCRYPT IF NOT INSTALLED
# ------------------------
try {
    Add-Type -AssemblyName "BCrypt.Net-Next" -ErrorAction Stop
} catch {
    Write-Host "bcrypt library not found. Installing..." -ForegroundColor Yellow
    Install-Package BCrypt.Net-Next -Scope CurrentUser -Source "https://www.nuget.org/api/v2" -Force
    Add-Type -AssemblyName "BCrypt.Net-Next"
    Write-Host "bcrypt installed successfully!" -ForegroundColor Green
}

# ------------------------
# STEP 1: SETUP DIRECTORIES
# ------------------------
$base = "C:\Users\HP\Desktop\ICSMiniproj"
$keys = "$base\keys"
$files = "$base\files"
$out   = "$base\out"
$log   = "$out\output.txt"

New-Item -ItemType Directory -Force -Path $keys, $files, $out | Out-Null

# Logging function
function Log {
    param([string]$msg, [string]$color = "White")
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$ts] $msg"
    Write-Host $line -ForegroundColor $color
    Add-Content -Path $log -Value $line
}

# Initialize log
"====================================================================" | Out-File $log
" ICS Mini Project: Multi-Layer Secure Transfer System" | Add-Content $log
"====================================================================" | Add-Content $log
"Start Time: $(Get-Date)`n" | Add-Content $log

# ------------------------
# STEP 2: GENERATE OPENSSL KEYS + CERTIFICATE
# ------------------------
Log "==== STAGE 1: KEY GENERATION (OpenSSL) ====" "Yellow"

$privateKey = "$keys\private.pem"
$publicKey  = "$keys\public.pem"
$certFile   = "$keys\certificate.pem"

if (!(Test-Path $privateKey)) {
    openssl genrsa -out $privateKey 2048
    openssl rsa -in $privateKey -pubout -out $publicKey
    openssl req -x509 -new -key $privateKey -days 365 -out $certFile -subj "/CN=ICSMiniproj"
    Log "✔ RSA keys + Certificate generated." "Green"
} else {
    Log "✔ Keys already exist, skipping." "Green"
}

# ------------------------
# STEP 3: CREATE SECRET FILE
# ------------------------
Log "`n==== STAGE 2: SECRET FILE PREPARATION ====" "Yellow"

$secret = "$files\secret.txt"
if (!(Test-Path $secret)) {
    "This is a confidential message for the ICS mini project." | Out-File $secret
    Log "✔ Created secret.txt" "Green"
} else {
    Log "✔ Found secret.txt" "Green"
}

# ------------------------
# STEP 4: OPENSSL AES ENCRYPTION
# ------------------------
Log "`n==== STAGE 3: ENCRYPTION (OpenSSL) ====" "Yellow"

$encFile = "$out\secret.txt.enc"
openssl enc -aes-256-cbc -pbkdf2 -in $secret -out $encFile -k "EncryptKey123"

Log "✔ OpenSSL encryption complete → secret.txt.enc" "Green"

# ------------------------
# STEP 5: GPG ENCRYPTION
# ------------------------
Log "`n==== STAGE 4: ENCRYPTION (GPG) ====" "Yellow"

$gpgFile = "$out\secret.txt.gpg"
gpg --batch --yes -c --passphrase "GPG12345" -o $gpgFile $encFile

Log "✔ GPG encryption complete → secret.txt.gpg" "Green"

# ------------------------
# STEP 6: HASHING (MD5, SHA256, bcrypt)
# ------------------------
Log "`n==== STAGE 5: HASHING (MD5, SHA256, bcrypt) ====" "Yellow"

$md5 = (Get-FileHash -Path $encFile -Algorithm MD5).Hash
$sha = (Get-FileHash -Path $encFile -Algorithm SHA256).Hash
$bcrypt = [BCrypt.Net.BCrypt]::HashPassword("EncryptKey123")

Log "✔ MD5(secret.enc): $md5" "Green"
Log "✔ SHA256(secret.enc): $sha" "Green"
Log "✔ bcrypt(password): $bcrypt" "Green"

# ------------------------
# STEP 7: STEGHIDE EMBEDDING
# ------------------------
Log "`n==== STAGE 6: STEGANOGRAPHY (Steghide) ====" "Yellow"

$cover  = "$base\cover.jpg"
$stego  = "$out\stego.jpg"
$extractFile = "$out\extracted_secret.txt.gpg"

if (!(Test-Path $cover)) {
    Log "❌ cover.jpg missing! Please add an image." "Red"
    exit
}

steghide embed -cf $cover -ef $gpgFile -sf $stego -p "StegPass" | Out-Null
Log "✔ Embedded encrypted file → stego.jpg" "Green"

steghide extract -sf $stego -xf $extractFile -p "StegPass" | Out-Null
Log "✔ Extracted encrypted file → extracted_secret.txt.gpg" "Green"

# ------------------------
# STEP 8: DECRYPTION (GPG + OpenSSL)
# ------------------------
Log "`n==== STAGE 7: DECRYPTION ====" "Yellow"

$tempEnc = "$out\temp.enc"
$final   = "$out\decrypted_secret.txt"

gpg --batch --yes -o $tempEnc -d --passphrase "GPG12345" $extractFile | Out-Null
openssl enc -d -aes-256-cbc -pbkdf2 -in $tempEnc -out $final -k "EncryptKey123" | Out-Null

Log "✔ Final decrypted file → decrypted_secret.txt" "Green"

# ------------------------
# STEP 9: INTEGRITY VERIFICATION
# ------------------------
Log "`n==== STAGE 8: INTEGRITY VERIFICATION ====" "Yellow"

$newSha = (Get-FileHash -Path $tempEnc -Algorithm SHA256).Hash

if ($newSha -eq $sha) {
    Log "✔ SHA256 integrity check PASSED." "Green"
} else {
    Log "❌ SHA256 integrity FAILED." "Red"
}

# ------------------------
# SUMMARY
# ------------------------
Log "`n==== PROCESS COMPLETED SUCCESSFULLY ====" "Cyan"
Write-Host "`n✔ Check 'out\output.txt' for detailed logs." -ForegroundColor Magenta
