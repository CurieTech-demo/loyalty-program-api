-- Loyalty Program Database Schema
-- PostgreSQL Database: loyalty_db

-- Drop table if exists (for development/testing)
DROP TABLE IF EXISTS customers CASCADE;

-- Create customers table
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    enrollment_date TIMESTAMP NOT NULL,
    tier VARCHAR(20) NOT NULL DEFAULT 'Bronze',
    total_points INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on email for faster lookups
CREATE INDEX idx_customers_email ON customers(email);

-- Create index on tier for reporting
CREATE INDEX idx_customers_tier ON customers(tier);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_customers_updated_at
    BEFORE UPDATE ON customers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add check constraint for tier values
ALTER TABLE customers ADD CONSTRAINT check_tier 
    CHECK (tier IN ('Bronze', 'Silver', 'Gold'));

-- Add check constraint for total_points (must be non-negative)
ALTER TABLE customers ADD CONSTRAINT check_total_points 
    CHECK (total_points >= 0);

-- Insert sample data for testing (optional)
-- INSERT INTO customers (customer_id, first_name, last_name, email, phone, enrollment_date, tier, total_points)
-- VALUES 
--     ('CUST-TEST-001', 'John', 'Doe', 'john.doe@example.com', '+12025551234', CURRENT_TIMESTAMP, 'Bronze', 0),
--     ('CUST-TEST-002', 'Jane', 'Smith', 'jane.smith@example.com', '+12025555678', CURRENT_TIMESTAMP, 'Silver', 500);

-- Grant permissions (adjust as needed for your environment)
-- GRANT SELECT, INSERT, UPDATE, DELETE ON customers TO loyalty_user;
