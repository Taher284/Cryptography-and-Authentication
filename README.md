# Cryptography-and-Authentication

### *Multi-Layer Secure File Transfer System*

**Tools Used:** OpenSSL • GPG • SHA256 • MD5 • bcrypt • Steghide

---

## 📌 Overview

This project demonstrates a **multi-layered security pipeline** combining modern cryptography and steganography tools.
It simulates a secure communication workflow where a confidential message is:

1. Encrypted using **OpenSSL (AES-256-CBC)**
2. Encrypted again using **GPG** (AES-256 symmetric)
3. Hashed using **MD5 + SHA256**
4. Protected with a **bcrypt password hash**
5. Hidden inside an image using **Steghide**
6. Extracted and decrypted back using **reverse operations**

This showcases **confidentiality, integrity, authentication, and covert transmission** — all in one automated pipeline.

---

## 🗂 Folder Structure

```
Folder_name/
│
├── secure_transfer.ps1       ← Automation script
├── cover.jpg                 ← Image used for steganography
│
├── keys/                     ← RSA keys + certificate
├── files/                    ← Secret files
├── out/                      ← All outputs + logs
│     └── output.txt          ← Full execution log
```

---

## ▶️ How to Run the Project

1. Install the following tools on Windows:

   * **OpenSSL**
   * **GPG (Gpg4win)**
   * **Steghide**
   * **PowerShell 5 or 7**
   * **BCrypt.Net** (script auto-installs)

2. Place a `cover.jpg` inside:

```
folder_name (project_name)
```

3. Run PowerShell as Administrator
4. Execute:

```powershell
cd folder_path
.\secure_transfer.ps1
```

5. Results appear inside the `out\` folder
6. Full log is saved at:

```
out\output.txt
```

---

## 🧪 Features Demonstrated

### 🔐 **1. Encryption**

* AES-256-CBC (OpenSSL)
* AES-256 (GPG symmetric)

### 🧩 **2. Hashing**

* MD5 checksum
* SHA256 integrity hash
* bcrypt password hashing

### 🕵️ **3. Steganography**

* Steghide used to embed and extract encrypted data inside an image

### 🛡 **4. Multi-layer Security**

This project proves each tool works together to create a **robust layered defense**.

---

## 📜 Example Workflow Output

Located at:

```
out/output.txt
```

Contains:

* Key generation logs
* Encryption logs
* Hash values
* Steganography logs
* Final verification results

---


