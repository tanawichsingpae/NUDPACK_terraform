# โครงการ Deploy Web Application ด้วย Terraform บน AWS

## ภาพรวมโครงการ

โครงการนี้เป็นการนำแอปพลิเคชันเว็บที่พัฒนาโดยใช้ **Python FastAPI** และ **HTML Frontend** มา deploy บน Cloud โดยใช้ **Terraform (Infrastructure as Code)** เพื่อทำการ Provision Infrastructure และ Deploy ระบบอัตโนมัติบน **AWS EC2**

ระบบจะทำการ

* สร้าง EC2 Instance
* สร้าง Security Group
* สร้าง SSH Key Pair
* Clone Source Code จาก GitHub
* ติดตั้ง Dependencies
* รัน FastAPI Server

ฐานข้อมูลของระบบใช้ **Neon PostgreSQL** ซึ่งเป็นบริการฐานข้อมูลแบบ Cloud

---

# โครงสร้างโปรเจค

```
NUDPACK/
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfstate
│   └── terraform.tfstate.backup
│
├── deploy.sh
└── README.md
```

คำอธิบายไฟล์สำคัญ

* **main.tf**
  ใช้กำหนด Infrastructure ที่ต้องสร้างบน AWS เช่น EC2, Security Group และ Key Pair

* **variables.tf**
  กำหนดตัวแปรที่ใช้ใน Terraform เช่น AWS Region และ Instance Type

* **outputs.tf**
  ใช้แสดงผลลัพธ์หลังจาก Deploy เช่น URL ของ Application

---

# เทคโนโลยีที่ใช้

* Terraform
* AWS EC2
* Python FastAPI
* Uvicorn
* PostgreSQL (Neon Database)
* GitHub

---

# ขั้นตอนการติดตั้งและใช้งาน

## 1. ติดตั้งเครื่องมือที่จำเป็น

ต้องติดตั้งโปรแกรมดังต่อไปนี้ก่อนใช้งาน

* Terraform
* AWS CLI
* Git

ตรวจสอบการติดตั้ง

```
terraform -version
aws --version
git --version
```

---

# 2. Login AWS CLI

ก่อนใช้งาน Terraform ต้อง Login AWS CLI ก่อน

ใช้คำสั่ง

```
aws configure
```

จากนั้นกรอกข้อมูล

```
AWS Access Key ID
AWS Secret Access Key
Region (เช่น ap-southeast-1)
Output format (json)
```

---

# 3. Clone Repository

```
git clone <repository-url>
cd NUDPACK/terraform
```

---

# 4. Initialize Terraform

ใช้คำสั่ง

```
terraform init
```

Terraform จะทำการติดตั้ง Provider และเตรียม Environment สำหรับการทำงาน

---

# 5. ตรวจสอบ Infrastructure Plan

ใช้คำสั่ง

```
terraform plan
```

คำสั่งนี้จะแสดงรายการ Resource ที่ Terraform จะสร้างบน AWS

เช่น

* EC2 Instance
* Security Group
* Key Pair

---

# 6. Deploy Infrastructure และ Application

ใช้คำสั่ง

```
terraform apply
```

เมื่อระบบถามยืนยัน ให้พิมพ์

```
yes
```

Terraform จะทำการ

1. สร้าง EC2 Instance บน AWS
2. สร้าง Security Group
3. Clone Source Code จาก GitHub
4. ติดตั้ง Python และ Dependencies
5. รัน FastAPI Server

หลังจาก Deploy สำเร็จ Terraform จะแสดง URL สำหรับเข้าใช้งานระบบ เช่น

```
app_public_url = http://<EC2_PUBLIC_IP>:8000
```

สามารถเปิด URL นี้ใน Web Browser เพื่อใช้งานระบบได้

---

# 7. ตรวจสอบการทำงานของระบบ

เปิด Web Browser และเข้าไปที่

```
http://<EC2_PUBLIC_IP>:8000
```

ระบบจะทำการเชื่อมต่อกับฐานข้อมูล Neon PostgreSQL และสามารถใช้งานระบบ Login และฟังก์ชันต่าง ๆ ได้

---

# 8. การลบ Infrastructure

หลังจากใช้งานเสร็จ ควรลบ Infrastructure เพื่อป้องกันค่าใช้จ่ายจาก Cloud

ใช้คำสั่ง

```
terraform destroy
```

เมื่อระบบถามยืนยัน ให้พิมพ์

```
yes
```

Terraform จะทำการลบ Resource ทั้งหมดที่สร้างไว้ เช่น

* EC2 Instance
* Security Group
* Key Pair

---

# สรุปการทำงานของระบบ

ขั้นตอนการทำงานของระบบมีดังนี้

```
Terraform
   │
   ▼
AWS EC2 Instance
   │
   ├── Install Python
   ├── Clone GitHub Repository
   ├── Install Dependencies
   └── Run FastAPI Server
            │
            ▼
      Neon PostgreSQL Database
```

ผู้ใช้สามารถเข้าใช้งานระบบผ่าน Web Browser โดยเชื่อมต่อไปยัง EC2 Instance ที่ถูกสร้างโดย Terraform

---

# หมายเหตุ

ก่อนการใช้งาน Terraform จำเป็นต้อง Login AWS CLI ก่อนทุกครั้ง หากยังไม่ได้ตั้งค่า AWS CLI ระบบจะไม่สามารถสร้าง Infrastructure บน AWS ได้
