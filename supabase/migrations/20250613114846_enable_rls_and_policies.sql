-- Migration: Enable RLS and add policies for new tables
-- Purpose: Secure new tables (dental_companies, assistants, assistant_practitioner) with Row Level Security (RLS) and add filtered, granular policies for practitioners and assistants.
-- Affected tables: dental_companies, assistants, assistant_practitioner
-- Special considerations: Only authenticated users can access, with row-level filtering for practitioners and assistants. All policies are permissive and granular.

-- Enable RLS for new tables
ALTER TABLE dental_companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE assistants ENABLE ROW LEVEL SECURITY;
ALTER TABLE assistant_practitioner ENABLE ROW LEVEL SECURITY;

-- Practitioners: Only authenticated users can access their own row
CREATE POLICY "Practitioners can select their own record" ON practitioners
  FOR SELECT TO authenticated
  USING ((select auth.uid()) = id);

CREATE POLICY "Practitioners can update their own record" ON practitioners
  FOR UPDATE TO authenticated
  USING ((select auth.uid()) = id)
  WITH CHECK ((select auth.uid()) = id);

CREATE POLICY "Practitioners can delete their own record" ON practitioners
  FOR DELETE TO authenticated
  USING ((select auth.uid()) = id);

CREATE POLICY "Practitioners can insert their own record" ON practitioners
  FOR INSERT TO authenticated
  WITH CHECK ((select auth.uid()) = id);

-- Assistants: Only authenticated users can access their own row
CREATE POLICY "Assistants can select their own record" ON assistants
  FOR SELECT TO authenticated
  USING ((select auth.uid()) = id);

CREATE POLICY "Assistants can update their own record" ON assistants
  FOR UPDATE TO authenticated
  USING ((select auth.uid()) = id)
  WITH CHECK ((select auth.uid()) = id);

CREATE POLICY "Assistants can delete their own record" ON assistants
  FOR DELETE TO authenticated
  USING ((select auth.uid()) = id);

CREATE POLICY "Assistants can insert their own record" ON assistants
  FOR INSERT TO authenticated
  WITH CHECK ((select auth.uid()) = id);

-- Dental companies: Only authenticated users can access (public access not allowed)
CREATE POLICY "Authenticated users can select dental companies" ON dental_companies
  FOR SELECT TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert dental companies" ON dental_companies
  FOR INSERT TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update dental companies" ON dental_companies
  FOR UPDATE TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete dental companies" ON dental_companies
  FOR DELETE TO authenticated
  USING (true);

-- Assistant-practitioner: Only authenticated users can access
CREATE POLICY "Authenticated users can select assistant_practitioner" ON assistant_practitioner
  FOR SELECT TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert assistant_practitioner" ON assistant_practitioner
  FOR INSERT TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update assistant_practitioner" ON assistant_practitioner
  FOR UPDATE TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete assistant_practitioner" ON assistant_practitioner
  FOR DELETE TO authenticated
  USING (true); 