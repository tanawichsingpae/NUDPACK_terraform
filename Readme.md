# การ Deploy ระบบ NUDPACK ด้วย Terraform

โปรเจคนี้เป็นการใช้ **Terraform (Infrastructure as Code)** เพื่อทำการ Provision Infrastructure บน AWS และ Deploy ระบบ **NUDPACK – ระบบจัดการพัสดุภายในองค์กร**

หลังจากทำการ Deploy สำเร็จ ผู้ใช้สามารถเข้าใช้งานระบบผ่าน Web Browser ได้

---

# โครงสร้างโปรเจค

Repository นี้ประกอบด้วย

* ไฟล์ Terraform (`*.tf`) สำหรับสร้าง Infrastructure
* การ Deploy Web Application จาก GitHub Repository

Web Application Repository

```
https://github.com/tanawichsingpae/NUDPACKtest.git
```

---

# สิ่งที่ต้องมีก่อนเริ่มใช้งาน

ก่อนใช้งานต้องติดตั้งเครื่องมือดังนี้

* Terraform
* AWS CLI
* Git

ตรวจสอบการติดตั้ง

```
terraform -v
aws --version
git --version
```

---

# ขั้นตอนที่ 1 : Login เข้า AWS CLI

ก่อนใช้งาน Terraform ต้องทำการ Login เข้า AWS CLI ก่อน

ใช้คำสั่ง

```
aws configure
```

จากนั้นกรอกข้อมูล

```
AWS Access Key ID
AWS Secret Access Key
Default region name
Default output format
```

ตัวอย่าง region ที่ใช้ในโปรเจค

```
ap-southeast-1
```

---

# ขั้นตอนที่ 2 : Clone Repository

ทำการ Clone Repository

```
git clone <repository-url>
cd NUDPACK_terraform
```

เข้าไปยังโฟลเดอร์ Terraform

```
cd terraform
```

---

# ขั้นตอนที่ 3 : Initialize Terraform

ทำการ Initialize Terraform เพื่อดาวน์โหลด Provider ที่จำเป็น

```
terraform init
```

Terraform จะดาวน์โหลด Provider และเตรียม Environment สำหรับการสร้าง Infrastructure

---

# ขั้นตอนที่ 4 : ตรวจสอบ Infrastructure (Terraform Plan)

ใช้คำสั่ง

```
terraform plan
```

คำสั่งนี้ใช้เพื่อ

* ตรวจสอบว่า Terraform Configuration ไม่มี Error
* แสดงรายการ Resource ที่จะถูกสร้าง

---

# ขั้นตอนที่ 5 : Deploy Infrastructure (Terraform Apply)

ใช้คำสั่ง

```
terraform apply
```

เมื่อ Terraform ถาม

```
Do you want to perform these actions?
```

ให้พิมพ์

```
yes
```

Terraform จะทำการสร้าง Infrastructure บน AWS เช่น

* EC2 Instance
* Security Group
* Network Configuration
* Deploy Web Application จาก GitHub Repository

---

# ขั้นตอนที่ 6 : เข้าใช้งาน Web Application

หลังจาก `terraform apply` สำเร็จ Terraform จะทำการแสดง **Public IP ของ EC2**

ตัวอย่าง Output

```
ec2_public_ip = 54.xxx.xxx.xxx
```

นำ IP ที่ได้ไปเปิดผ่าน Web Browser

---

# หน้าการใช้งานของระบบ

ระบบ NUDPACK เป็นระบบจัดการพัสดุ โดยมี 3 หน้าหลัก

### 1. ผู้ดูแลระบบ (Admin)

```
http://<EC2_PUBLIC_IP>:8000/admin
```

ใช้สำหรับ

* จัดการข้อมูลพัสดุ
* ตรวจสอบสถานะพัสดุ
* บริหารจัดการระบบ

---

### 2. พนักงานขนส่ง (Client)

```
http://<EC2_PUBLIC_IP>:8000/client
```

ใช้สำหรับ

* อัปเดตสถานะการจัดส่งพัสดุ
* จัดการข้อมูลการขนส่ง

---

### 3. ผู้รับพัสดุ (Recipient)

```
http://<EC2_PUBLIC_IP>:8000/recipient
```

ใช้สำหรับ

* ตรวจสอบสถานะพัสดุ
* ยืนยันการรับพัสดุ

---

# ขั้นตอนการลบ Infrastructure (Terraform Destroy)

หากต้องการลบ Infrastructure ทั้งหมดที่สร้างขึ้น สามารถใช้คำสั่ง

```
terraform destroy
```

เมื่อระบบถาม

```
Do you really want to destroy all resources?
```

ให้พิมพ์

```
yes
```

Terraform จะทำการลบ Resource ทั้งหมดที่ถูกสร้างโดย Terraform เช่น

* EC2 Instance
* Security Group
* Network Configuration

เพื่อป้องกันค่าใช้จ่ายจากการใช้งาน Cloud

---

# การทดสอบระบบ

โปรเจคนี้ได้ทำการทดสอบคำสั่ง Terraform ดังต่อไปนี้แล้ว

```
terraform init
terraform plan
terraform apply
terraform destroy
```

ทุกคำสั่งสามารถทำงานได้สำเร็จโดยไม่เกิด Error และสามารถเข้าใช้งาน Web Application ได้ผ่าน Public IP ของ EC2 Instance
