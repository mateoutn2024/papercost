-- =====================================================
-- PAPERCOST - INITIAL DATABASE SCHEMA
-- =====================================================

create extension if not exists pgcrypto;

-- 1. USER PROFILES
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 2. BUSINESSES
create table public.businesses (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  currency text not null default 'ARS',
  created_by uuid not null references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 3. BUSINESS MEMBERSHIPS
create table public.business_members (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null references public.businesses(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'editor'
    check (role in ('owner', 'admin', 'editor', 'viewer')),
  created_at timestamptz not null default now(),
  unique (business_id, user_id)
);

-- Helper function for tenant isolation
create or replace function public.is_business_member(
  target_business_id uuid
)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.business_members bm
    where bm.business_id = target_business_id
      and bm.user_id = (select auth.uid())
  );
$$;

-- 4. SUPPLIERS (PUBLIC REFERENCE CATALOG)
create table public.suppliers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  website text,
  country text not null default 'Argentina',
  created_at timestamptz not null default now()
);

-- 5. MATERIALS (GENERAL CATALOG)
create table public.materials (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null,
  brand text,
  grammage numeric(10,2),
  width_mm numeric(10,2),
  height_mm numeric(10,2),
  thickness_mm numeric(10,2),
  base_unit text not null default 'unit',
  description text,
  created_at timestamptz not null default now()
);

-- 6. SUPPLIER PRODUCTS
create table public.supplier_products (
  id uuid primary key default gen_random_uuid(),
  supplier_id uuid not null references public.suppliers(id),
  material_id uuid references public.materials(id),
  product_name text not null,
  product_code text,
  package_description text,
  package_quantity numeric(12,3),
  package_unit text,
  product_url text,
  created_at timestamptz not null default now()
);

-- 7. REFERENCE PRICE HISTORY
create table public.material_prices (
  id uuid primary key default gen_random_uuid(),
  supplier_product_id uuid not null references public.supplier_products(id),
  price numeric(14,2) not null check (price >= 0),
  currency text not null default 'ARS',
  observed_at timestamptz not null default now(),
  source_url text not null,
  notes text,
  created_at timestamptz not null default now()
);

-- 8. MATERIALS USED BY EACH BUSINESS
create table public.business_materials (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null references public.businesses(id) on delete cascade,
  material_id uuid references public.materials(id),
  custom_name text,
  supplier_id uuid references public.suppliers(id),
  purchase_price numeric(14,2) not null check (purchase_price >= 0),
  purchase_quantity numeric(12,3) not null check (purchase_quantity > 0),
  purchase_unit text not null,
  currency text not null default 'ARS',
  purchase_date date not null default current_date,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (material_id is not null or custom_name is not null)
);

-- 9. PRODUCTS MADE BY EACH BUSINESS
create table public.products (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null references public.businesses(id) on delete cascade,
  name text not null,
  description text,
  sku text,
  status text not null default 'active'
    check (status in ('active', 'inactive', 'archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (business_id, sku)
);

-- =====================================================
-- ROW LEVEL SECURITY
-- =====================================================

alter table public.profiles enable row level security;
alter table public.businesses enable row level security;
alter table public.business_members enable row level security;
alter table public.suppliers enable row level security;
alter table public.materials enable row level security;
alter table public.supplier_products enable row level security;
alter table public.material_prices enable row level security;
alter table public.business_materials enable row level security;
alter table public.products enable row level security;

-- Profiles: each user accesses their own profile
create policy "Users can view own profile"
on public.profiles for select
to authenticated
using (id = (select auth.uid()));

create policy "Users can insert own profile"
on public.profiles for insert
to authenticated
with check (id = (select auth.uid()));

create policy "Users can update own profile"
on public.profiles for update
to authenticated
using (id = (select auth.uid()))
with check (id = (select auth.uid()));

-- Businesses
create policy "Members can view their businesses"
on public.businesses for select
to authenticated
using (public.is_business_member(id));

create policy "Authenticated users can create businesses"
on public.businesses for insert
to authenticated
with check (created_by = (select auth.uid()));

create policy "Owners and admins can update businesses"
on public.businesses for update
to authenticated
using (
  exists (
    select 1 from public.business_members bm
    where bm.business_id = id
      and bm.user_id = (select auth.uid())
      and bm.role in ('owner', 'admin')
  )
);

-- Business memberships
create policy "Members can view memberships"
on public.business_members for select
to authenticated
using (public.is_business_member(business_id));

create policy "Creator can add themselves as owner"
on public.business_members for insert
to authenticated
with check (
  user_id = (select auth.uid())
  and role = 'owner'
  and exists (
    select 1 from public.businesses b
    where b.id = business_id
      and b.created_by = (select auth.uid())
  )
);

create policy "Owners and admins can add members"
on public.business_members for insert
to authenticated
with check (
  exists (
    select 1 from public.business_members bm
    where bm.business_id = business_id
      and bm.user_id = (select auth.uid())
      and bm.role in ('owner', 'admin')
  )
);

create policy "Owners and admins can update memberships"
on public.business_members for update
to authenticated
using (
  exists (
    select 1 from public.business_members bm
    where bm.business_id = business_id
      and bm.user_id = (select auth.uid())
      and bm.role in ('owner', 'admin')
  )
);

create policy "Owners and admins can remove memberships"
on public.business_members for delete
to authenticated
using (
  exists (
    select 1 from public.business_members bm
    where bm.business_id = business_id
      and bm.user_id = (select auth.uid())
      and bm.role in ('owner', 'admin')
  )
);

-- Public reference catalog: read-only for authenticated users
create policy "Authenticated users can read suppliers"
on public.suppliers for select
to authenticated using (true);

create policy "Authenticated users can read materials"
on public.materials for select
to authenticated using (true);

create policy "Authenticated users can read supplier products"
on public.supplier_products for select
to authenticated using (true);

create policy "Authenticated users can read reference prices"
on public.material_prices for select
to authenticated using (true);

-- Business-specific materials
create policy "Members can view business materials"
on public.business_materials for select
to authenticated
using (public.is_business_member(business_id));

create policy "Editors can add business materials"
on public.business_materials for insert
to authenticated
with check (
  exists (
    select 1 from public.business_members bm
    where bm.business_id = business_id
      and bm.user_id = (select auth.uid())
      and bm.role in ('owner', 'admin', 'editor')
  )
);

create policy "Editors can update business materials"
on public.business_materials for update
to authenticated
using (
  exists (
    select 1 from public.business_members bm
    where bm.business_id = business_id
      and bm.user_id = (select auth.uid())
      and bm.role in ('owner', 'admin', 'editor')
  )
)
with check (public.is_business_member(business_id));

create policy "Admins can delete business materials"
on public.business_materials for delete
to authenticated
using (
  exists (
    select 1 from public.business_members bm
    where bm.business_id = business_id
      and bm.user_id = (select auth.uid())
      and bm.role in ('owner', 'admin')
  )
);

-- Business products
create policy "Members can view business products"
on public.products for select
to authenticated
using (public.is_business_member(business_id));

create policy "Editors can create business products"
on public.products for insert
to authenticated
with check (
  exists (
    select 1 from public.business_members bm
    where bm.business_id = business_id
      and bm.user_id = (select auth.uid())
      and bm.role in ('owner', 'admin', 'editor')
  )
);

create policy "Editors can update business products"
on public.products for update
to authenticated
using (
  exists (
    select 1 from public.business_members bm
    where bm.business_id = business_id
      and bm.user_id = (select auth.uid())
      and bm.role in ('owner', 'admin', 'editor')
  )
)
with check (public.is_business_member(business_id));

create policy "Admins can delete business products"
on public.products for delete
to authenticated
using (
  exists (
    select 1 from public.business_members bm
    where bm.business_id = business_id
      and bm.user_id = (select auth.uid())
      and bm.role in ('owner', 'admin')
  )
);

-- =====================================================
-- INDEXES
-- =====================================================

create index idx_business_members_user
  on public.business_members(user_id);

create index idx_business_members_business
  on public.business_members(business_id);

create index idx_business_materials_business
  on public.business_materials(business_id);

create index idx_products_business
  on public.products(business_id);

create index idx_supplier_products_material
  on public.supplier_products(material_id);

create index idx_material_prices_product_date
  on public.material_prices(supplier_product_id, observed_at desc);


-- =====================================================
-- SECURITY FIX: BUSINESS MEMBERSHIP POLICIES
-- =====================================================

create or replace function public.has_business_role(
  target_business_id uuid,
  allowed_roles text[]
)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.business_members bm
    where bm.business_id = target_business_id
      and bm.user_id = (select auth.uid())
      and bm.role = any(allowed_roles)
  );
$$;

-- Remove policies that directly query business_members
drop policy if exists "Owners and admins can add members"
on public.business_members;

drop policy if exists "Owners and admins can update memberships"
on public.business_members;

drop policy if exists "Owners and admins can remove memberships"
on public.business_members;

-- Recreate policies using the security definer function
create policy "Owners and admins can add members"
on public.business_members
for insert
to authenticated
with check (
  public.has_business_role(
    business_id,
    array['owner', 'admin']::text[]
  )
);

create policy "Owners and admins can update memberships"
on public.business_members
for update
to authenticated
using (
  public.has_business_role(
    business_id,
    array['owner', 'admin']::text[]
  )
)
with check (
  public.has_business_role(
    business_id,
    array['owner', 'admin']::text[]
  )
);

create policy "Owners and admins can remove memberships"
on public.business_members
for delete
to authenticated
using (
  public.has_business_role(
    business_id,
    array['owner', 'admin']::text[]
  )
);