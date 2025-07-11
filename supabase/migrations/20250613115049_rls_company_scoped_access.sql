-- Migration: RLS company-scoped access for practitioners and assistants
-- Purpose: Restrict SELECT access to appointments, patients, and assistants so that practitioners and assistants can only consult records from their own dental company.
-- Affected tables: appointments, patients, assistants
-- Special considerations: Uses subqueries to match the current user's dental_company_id from practitioners or assistants tables.

-- Practitioners can select appointments from their dental company
CREATE POLICY "Practitioners can select appointments from their company" ON appointments
  FOR SELECT TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM practitioners WHERE id = (select auth.uid())
    )
  );

-- Practitioners can select patients from their dental company
CREATE POLICY "Practitioners can select patients from their company" ON patients
  FOR SELECT TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM practitioners WHERE id = (select auth.uid())
    )
  );

-- Practitioners can select assistants from their dental company
CREATE POLICY "Practitioners can select assistants from their company" ON assistants
  FOR SELECT TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM practitioners WHERE id = (select auth.uid())
    )
  );

-- Assistants can select appointments from their dental company
CREATE POLICY "Assistants can select appointments from their company" ON appointments
  FOR SELECT TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM assistants WHERE id = (select auth.uid())
    )
  );

-- Assistants can select patients from their dental company
CREATE POLICY "Assistants can select patients from their company" ON patients
  FOR SELECT TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM assistants WHERE id = (select auth.uid())
    )
  );

-- Assistants can select practitioners from their dental company
CREATE POLICY "Assistants can select practitioners from their company" ON practitioners
  FOR SELECT TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM assistants WHERE id = (select auth.uid())
    )
  );

-- Practitioners can update appointments from their dental company
CREATE POLICY "Practitioners can update appointments from their company" ON appointments
  FOR UPDATE TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM practitioners WHERE id = (select auth.uid())
    )
  )
  WITH CHECK (
    dental_company_id = (
      SELECT dental_company_id FROM practitioners WHERE id = (select auth.uid())
    )
  );

-- Practitioners can delete appointments from their dental company
CREATE POLICY "Practitioners can delete appointments from their company" ON appointments
  FOR DELETE TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM practitioners WHERE id = (select auth.uid())
    )
  );

-- Practitioners can update patients from their dental company
CREATE POLICY "Practitioners can update patients from their company" ON patients
  FOR UPDATE TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM practitioners WHERE id = (select auth.uid())
    )
  )
  WITH CHECK (
    dental_company_id = (
      SELECT dental_company_id FROM practitioners WHERE id = (select auth.uid())
    )
  );

-- Practitioners can delete patients from their dental company
CREATE POLICY "Practitioners can delete patients from their company" ON patients
  FOR DELETE TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM practitioners WHERE id = (select auth.uid())
    )
  );

-- Practitioners can update assistants from their dental company
CREATE POLICY "Practitioners can update assistants from their company" ON assistants
  FOR UPDATE TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM practitioners WHERE id = (select auth.uid())
    )
  )
  WITH CHECK (
    dental_company_id = (
      SELECT dental_company_id FROM practitioners WHERE id = (select auth.uid())
    )
  );

-- Practitioners can delete assistants from their dental company
CREATE POLICY "Practitioners can delete assistants from their company" ON assistants
  FOR DELETE TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM practitioners WHERE id = (select auth.uid())
    )
  );

-- Assistants can update appointments from their dental company
CREATE POLICY "Assistants can update appointments from their company" ON appointments
  FOR UPDATE TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM assistants WHERE id = (select auth.uid())
    )
  )
  WITH CHECK (
    dental_company_id = (
      SELECT dental_company_id FROM assistants WHERE id = (select auth.uid())
    )
  );

-- Assistants can delete appointments from their dental company
CREATE POLICY "Assistants can delete appointments from their company" ON appointments
  FOR DELETE TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM assistants WHERE id = (select auth.uid())
    )
  );

-- Assistants can update patients from their dental company
CREATE POLICY "Assistants can update patients from their company" ON patients
  FOR UPDATE TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM assistants WHERE id = (select auth.uid())
    )
  )
  WITH CHECK (
    dental_company_id = (
      SELECT dental_company_id FROM assistants WHERE id = (select auth.uid())
    )
  );

-- Assistants can delete patients from their dental company
CREATE POLICY "Assistants can delete patients from their company" ON patients
  FOR DELETE TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM assistants WHERE id = (select auth.uid())
    )
  );

-- Assistants can update practitioners from their dental company
CREATE POLICY "Assistants can update practitioners from their company" ON practitioners
  FOR UPDATE TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM assistants WHERE id = (select auth.uid())
    )
  )
  WITH CHECK (
    dental_company_id = (
      SELECT dental_company_id FROM assistants WHERE id = (select auth.uid())
    )
  );

-- Assistants can delete practitioners from their dental company
CREATE POLICY "Assistants can delete practitioners from their company" ON practitioners
  FOR DELETE TO authenticated
  USING (
    dental_company_id = (
      SELECT dental_company_id FROM assistants WHERE id = (select auth.uid())
    )
  );

-- Trigger function to autofill dental_company_id on insert for appointments and patients
CREATE OR REPLACE FUNCTION public.autofill_dental_company_id()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  user_company_id uuid;
BEGIN
  -- Try to get company from practitioners
  SELECT dental_company_id INTO user_company_id FROM public.practitioners WHERE id = (select auth.uid());
  IF user_company_id IS NULL THEN
    -- If not a practitioner, try assistants
    SELECT dental_company_id INTO user_company_id FROM public.assistants WHERE id = (select auth.uid());
  END IF;
  -- Keep the computed user_company_id, raising an error if null
  IF user_company_id IS NULL THEN
    RAISE EXCEPTION 'User must belong to a dental company';
  END IF;
  RETURN NEW;
END;
$$;

-- Trigger for appointments
CREATE TRIGGER autofill_appointments_company_id
  BEFORE INSERT ON public.appointments
  FOR EACH ROW
  EXECUTE FUNCTION public.autofill_dental_company_id();

-- Trigger for patients
CREATE TRIGGER autofill_patients_company_id
  BEFORE INSERT ON public.patients
  FOR EACH ROW
  EXECUTE FUNCTION public.autofill_dental_company_id(); 