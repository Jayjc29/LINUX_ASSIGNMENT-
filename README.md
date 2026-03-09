# Linux System Administration Assignment

## Overview

This repository contains solutions for various **Linux system administration tasks**, including SMTP configuration, user management, custom commands, file permission configuration, file decompression, and creating a system service.

---

# 1. Configure SMTP on Localhost

### Install Postfix

```bash
sudo apt update
sudo apt install postfix mailutils -y
```

During installation choose:

* **Internet Site**
* System mail name: `localhost`

### Verify Service

```bash
sudo systemctl status postfix
```

### Test Mail

```bash
echo "SMTP test mail" | mail -s "Test Mail" user@localhost
```
<img src="screenshots/Screenshot from 2026-03-08 15-36-42.png" width="1000" height="900">
---

# 2. Create a User Without Sudo Access

Create user:

```bash
sudo adduser limiteduser
```

Ensure the user is not part of the sudo group:

```bash
groups limiteduser
```

If required remove from sudo group:

```bash
sudo deluser limiteduser sudo
```

Test:

```bash
su - limiteduser
sudo ls
```

Expected output:

```
limiteduser is not in the sudoers file.
```

---
<img src ="screenshots/Screenshot from 2026-03-08 15-38-24.png" width="1000" height="900">

# 3. Create Custom Command `describe`

Create command script:

```bash
sudo nano /usr/local/bin/describe
```

Add:

```bash
#!/bin/bash
ls
```

Make executable:

```bash
sudo chmod +x /usr/local/bin/describe
```

Usage:

```bash
describe
```

Output:

```
content1 content2
content3 content4
```

This command lists all files and folders in the **current working directory**, and can be executed from anywhere in the system.

---
<img src ="screenshots/Screenshot from 2026-03-08 15-38-59.png" width="1000" height="900">

# 4. Find and Uncompress Research File

Users may store a compressed file named `research` anywhere in the filesystem.

### Find File

```bash
find / -type f -name "research.*" 2>/dev/null
```

### Identify Compression Type

```bash
file research.*
```

### Decompress Based on Type

Gzip:

```bash
gunzip research.gz
```

Bzip2:

```bash
bunzip2 research.bz2
```

Zip:

```bash
unzip research.zip
```

---
<img src ="screenshots/Screenshot from 2026-03-08 15-40-09.png" width="1000" height="900">

# 5. Restrict Permissions on Newly Created Files

The system is configured so that **any file created by users has no permissions**.

This is done using **umask**, without using `chmod`.

Edit profile:

```bash
sudo nano /etc/profile
```

Add:

```bash
umask 777
```

Now when a file is created:

```bash
touch testfile
```

Permissions become:

```
---------- 1 user user 0 testfile
```

No read, write, or execute permissions are allowed.

---
<img src ="screenshots/Screenshot from 2026-03-08 15-40-41.png" width="1000" height="900">

# 6. Create System Service `showtime`

This service writes the **current time every minute** to a file in the user's home directory.

### Create Script

```bash
sudo nano /usr/local/bin/showtime.sh
```

Add:

```bash
#!/bin/bash

while true
do
date >> /home/$SUDO_USER/time.txt
sleep 60
done
```

Make executable:

```bash
sudo chmod +x /usr/local/bin/showtime.sh
```

---

### Create Service File

```bash
sudo nano /etc/systemd/system/showtime.service
```

Add:

```
[Unit]
Description=Show current time every minute

[Service]
ExecStart=/usr/local/bin/showtime.sh
Restart=always

[Install]
WantedBy=multi-user.target
```

Reload systemd:

```bash
sudo systemctl daemon-reload
```

Enable service:

```bash
sudo systemctl enable showtime
```

---

### Service Commands

Start service:

```bash
sudo systemctl start showtime
```

Stop service:

```bash
sudo systemctl stop showtime
```

Check status:

```bash
sudo systemctl status showtime
```

Output file:

```
~/time.txt
```

The file will contain timestamps written every minute.

---
<img src ="screenshots/Screenshot from 2026-03-08 15-44-49.png" width="1000" height="900">

# Repository Structure

```
linux-system-admin-assignment
│
├── README.md
├── describe
├── showtime.sh
├── showtime.service
└── screenshots
```

---
