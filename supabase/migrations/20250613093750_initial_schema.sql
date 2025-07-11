-- Create enum types
CREATE TYPE gender_type AS ENUM ('male', 'female', 'other');
CREATE TYPE appointment_status AS ENUM (
    'scheduled',
    'confirmed',
    'completed',
    'cancelled',
    'no_show'
);
CREATE TYPE payment_status AS ENUM (
    'pending',
    'paid',
    'partially_paid',
    'refunded',
    'cancelled'
);
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- Create tables
CREATE TABLE practitioners (
    id UUID REFERENCES auth.users on delete cascade not null PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    specialization VARCHAR(100),
    license_number VARCHAR(50) UNIQUE,
    avatar_url VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TABLE patients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender gender_type,
    email VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    medical_history TEXT,
    allergies TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TABLE treatments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    default_duration INTEGER NOT NULL,
    -- Duration in minutes
    default_cost DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TABLE appointments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID NOT NULL REFERENCES patients(id),
    practitioner_id UUID NOT NULL REFERENCES practitioners(id),
    treatment_id UUID REFERENCES treatments(id),
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    status appointment_status NOT NULL DEFAULT 'scheduled',
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TABLE medical_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID NOT NULL REFERENCES patients(id),
    practitioner_id UUID NOT NULL REFERENCES practitioners(id),
    appointment_id UUID REFERENCES appointments(id),
    diagnosis TEXT,
    treatment_notes TEXT,
    prescription TEXT,
    attachments JSONB,
    -- For storing links to x-rays, documents, etc.
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID NOT NULL REFERENCES patients(id),
    appointment_id UUID REFERENCES appointments(id),
    total_amount DECIMAL(10, 2) NOT NULL,
    status payment_status NOT NULL DEFAULT 'pending',
    due_date DATE NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    invoice_id UUID NOT NULL REFERENCES invoices(id),
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMPTZ NOT NULL,
    payment_method VARCHAR(50),
    transaction_reference VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
-- Create indexes for better query performance
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_practitioner ON appointments(practitioner_id);
CREATE INDEX idx_appointments_start_time ON appointments(start_time);
CREATE INDEX idx_medical_records_patient ON medical_records(patient_id);
CREATE INDEX idx_invoices_patient ON invoices(patient_id);
CREATE INDEX idx_payments_invoice ON payments(invoice_id);
-- Create updated_at triggers
CREATE OR REPLACE FUNCTION update_updated_at_column() RETURNS TRIGGER AS $$ BEGIN NEW.updated_at = NOW();
RETURN NEW;
END;
$$ language 'plpgsql';
-- Apply updated_at triggers to all tables
CREATE TRIGGER update_practitioners_updated_at BEFORE
UPDATE ON practitioners FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_patients_updated_at BEFORE
UPDATE ON patients FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_treatments_updated_at BEFORE
UPDATE ON treatments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_appointments_updated_at BEFORE
UPDATE ON appointments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_medical_records_updated_at BEFORE
UPDATE ON medical_records FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_invoices_updated_at BEFORE
UPDATE ON invoices FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_payments_updated_at BEFORE
UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
-- Add RLS (Row Level Security) policies
ALTER TABLE practitioners ENABLE ROW LEVEL SECURITY;
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE treatments ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE medical_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;


create function public.handle_new_user()
returns trigger
set search_path = ''
as $$
begin
  insert into public.practitioners (id, email,first_name,avatar_url)
  values (new.id,new.email,new.raw_user_meta_data->>'full_name',new.raw_user_meta_data->>'avatar_url');
  return new;
end;
$$ language plpgsql security definer;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
