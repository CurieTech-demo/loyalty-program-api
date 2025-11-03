# Loyalty Program API - Testing Guide

This document provides examples for testing the Loyalty Program API endpoints.

## Prerequisites

- The application must be running on `http://localhost:8081`
- PostgreSQL database must be configured and running
- Database schema must be created (see `src/main/resources/sql/schema.sql`)

## Base URL

```
http://localhost:8081/api/loyalty/v1
```

## Test Scenarios

### 1. Successful Customer Enrollment

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

**Expected Response (201 Created):**
```json
{
  "customerId": "CUST-123e4567-e89b-12d3-a456-426614174000",
  "message": "Customer successfully enrolled in loyalty program",
  "tier": "Bronze",
  "enrollmentDate": "2024-01-15T10:30:00Z"
}
```

### 2. Customer Enrollment Without Phone (Optional Field)

**Request:**
```bash
curl -X POST http://localhost:8081/api/loyalty/v1/customers \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Jane",
    "lastName": "Smith",
    "email": "jane.smith@example.com"
  }'
```

**Expected Response (201 Created):**
```json
{
  "customerId": "CUST-987e6543-e21b-34c5-b678-123456789abc",
  "message": "Customer successfully enrolled in loyalty program",
  "tier": "Bronze",
  "enrollmentDate": "2024-01-15T10:35:00Z"
}
```

### 3. Duplicate Customer (409 Conflict)

**Request:**
```bash
# First, enroll a customer
curl -X POST http://localhost:8081/api/loyalty/v1/customers \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Alice",
    "lastName": "Johnson",
    "email": "alice.johnson@example.com",
    "phone": "+12025559999"
  }'

# Then, try to enroll the same email again
curl -X POST http://localhost:8081/api/loyalty/v1/customers \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Alice",
    "lastName": "Johnson",
    "email": "alice.johnson@example.com",
    "phone": "+12025559999"
  }'
```

**Expected Response (409 Conflict):**
```json
{
  "error": "CONFLICT",
  "message": "Customer with this email already exists",
  "timestamp": "2024-01-15T10:40:00Z"
}
```

### 4. Invalid Email Format (400 Bad Request)

**Request:**
```bash
curl -X POST http://localhost:8081/api/loyalty/v1/customers \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Bob",
    "lastName": "Williams",
    "email": "invalid-email",
    "phone": "+12025558888"
  }'
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "BAD_REQUEST",
  "message": "Invalid request data",
  "timestamp": "2024-01-15T10:45:00Z"
}
```

### 5. Missing Required Field (400 Bad Request)

**Request:**
```bash
curl -X POST http://localhost:8081/api/loyalty/v1/customers \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Charlie",
    "email": "charlie.brown@example.com"
  }'
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "BAD_REQUEST",
  "message": "Invalid request data",
  "timestamp": "2024-01-15T10:50:00Z"
}
```

### 6. Invalid Phone Format (400 Bad Request)

**Request:**
```bash
curl -X POST http://localhost:8081/api/loyalty/v1/customers \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "David",
    "lastName": "Miller",
    "email": "david.miller@example.com",
    "phone": "invalid-phone"
  }'
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "BAD_REQUEST",
  "message": "Invalid request data",
  "timestamp": "2024-01-15T10:55:00Z"
}
```

### 7. First Name Too Short (400 Bad Request)

**Request:**
```bash
curl -X POST http://localhost:8081/api/loyalty/v1/customers \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "A",
    "lastName": "Davis",
    "email": "a.davis@example.com"
  }'
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "BAD_REQUEST",
  "message": "Invalid request data",
  "timestamp": "2024-01-15T11:00:00Z"
}
```

### 8. Method Not Allowed (405)

**Request:**
```bash
curl -X GET http://localhost:8081/api/loyalty/v1/customers \
  -H "Content-Type: application/json"
```

**Expected Response (405 Method Not Allowed):**
```json
{
  "error": "METHOD_NOT_ALLOWED",
  "message": "Method not allowed",
  "timestamp": "2024-01-15T11:05:00Z"
}
```

### 9. Resource Not Found (404)

**Request:**
```bash
curl -X POST http://localhost:8081/api/loyalty/v1/invalid-endpoint \
  -H "Content-Type: application/json" \
  -d '{}'
```

**Expected Response (404 Not Found):**
```json
{
  "error": "NOT_FOUND",
  "message": "Resource not found",
  "timestamp": "2024-01-15T11:10:00Z"
}
```

## Testing with Postman

### Import Collection

You can create a Postman collection with the following structure:

1. **Collection Name**: Loyalty Program API
2. **Base URL Variable**: `{{baseUrl}}` = `http://localhost:8081/api/loyalty/v1`

### Test Cases

#### Test 1: Enroll Customer - Success
- **Method**: POST
- **URL**: `{{baseUrl}}/customers`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "firstName": "{{$randomFirstName}}",
  "lastName": "{{$randomLastName}}",
  "email": "{{$randomEmail}}",
  "phone": "+1{{$randomPhoneNumber}}"
}
```
- **Tests**:
```javascript
pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
});

pm.test("Response has customerId", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.customerId).to.exist;
    pm.expect(jsonData.customerId).to.match(/^CUST-/);
});

pm.test("Response has correct tier", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.tier).to.eql("Bronze");
});

pm.test("Response has message", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.message).to.exist;
});

pm.test("Response has enrollmentDate", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.enrollmentDate).to.exist;
});
```

#### Test 2: Enroll Customer - Duplicate Email
- **Method**: POST
- **URL**: `{{baseUrl}}/customers`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "duplicate@example.com",
  "phone": "+12025551234"
}
```
- **Pre-request Script** (run this twice):
```javascript
// First run will succeed, second will fail with 409
```
- **Tests**:
```javascript
pm.test("Status code is 409 on duplicate", function () {
    pm.response.to.have.status(409);
});

pm.test("Error response has correct structure", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.error).to.eql("CONFLICT");
    pm.expect(jsonData.message).to.exist;
    pm.expect(jsonData.timestamp).to.exist;
});
```

#### Test 3: Enroll Customer - Invalid Email
- **Method**: POST
- **URL**: `{{baseUrl}}/customers`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "firstName": "Invalid",
  "lastName": "Email",
  "email": "not-an-email",
  "phone": "+12025551234"
}
```
- **Tests**:
```javascript
pm.test("Status code is 400", function () {
    pm.response.to.have.status(400);
});

pm.test("Error response indicates bad request", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.error).to.eql("BAD_REQUEST");
});
```

## Testing with HTTPie

If you prefer HTTPie, here are the equivalent commands:

### Successful Enrollment
```bash
http POST http://localhost:8081/api/loyalty/v1/customers \
  firstName="John" \
  lastName="Doe" \
  email="john.doe@example.com" \
  phone="+12025551234"
```

### Enrollment Without Phone
```bash
http POST http://localhost:8081/api/loyalty/v1/customers \
  firstName="Jane" \
  lastName="Smith" \
  email="jane.smith@example.com"
```

### Invalid Email
```bash
http POST http://localhost:8081/api/loyalty/v1/customers \
  firstName="Bob" \
  lastName="Williams" \
  email="invalid-email" \
  phone="+12025558888"
```

## Database Verification

After enrolling customers, you can verify the data in PostgreSQL:

```sql
-- Connect to database
psql -U loyalty_user -d loyalty_db

-- View all customers
SELECT * FROM customers;

-- View specific customer by email
SELECT * FROM customers WHERE email = 'john.doe@example.com';

-- Count customers by tier
SELECT tier, COUNT(*) as count FROM customers GROUP BY tier;

-- View recent enrollments
SELECT customer_id, first_name, last_name, email, tier, enrollment_date 
FROM customers 
ORDER BY enrollment_date DESC 
LIMIT 10;
```

## APIkit Console

You can also test the API using the built-in APIkit console:

1. Open your browser
2. Navigate to: `http://localhost:8081/console/`
3. Use the interactive console to test the API

The console provides:
- API documentation
- Request/response examples
- Interactive testing interface
- RAML specification viewer

## Load Testing

For load testing, you can use tools like Apache JMeter or Artillery:

### Artillery Example

Create a file `load-test.yml`:

```yaml
config:
  target: "http://localhost:8081"
  phases:
    - duration: 60
      arrivalRate: 10
  variables:
    firstName:
      - "John"
      - "Jane"
      - "Bob"
      - "Alice"
    lastName:
      - "Doe"
      - "Smith"
      - "Johnson"
      - "Williams"

scenarios:
  - name: "Enroll Customer"
    flow:
      - post:
          url: "/api/loyalty/v1/customers"
          json:
            firstName: "{{ firstName }}"
            lastName: "{{ lastName }}"
            email: "{{ $randomString() }}@example.com"
            phone: "+1{{ $randomNumber(10) }}"
```

Run the load test:
```bash
artillery run load-test.yml
```

## Troubleshooting

### Connection Refused
- Ensure the application is running
- Check if port 8081 is available
- Verify firewall settings

### Database Errors
- Verify PostgreSQL is running
- Check database credentials in config YAML
- Ensure database schema is created
- Verify database user has proper permissions

### 500 Internal Server Error
- Check application logs
- Verify database connectivity
- Check for SQL syntax errors
- Review error-handlers.xml for proper error handling

## Monitoring

Monitor the application logs for:
- Request received messages
- Customer enrollment process logs
- Database operation logs
- Error messages
- Success confirmations

Logs are configured in `src/main/resources/log4j2.xml`.
