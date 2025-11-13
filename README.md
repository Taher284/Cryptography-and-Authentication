# Cryptography-and-Authentication
Multi-Layer Secure File Transfer System
Tools Used: OpenSSL • GPG • SHA256 • MD5 • bcrypt • Steghide
# 📌 Overview

This project demonstrates a multi-layered security pipeline combining modern cryptography and steganography tools.
It simulates a secure communication workflow where a confidential message is:

Encrypted using OpenSSL (AES-256-CBC)

Encrypted again using GPG (AES-256 symmetric)

Hashed using MD5 + SHA256

Protected with a bcrypt password hash

Hidden inside an image using Steghide

Extracted and decrypted back using reverse operations

This showcases confidentiality, integrity, authentication, and covert transmission — all in one automated pipeline.

# ▶️ How to Run the Project

Install the following tools on Windows:

OpenSSL

GPG (Gpg4win)

Steghide

PowerShell 5 or 7

BCrypt.Net (script auto-installs)

Place a cover.jpg inside:

"folder created (eg: project_file)"


Run PowerShell as Administrator

Execute:

cd (folder path)
.\secure_transfer.ps1


Results appear inside the out\ folder

Full log is saved at:

out\output.txt

# 🧪 Features Demonstrated
🔐 1. Encryption

AES-256-CBC (OpenSSL)

AES-256 (GPG symmetric)

🧩 2. Hashing

MD5 checksum

SHA256 integrity hash

bcrypt password hashing

🕵️ 3. Steganography

Steghide used to embed and extract encrypted data inside an image

🛡 4. Multi-layer Security

This project proves each tool works together to create a robust layered defense.

# 🗂 Folder Structure
FolderName/
│
├── secure_transfer.ps1       ← Automation script
├── cover.jpg                 ← Image used for steganography
│
├── keys/                     ← RSA keys + certificate
├── files/                    ← Secret files
├── out/                      ← All outputs + logs
│     └── output.txt          ← Full execution log
