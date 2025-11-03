# Loyalty Program API

A MuleSoft application for managing customer enrollment in a loyalty program.

## Project Details

- **Project Name**: loyalty-program-api
- **Mule Runtime**: 4.9.3
- **Java Version**: 17
- **Maven Version**: 3.9

## Features

- Customer enrollment endpoint (POST /customers)
- RAML-based API specification with APIkit
- PostgreSQL database integration
- Comprehensive error handling
- Environment-specific configuration
- Request validation
- Duplicate customer detection

## Prerequisites

1. **Java 17** installed and configured
2. **Maven 3.9** or higher
3. **PostgreSQL** database server
4. **Anypoint Studio** (optional, for development)

## Database Setup

### 1. Create PostgreSQL Database

```bash
# Connect to PostgreSQL
psql -U postgres

# Create database and user
CREATE DATABASE loyalty_db;
CREATE USER loyalty_user WITH PASSWORD 'loyalty_pass';
GRANT ALL PRIVILEGES ON DATABASE loyalty_db TO loyalty_user;
```

### 2. Create Database Schema

```bash
# Connect to the loyalty_db database
psql -U loyalty_user -d loyalty_db

# Run the schema script
\i src/main/resources/sql/schema.sql
```

Or execute the SQL script directly:

```bash
psql -U loyalty_user -d loyalty_db -f src/main/resources/sql/schema.sql
```

## Configuration

### Environment Configuration Files

The application uses environment-specific YAML configuration files:

- **Development**: `src/main/resources/config/config-dev.yaml`
- **Production**: `src/main/resources/config/config-prod.yaml`

### Configuration Properties

#### HTTP Configuration
- `http.host`: HTTP listener host (default: 0.0.0.0)
- `http.port`: HTTP listener port (default: 8081)

#### Database Configuration
- `db.host`: PostgreSQL host
- `db.port`: PostgreSQL port (default: 5432)
- `db.name`: Database name
- `db.user`: Database username
- `db.password`: Database password

### Setting Environment

Set the `mule.env` property to switch between environments:

```bash
# For development (default)
mvn clean install -Dmule.env=dev

# For production
mvn clean install -Dmule.env=prod
```

## Building the Application

```bash
# Clean and build
mvn clean install

# Build without tests
mvn clean install -DskipTests
```

## Running the Application

### Using Maven

```bash
mvn mule:run
```

### Using Anypoint Studio

1. Import the project into Anypoint Studio
2. Right-click on the project
3. Select "Run As" > "Mule Application"

## API Endpoints

### Base URL
```
http://localhost:8081/api/loyalty/v1
```

### POST /customers - Enroll Customer

Enroll a new customer in the loyalty program.

**Request:**
```bash
curl -X POST http://localhost:8081/api/loyalty/v1/customers \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "phone": "+12025551234"
  }'
```

**Success Response (201):**
```json
{
  "customerId": "CUST-123e4567-e89b-12d3-a456-426614174000",
  "message": "Customer successfully enrolled in loyalty program",
  "tier": "Bronze",
  "enrollmentDate": "2024-01-15T10:30:00Z"
}
```

**Error Response (409 - Duplicate):**
```json
{
  "error": "CONFLICT",
  "message": "Customer with this email already exists",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**Error Response (400 - Bad Request):**
```json
{
  "error": "BAD_REQUEST",
  "message": "Invalid request data",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

### APIkit Console

Access the interactive API console at:
```
http://localhost:8081/console/
```

## Project Structure

```
loyalty-program-api/
├── src/
│   ├── main/
│   │   ├── mule/
│   │   │   ├── global-config.xml          # Global configurations
│   │   │   ├── loyalty-program-api.xml    # Main API flows
│   │   │   └── error-handlers.xml         # Error handling
│   │   └── resources/
│   │       ├── api/
│   │       │   └── loyalty-program-api.raml  # API specification
│   │       ├── config/
│   │       │   ├── config-dev.yaml        # Dev configuration
│   │       │   └── config-prod.yaml       # Prod configuration
│   │       ├── sql/
│   │       │   └── schema.sql             # Database schema
│   │       └── log4j2.xml                 # Logging configuration
│   └── test/
│       └── resources/
│           └── log4j2-test.xml
├── pom.xml                                 # Maven configuration
├── mule-artifact.json                      # Mule artifact descriptor
└── README.md                               # This file
```

## Database Schema

### Customers Table

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| customer_id | VARCHAR(50) | PRIMARY KEY | Unique customer identifier (CUST-UUID format) |
| first_name | VARCHAR(50) | NOT NULL | Customer's first name |
| last_name | VARCHAR(50) | NOT NULL | Customer's last name |
| email | VARCHAR(255) | UNIQUE, NOT NULL | Customer's email address |
| phone | VARCHAR(20) | NULL | Customer's phone number (optional) |
| enrollment_date | TIMESTAMP | NOT NULL | Date and time of enrollment |
| tier | VARCHAR(20) | NOT NULL, DEFAULT 'Bronze' | Loyalty tier (Bronze, Silver, Gold) |
| total_points | INTEGER | NOT NULL, DEFAULT 0 | Total loyalty points |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record update timestamp |

## Error Handling

The application includes comprehensive error handling for:

- **400 Bad Request**: Invalid request data (handled by APIkit validation)
- **404 Not Found**: Resource not found
- **405 Method Not Allowed**: HTTP method not supported
- **409 Conflict**: Customer already exists with the same email
- **500 Internal Server Error**: Database errors, unexpected errors

## Logging

The application logs key events:
- Request received
- Customer enrollment process start
- Database operations
- Errors and warnings
- Successful enrollment completion

## Dependencies

Key dependencies used in this project:

- **Mule HTTP Connector** (1.10.0)
- **Mule Database Connector** (1.14.17)
- **PostgreSQL JDBC Driver** (42.7.8)
- **APIkit Module** (1.11.3)
- **Mule Sockets Connector** (1.2.4)

## Security Considerations

1. **Database Credentials**: Store production credentials securely (use environment variables or secure properties)
2. **SQL Injection**: All queries use parameterized statements
3. **Input Validation**: APIkit validates all requests against RAML specification
4. **Error Messages**: Generic error messages in production to avoid information disclosure

## Production Deployment

For production deployment:

1. Update `config-prod.yaml` with production database credentials
2. Use environment variables for sensitive data:
   ```bash
   export DB_HOST=prod-db-server.example.com
   export DB_NAME=loyalty_db_prod
   export DB_USER=loyalty_prod_user
   export DB_PASSWORD=secure_password
   ```
3. Set `mule.env=prod` when deploying
4. Configure appropriate connection pool settings
5. Enable SSL/TLS for database connections
6. Implement API security (OAuth 2.0, API keys, etc.)

## Troubleshooting

### Database Connection Issues

1. Verify PostgreSQL is running:
   ```bash
   sudo systemctl status postgresql
   ```

2. Check database credentials in config YAML file

3. Verify database exists and user has permissions:
   ```bash
   psql -U loyalty_user -d loyalty_db -c "\dt"
   ```

### Port Already in Use

If port 8081 is already in use, update the `http.port` property in the configuration file.

### APIkit Validation Errors

Ensure your request matches the RAML specification:
- Required fields: firstName, lastName, email
- Email must match pattern: `^\\S+@\\S+\\.\\S+$`
- Phone (optional) must match pattern: `^\\+?[1-9]\\d{1,14}$`

## Support

For issues or questions, please contact the development team.

## License

Copyright © 2024. All rights reserved.
