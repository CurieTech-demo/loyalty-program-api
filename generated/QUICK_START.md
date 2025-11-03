# Loyalty Program API - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Prerequisites
- ✅ Java 17 installed
- ✅ Maven 3.9+ installed
- ✅ PostgreSQL installed and running

### Step 1: Setup Database (2 minutes)

```bash
# Create database and user
psql -U postgres << EOF
CREATE DATABASE loyalty_db;
CREATE USER loyalty_user WITH PASSWORD 'loyalty_pass';
GRANT ALL PRIVILEGES ON DATABASE loyalty_db TO loyalty_user;
\q
EOF

# Create schema
psql -U loyalty_user -d loyalty_db -f src/main/resources/sql/schema.sql
```

### Step 2: Build Application (1 minute)

```bash
mvn clean install
```

### Step 3: Run Application (1 minute)

```bash
mvn mule:run
```

Wait for the message: `Mule app deployed successfully`

### Step 4: Test API (1 minute)

```bash
# Test enrollment
curl -X POST http://localhost:8081/api/loyalty/v1/customers \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "phone": "+12025551234"
  }'
```

**Expected Response:**
```json
{
  "customerId": "CUST-...",
  "message": "Customer successfully enrolled in loyalty program",
  "tier": "Bronze",
  "enrollmentDate": "2024-..."
}
```

### Step 5: Explore API Console

Open browser: **http://localhost:8081/console/**

---

## 📋 Common Commands

### Build
```bash
mvn clean install              # Full build
mvn clean install -DskipTests  # Skip tests
```

### Run
```bash
mvn mule:run                   # Run application
```

### Test
```bash
# Enroll customer
curl -X POST http://localhost:8081/api/loyalty/v1/customers \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Jane","lastName":"Smith","email":"jane@example.com"}'

# View database
psql -U loyalty_user -d loyalty_db -c "SELECT * FROM customers;"
```

---

## 🔧 Configuration

### Development (Default)
Edit: `src/main/resources/config/config-dev.yaml`

```yaml
http:
  port: "8081"
  host: "0.0.0.0"

db:
  host: "localhost"
  port: "5432"
  name: "loyalty_db"
  user: "loyalty_user"
  password: "loyalty_pass"
```

### Production
Set environment variables:
```bash
export DB_HOST=prod-db-server.example.com
export DB_NAME=loyalty_db_prod
export DB_USER=loyalty_prod_user
export DB_PASSWORD=secure_password
```

Run with production config:
```bash
mvn mule:run -Dmule.env=prod
```

---

## 📁 Project Structure

```
loyalty-program-api/
├── src/main/
│   ├── mule/
│   │   ├── global-config.xml           # Configurations
│   │   ├── loyalty-program-api.xml     # API flows
│   │   └── error-handlers.xml          # Error handling
│   └── resources/
│       ├── api/loyalty-program-api.raml # API spec
│       ├── config/
│       │   ├── config-dev.yaml         # Dev config
│       │   └── config-prod.yaml        # Prod config
│       └── sql/schema.sql              # DB schema
├── pom.xml                             # Dependencies
├── README.md                           # Full documentation
├── API_TESTING.md                      # Testing guide
└── PROJECT_SUMMARY.md                  # Project overview
```

---

## 🐛 Troubleshooting

### Port 8081 already in use
```bash
# Change port in config-dev.yaml
http:
  port: "8082"  # Use different port
```

### Database connection failed
```bash
# Check PostgreSQL is running
sudo systemctl status postgresql

# Verify credentials
psql -U loyalty_user -d loyalty_db -c "\dt"
```

### Build failed
```bash
# Clean and rebuild
mvn clean
mvn install -U
```

---

## 📚 Documentation

- **README.md** - Complete setup guide
- **API_TESTING.md** - Testing examples
- **PROJECT_SUMMARY.md** - Project overview
- **Console** - http://localhost:8081/console/

---

## ✅ Verification Checklist

- [ ] Java 17 installed: `java -version`
- [ ] Maven 3.9+ installed: `mvn -version`
- [ ] PostgreSQL running: `psql --version`
- [ ] Database created: `psql -U loyalty_user -d loyalty_db -c "\dt"`
- [ ] Application built: `mvn clean install`
- [ ] Application running: `mvn mule:run`
- [ ] API responding: `curl http://localhost:8081/api/loyalty/v1/customers`
- [ ] Console accessible: Open http://localhost:8081/console/

---

## 🎯 Next Steps

1. **Test the API** - Use API_TESTING.md for examples
2. **Explore Console** - http://localhost:8081/console/
3. **Review Code** - Check src/main/mule/ files
4. **Customize** - Modify flows for your needs
5. **Deploy** - Follow production deployment guide

---

## 💡 Key Features

✅ RAML-based API with validation  
✅ PostgreSQL database integration  
✅ Duplicate customer detection  
✅ Comprehensive error handling  
✅ Environment-specific configs  
✅ Interactive API console  
✅ Production-ready code  

---

## 🆘 Need Help?

1. Check **README.md** for detailed documentation
2. Review **API_TESTING.md** for testing examples
3. Check application logs for errors
4. Verify database connectivity
5. Ensure all prerequisites are met

---

**Happy Coding! 🚀**
