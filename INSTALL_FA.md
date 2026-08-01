# 🧠 MASTAN AI FACTORY - نسخه فارسی

## 🎯 روند نصب

### مرحله ۱: انتخاب سیستم‌عامل خود

#### 💻 Windows (CMD یا PowerShell)
```cmd
INSTALL.bat
```

#### 🍎 macOS (Terminal)
```bash
chmod +x INSTALL.sh
bash INSTALL.sh
```

#### 🐧 Linux (Terminal)
```bash
chmod +x INSTALL_LINUX.sh
bash INSTALL_LINUX.sh
```

---

## 🚀 شروع سریع (۵ دقیقه)

### ۱. اجرای اسکریپت نصب
```bash
# Linux/macOS
bash INSTALL.sh

# یا Windows
INSTALL.bat
```

### ۲. شروع سرویس‌ها
```bash
docker-compose up -d
```

### ۳. دسترسی به برنامه

| سرویس | آدرس |
|------|-----|
| 🖥️ Frontend | http://localhost:5173 |
| 🔌 API | http://localhost:3000 |
| 📊 Database | localhost:5432 |
| 🔴 Redis | localhost:6379 |

---

## 📋 نیازمندی‌ها

### الزامی
- ✅ Node.js 18+
- ✅ Docker
- ✅ Docker Compose

### اختیاری
- Git
- VS Code
- PostgreSQL Client
- Redis CLI

---

## 🔧 دستورات مفید

### شروع/متوقف کردن
```bash
# شروع سرویس‌ها
docker-compose up -d

# متوقف کردن
docker-compose down

# بازشروع
docker-compose restart
```

### دیدن لاگ‌ها
```bash
# تمام سرویس‌ها
docker-compose logs -f

# Backend فقط
docker-compose logs -f backend

# Frontend فقط
docker-compose logs -f frontend

# Database فقط
docker-compose logs -f postgres
```

### دسترسی به Database
```bash
# اتصال به PostgreSQL
docker-compose exec postgres psql -U clinlc_user -d clinlc_db
```

### ساخت و فشردگی
```bash
# ساخت برای production
npm run build

# ساخت مجدد Docker images
docker-compose build --no-cache

# حذف کامل (احتیاط!)
docker-compose down -v
```

---

## 🔐 اطلاعات Database

```
Username: clinlc_user
Password: clinlc_password_2026
Database: clinlc_db
Host: localhost
Port: 5432
```

---

## ⚠️ عیب‌یابی

### خطای "Port already in use"
```bash
# پیدا کن و حذف کن
lsof -i :3000 | grep LISTEN | awk '{print $2}' | xargs kill -9
lsof -i :5173 | grep LISTEN | awk '{print $2}' | xargs kill -9
```

### خطای Docker
```bash
# پاک کردن کانتینرهای متوقف
docker container prune

# پاک کردن تصاویر استفاده‌نشده
docker image prune

# مجدد شروع Docker daemon
sudo systemctl restart docker
```

### مشکل اتصال Database
```bash
# بررسی وضعیت
docker-compose ps postgres

# بازشروع
docker-compose restart postgres

# دیدن لاگ‌ها
docker-compose logs postgres
```

### مشکل Dependencies
```bash
# پاک کردن cache
npm cache clean --force

# حذف و دوباره نصب
rm -rf node_modules package-lock.json
npm install
```

---

## 📞 کمک و پشتیبانی

- 📚 **مستندات**: دوشاخه `docs/`
- 🐛 **مسائل**: GitHub Issues
- 💬 **بحث**: GitHub Discussions  
- 📧 **ایمیل**: support@clinlc.local

---

## 📁 ساختار پروژه

```
Clinlc-/
├── backend/          # API سرور
├── frontend/         # رابط کاربری
├── database/         # Schema و Migration
├── ai-factory/       # تولیدکننده‌های AI
├── docs/             # مستندات
├── docker-compose.yml
├── setup.sh
├── INSTALL.sh
├── INSTALL.bat
└── INSTALL_LINUX.sh
```

---

## 🎓 مراحل بعدی

1. ✅ نصب و راه‌اندازی تکمیل شد
2. 🔧 شخصی‌سازی فایل‌های `.env`
3. 🗄️ اجرای Migration‌های Database
4. 🏗️ ایجاد API endpoints
5. 🎨 طراحی صفحات Frontend
6. 🤖 اضافه کردن Generators
7. 🧪 نوشتن تست‌ها
8. 🚀 배포کردن

---

**نسخه ۱.۰.۰** | تاریخ به‌روزرسانی: ۱ مردادماه ۱۴۰۵
