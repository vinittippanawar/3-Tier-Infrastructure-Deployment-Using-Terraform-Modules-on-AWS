# 🚀 3-Tier Infrastructure Deployment Using Terraform Modules on AWS

<p align="center">
  <img src="https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge&logo=amazonaws" />
  <img src="https://img.shields.io/badge/Terraform-IaC-623CE4?style=for-the-badge&logo=terraform" />
  <img src="https://img.shields.io/badge/EC2-Compute-FF9900?style=for-the-badge&logo=amazonaws" />
  <img src="https://img.shields.io/badge/RDS-MySQL-527FFF?style=for-the-badge&logo=amazonrds" />
  <img src="https://img.shields.io/badge/Nginx-Web_Server-009639?style=for-the-badge&logo=nginx" />
  <img src="https://img.shields.io/badge/Apache-App_Server-D22128?style=for-the-badge&logo=apache" />
  <img src="https://img.shields.io/badge/PHP-Backend-777BB4?style=for-the-badge&logo=php" />
  <img src="https://img.shields.io/badge/MySQL-Database-4479A1?style=for-the-badge&logo=mysql" />
  <img src="https://img.shields.io/badge/VS_Code-Editor-007ACC?style=for-the-badge&logo=visualstudiocode" />
</p>

---

## 📌 Project Overview

This project demonstrates a **production-style 3-tier web application architecture on AWS** using **Terraform modules**.

The goal of this project is to move from **manual infrastructure provisioning** to **Infrastructure as Code (IaC)**, making the environment:

- Reusable
- Automated
- Scalable
- Easier to maintain
- Less error-prone

The deployed system includes:

- **Web Tier** → Nginx server hosted on EC2 in a **public subnet**
- **Application Tier** → Apache + PHP server hosted on EC2 in a **private subnet**
- **Database Tier** → Amazon RDS MySQL hosted in **private subnets**

This project follows a **modular Terraform approach**, where infrastructure is split into reusable modules for:

- VPC
- EC2
- RDS

---

## 🎯 Objective

The main objective of this project is to design and deploy a **3-tier architecture** on AWS using Terraform modules and automation scripts.

### Key goals:
- Automate AWS infrastructure provisioning using Terraform
- Create a custom VPC with secure networking
- Deploy web, application, and database tiers
- Use modular and reusable Terraform code
- Reduce manual configuration errors
- Demonstrate real-world DevOps and IaC practices

---

## 🏗️ Architecture

### High-Level Architecture

```text
User Browser
     │
     ▼
Web Tier (Nginx - Public EC2)
     │
     ▼
Application Tier (Apache + PHP - Private EC2)
     │
     ▼
Database Tier (Amazon RDS MySQL - Private)
```
---


## 🏗️ Architecture Diagram



---

## 🚀 Deployment Steps

Follow the steps below to deploy the complete 3-tier architecture.

---

### ⭐ Step 1: Setup Environment

Install required tools:

- Terraform
- AWS CLI
- Git
- VS Code
---

Verify installation:

```bash
terraform -version
aws --version
git --version
```

# ⭐ Step 2: Configure AWS CLI

Run:
```
aws configure
```
Enter:
```
AWS Access Key
AWS Secret Key
Region → ap-south-1
Output → json
```

Verify:
```
aws sts get-caller-identity
```
# ⭐ Step 3: Create Project Structure

Create project folder:
```
3-tier-terraform-project/
```
Inside it, create:

- modules/
- userdata/
- screenshots/

Also create main files:

- main.tf
- variables.tf
- provider.tf
- terraform.tfvars
- outputs.tf
---

# ⭐ Step 4: Build Terraform Modules

Create 3 reusable modules:

🔹 VPC Module
- VPC
- Subnets
- Internet Gateway
- NAT Gateway
- Route Tables

🔹 EC2 Module
- Used for Web Tier
- Used for App Tier

🔹 RDS Module
- MySQL Database
- DB Subnet Group

Each module contains:

- main.tf
- variables.tf
- outputs.tf
  
# ⭐ Step 5: Configure Root Terraform Code

In main.tf:

- Call VPC module
- Create Security Groups
- Launch App EC2 (Private)
- Launch Web EC2 (Public)
- Create RDS Database

Also:

- Fetch latest Ubuntu AMI dynamically
- Connect all tiers properly

  ---
# ⭐ Step 6: Add Automation Scripts

Inside userdata/ folder:

📌 web.sh
- Install Nginx
- Start Nginx
- Deploy registration form
  
📌 app.sh
- Install Apache
- Install PHP
- Create submit.php
  
# ⭐ Step 7: Configure Variables

- Edit terraform.tfvars:
```
key_name    = "dock"
db_password = "Pass12345"
```
---
# ⭐ Step 8: Initialize Terraform

- terraform init

---
# ⭐ Step 9: Validate Configuration

- terraform validate
---

# ⭐ Step 10: Preview Deployment

- terraform plan

  ---
#  ⭐ Step 11: Deploy Infrastructure

- terraform apply --auto-aprove
---

# ⭐ Step 12: Get Outputs

- Terraform outputs:

  - web_public_ip
  - app_private_ip
  - rds_endpoint
 
---

> ⚙️ Post-Deployment Configuration
 
# ⭐ Step 13: Connect to Web EC2

- After Terraform deployment, use the **Web Tier EC2 Public IP** to connect via SSH from your local machine.
```
ssh -i dock.pem ubuntu@<web_public_ip>
```
# ⭐ Step 14: Access App EC2 via Web (Jump Host)

>Since the Application Tier EC2 is deployed in a private subnet, it cannot be accessed directly from your local machine.
>So, first copy the .pem file to Web EC2, then SSH into App EC2 from there.

🔹 Step 14.1: Copy Key to Web EC2 (run from local system)
```
scp -i dock.pem dock.pem ubuntu@<web_public_ip>:/home/ubuntu/
```

📌 Example:
```
scp -i dock.pem dock.pem ubuntu@13.127.198.62:/home/ubuntu/
```
🔹 Step 14.2: Inside Web EC2, give permission to key
```
chmod 400 dock.pem
```

🔹 Step 14.3: SSH into App EC2 from Web EC2
```
ssh -i dock.pem ubuntu@<app_private_ip>
```

📌 Example:
```
ssh -i dock.pem ubuntu@10.0.3.87
```

✔ Now you are inside the App Tier EC2

---

# ⭐ Step 15: Update Database Connection

- Inside App EC2, open the PHP application file:
```
sudo nano /var/www/html/submit.php
```

- Find the database host line:
```
$host = "REPLACE_RDS_ENDPOINT";
```
- Replace it with the actual Terraform output value:
 ```
 $host = "three-tier-mysql-db.c3w2u4oek8lv.ap-south-1.rds.amazonaws.com";
 ```
- Also verify that the password is correct:
```
$pass = "Pass12345";
```

📌 This step allows the Application Tier to connect to the Amazon RDS MySQL database.

---
# ⭐ Step 16: Create Database Table

- Now, from inside App EC2, connect to the MySQL RDS database:

```
mysql -h <rds_endpoint> -u admin -p
```
📌 Example:
```
mysql -h three-tier-mysql-db.c3w2u4oek8lv.ap-south-1.rds.amazonaws.com -u admin -p
```
Enter password:
```
Pass12345
```
- Once inside MySQL (mysql> prompt), run:
```
use userdb;
```
- then create table 
```
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100),
  phone VARCHAR(20)
);
```
✔ This creates the users table used to store registration form data.

---

# ⭐ Step 17: Fix Request Routing

- Configure communication between Web → App
- Ensure form submission reaches App Tier
- 
---

🧪 Testing the Application

---
# ⭐ Step 18: Open Application
```
http://<web_public_ip>
```
- Expected:

  - Registration form should open successfully

# ⭐ Step 19: Submit Form

Enter:

- Name
- Email
- Phone

 ✔ Click Register

# ⭐ Step 20: Verify Output

Expected:
```
Registration Successful!
```

# ⭐ Step 21: Verify Database

- To verify that data is stored successfully, connect again to MySQL RDS from App EC2:

```
mysql -h <rds_endpoint> -u admin -p
```
Then Run :
```
use userdb;
select * from users;
```
- Expected:

- The submitted user data should appear in the table.
---

✅ Final Result

- Web Tier → Working
- App Tier → Processing requests
- Database → Storing data

✔ Complete 3-Tier Architecture Working Successfully

---
**📹 DEMO VIDEO**


https://github.com/user-attachments/assets/0944af0d-c8eb-4e5a-9321-60d6e253bfca

---

