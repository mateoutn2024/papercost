-- Public read access for reference catalog only

drop policy if exists "Authenticated users can read materials"
on public.materials;

create policy "Public can read materials"
on public.materials
for select
to anon, authenticated
using (true);

drop policy if exists "Authenticated users can read suppliers"
on public.suppliers;

create policy "Public can read suppliers"
on public.suppliers
for select
to anon, authenticated
using (true);

drop policy if exists "Authenticated users can read supplier products"
on public.supplier_products;

create policy "Public can read supplier products"
on public.supplier_products
for select
to anon, authenticated
using (true);

drop policy if exists "Authenticated users can read reference prices"
on public.material_prices;

create policy "Public can read reference prices"
on public.material_prices
for select
to anon, authenticated
using (true);