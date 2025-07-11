-- Add dental_companies table
CREATE TABLE dental_companies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add assistants table
CREATE TABLE assistants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    dental_company_id UUID NOT NULL REFERENCES dental_companies(id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Many-to-many: assistants <-> practitioners
CREATE TABLE assistant_practitioner (
    assistant_id UUID NOT NULL REFERENCES assistants(id) ON DELETE CASCADE,
    practitioner_id UUID NOT NULL REFERENCES practitioners(id) ON DELETE CASCADE,
    PRIMARY KEY (assistant_id, practitioner_id)
);

-- Add dental_company_id to practitioners
ALTER TABLE practitioners ADD COLUMN dental_company_id UUID REFERENCES dental_companies(id);

-- Add dental_company_id to patients
ALTER TABLE patients ADD COLUMN dental_company_id UUID REFERENCES dental_companies(id);

-- Add dental_company_id to appointments
ALTER TABLE appointments ADD COLUMN dental_company_id UUID REFERENCES dental_companies(id);

-- Update triggers for new tables
CREATE TRIGGER update_dental_companies_updated_at
    BEFORE UPDATE ON dental_companies
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_assistants_updated_at
    BEFORE UPDATE ON assistants
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
