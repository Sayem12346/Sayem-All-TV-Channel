-- ============================================================
-- SAYEM DENTAL CARE — Supabase Schema
-- Run this entire file in Supabase SQL Editor
-- ============================================================

-- 1. CLINIC SETTINGS (single row)
create table if not exists clinic_settings (
  id integer primary key default 1,
  clinic_name text default 'Sayem Dental Care',
  location text default 'Chittagong, Bangladesh',
  phone text default '+8801633282251',
  whatsapp_number text default '8801633282251',
  email text default 'hafizurrahmansayem@gmail.com',
  facebook_url text default 'https://www.facebook.com',
  youtube_url text default 'https://www.youtube.com',
  hero_headline text default 'Your Healthy Smile Starts Right Here',
  hero_subtext text default 'Expert dental care designed around your comfort. From routine cleanings to full smile transformations — pain-free treatment in the heart of Chittagong.',
  stat1_value text default '2000+',
  stat1_label text default 'Patients Treated',
  stat2_value text default '8+',
  stat2_label text default 'Years Experience',
  stat3_value text default '98%',
  stat3_label text default 'Patient Satisfaction',
  doctor_name text default 'Dr. Md Hafizur Rahman',
  doctor_title text default 'BDS, FCPS Candidate — Lead Dental Surgeon',
  doctor_bio text default 'With over 8 years of clinical experience, Dr. Hafizur Rahman brings compassionate, evidence-based care to every patient.',
  doctor_qualification text default 'BDS, FCPS Candidate',
  doctor_certifications text default 'General Dentistry, Implantology, Orthodontics, Cosmetic Dentistry, Root Canal Specialist',
  doctor_image_url text,
  footer_description text default 'A trusted private dental practice in Chittagong offering comprehensive dental care with a focus on patient comfort, modern techniques, and lasting results.',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Insert default row
insert into clinic_settings (id) values (1) on conflict (id) do nothing;

-- 2. SERVICES
create table if not exists services (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  icon text,
  image_url text,
  before_image_url text,
  after_image_url text,
  short_desc text,
  sort_order integer default 99,
  created_at timestamptz default now()
);

-- Seed services
insert into services (name, description, icon, sort_order) values
  ('Scaling & Polishing', 'Thorough removal of plaque and tartar buildup. Leaves your teeth clean, smooth, and noticeably brighter after just one session.', 'tooth', 1),
  ('Fillings (Cavity Restoration)', 'Tooth-coloured composite fillings that restore the function and natural appearance of decayed teeth — no silver, no discomfort.', 'fill', 2),
  ('Fluoride & Sealant Application', 'Preventive treatment that strengthens enamel and seals pits in molars to protect against future cavities.', 'shield', 3),
  ('Root Canal Therapy (RCT)', 'Save your natural tooth. Our precision RCT procedure removes infected pulp and seals the canal — effectively and with minimal discomfort.', 'medical', 4),
  ('Caps, Crowns & Bridges', 'Restore damaged or missing teeth with durable ceramic crowns and bridges that match your natural bite and appearance.', 'crown', 5),
  ('Extractions', 'Safe, pain-controlled removal of severely damaged, impacted, or infected teeth. Our technique minimises trauma and speeds up healing.', 'scissors', 6),
  ('Dentures', 'Custom-fitted full and partial dentures that restore your ability to eat, speak, and smile confidently.', 'denture', 7),
  ('Dental Implants', 'The gold standard for tooth replacement. Titanium implants fused into the jawbone provide permanent, natural-feeling teeth that last decades.', 'implant', 8),
  ('Orthodontics (Braces/Aligners)', 'Straighten misaligned teeth with traditional metal braces or virtually invisible clear aligners.', 'braces', 9)
on conflict do nothing;

-- 3. TESTIMONIALS
create table if not exists testimonials (
  id uuid primary key default gen_random_uuid(),
  patient_name text not null,
  location text,
  review_text text,
  rating integer default 5 check (rating between 1 and 5),
  sort_order integer default 99,
  created_at timestamptz default now()
);

insert into testimonials (patient_name, location, review_text, rating, sort_order) values
  ('Rina Akter', 'Chittagong', 'I had severe tooth pain for weeks and was terrified of the dentist. Dr. Hafizur was so patient and understanding. My root canal was completely painless. I came back for implants two months later.', 5, 1),
  ('Karim Uddin', 'GEC, Chittagong', 'My daughter had crooked teeth and we tried aligners here. The transformation in 14 months was incredible. The whole team made her feel comfortable every single visit.', 5, 2),
  ('Nasrin Begum', 'Halishahar, Chittagong', 'The scaling and whitening treatment changed how I smile in photos. The clinic is spotlessly clean and very professional. Booking via WhatsApp was extremely easy.', 5, 3)
on conflict do nothing;

-- 4. FAQ
create table if not exists faqs (
  id uuid primary key default gen_random_uuid(),
  question text not null,
  answer text,
  sort_order integer default 99,
  created_at timestamptz default now()
);

insert into faqs (question, answer, sort_order) values
  ('How do I book an appointment?', 'You can book directly via WhatsApp at +8801633282251, call us, or message our Facebook page. We respond quickly and try to offer same-day or next-day appointments.', 1),
  ('Is root canal treatment painful?', 'Modern root canal treatment with proper anaesthesia is no more uncomfortable than getting a filling. Most patients are surprised by how easy it is.', 2),
  ('How long does a dental implant procedure take?', 'The implant post is placed in a single session (30-60 min). After 3-6 months of healing, the crown is fitted. Total treatment spans a few months but active chair time is minimal.', 3),
  ('Do you treat children?', 'Yes. We welcome patients of all ages. Fluoride application, sealants, and early orthodontic assessments are among the services we offer for children.', 4),
  ('What payment options do you accept?', 'We accept cash and mobile banking (bKash, Nagad). Please contact us if you would like to discuss a payment plan for larger treatments.', 5)
on conflict do nothing;

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

-- Enable RLS on all tables
alter table clinic_settings enable row level security;
alter table services enable row level security;
alter table testimonials enable row level security;
alter table faqs enable row level security;

-- PUBLIC READ (anyone can read)
create policy "Public read clinic_settings" on clinic_settings for select using (true);
create policy "Public read services" on services for select using (true);
create policy "Public read testimonials" on testimonials for select using (true);
create policy "Public read faqs" on faqs for select using (true);

-- AUTHENTICATED WRITE (only logged-in admin can write)
create policy "Auth write clinic_settings" on clinic_settings for all using (auth.role() = 'authenticated');
create policy "Auth write services" on services for all using (auth.role() = 'authenticated');
create policy "Auth write testimonials" on testimonials for all using (auth.role() = 'authenticated');
create policy "Auth write faqs" on faqs for all using (auth.role() = 'authenticated');

-- ============================================================
-- STORAGE BUCKET
-- Run separately in SQL editor
-- ============================================================

-- Create storage bucket for images
insert into storage.buckets (id, name, public)
values ('dental-images', 'dental-images', true)
on conflict (id) do nothing;

-- Public read policy for storage
create policy "Public read dental-images"
on storage.objects for select
using (bucket_id = 'dental-images');

-- Authenticated upload policy
create policy "Auth upload dental-images"
on storage.objects for insert
with check (bucket_id = 'dental-images' and auth.role() = 'authenticated');

create policy "Auth update dental-images"
on storage.objects for update
using (bucket_id = 'dental-images' and auth.role() = 'authenticated');

create policy "Auth delete dental-images"
on storage.objects for delete
using (bucket_id = 'dental-images' and auth.role() = 'authenticated');
