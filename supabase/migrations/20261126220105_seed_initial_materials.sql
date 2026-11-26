
-- PAPERCOST: INITIAL REAL MATERIAL CATALOG
-- Source consultation: 2026-11-26
-- Currency: ARS
-- Prices are references, not guaranteed quotations.

do $$
declare
  supplier_central uuid;
  supplier_limite uuid;
  material_sta uuid;
  material_plasticola uuid;
  material_illustration_150 uuid;
  material_illustration_220 uuid;
  product_id uuid;
begin

  -- SUPPLIERS
  insert into public.suppliers (name, website, country)
  select 'Central Mayorista Librería',
         'https://centralmayorista.com.ar',
         'Argentina'
  where not exists (
    select 1 from public.suppliers
    where name = 'Central Mayorista Librería'
  );

  insert into public.suppliers (name, website, country)
  select 'Gráfica Límite',
         'https://graficalimite.com.ar',
         'Argentina'
  where not exists (
    select 1 from public.suppliers
    where name = 'Gráfica Límite'
  );

  select id into supplier_central
  from public.suppliers
  where name = 'Central Mayorista Librería'
  limit 1;

  select id into supplier_limite
  from public.suppliers
  where name = 'Gráfica Límite'
  limit 1;

  -- MATERIALS
  insert into public.materials
    (name, category, brand, grammage, base_unit, description)
  select 'Adhesivo vinílico STA',
         'Adhesivos', 'STA', null, 'ml',
         'Adhesivo vinílico para papel y cartón'
  where not exists (
    select 1 from public.materials
    where name = 'Adhesivo vinílico STA'
  );

  insert into public.materials
    (name, category, brand, grammage, base_unit, description)
  select 'Adhesivo vinílico Plasticola',
         'Adhesivos', 'Plasticola', null, 'g',
         'Adhesivo vinílico para papel y cartón'
  where not exists (
    select 1 from public.materials
    where name = 'Adhesivo vinílico Plasticola'
  );

  insert into public.materials
    (name, category, grammage, base_unit, description)
  select 'Papel ilustración brillante A4',
         'Papeles', 150, 'sheet',
         'Papel A4 brillante, paquete de 100 hojas'
  where not exists (
    select 1 from public.materials
    where name = 'Papel ilustración brillante A4'
      and grammage = 150
  );

  insert into public.materials
    (name, category, grammage, base_unit, description)
  select 'Papel ilustración mate A4',
         'Papeles', 220, 'sheet',
         'Papel A4 mate, paquete de 100 hojas'
  where not exists (
    select 1 from public.materials
    where name = 'Papel ilustración mate A4'
      and grammage = 220
  );

  select id into material_sta
  from public.materials
  where name = 'Adhesivo vinílico STA'
  limit 1;

  select id into material_plasticola
  from public.materials
  where name = 'Adhesivo vinílico Plasticola'
  limit 1;

  select id into material_illustration_150
  from public.materials
  where name = 'Papel ilustración brillante A4'
    and grammage = 150
  limit 1;

  select id into material_illustration_220
  from public.materials
  where name = 'Papel ilustración mate A4'
    and grammage = 220
  limit 1;

  -- SUPPLIER PRODUCTS: CENTRAL MAYORISTA

  insert into public.supplier_products
    (supplier_id, material_id, product_name,
     package_description, package_quantity, package_unit, product_url)
  select supplier_central, material_sta,
         'Adhesivo vinílico STA 250 cc',
         'Envase de 250 cc', 250, 'ml',
         'https://centralmayorista.com.ar/escolar/adhesivos-y-pegamentos/adhesivos-vinilicos/'
  where not exists (
    select 1 from public.supplier_products
    where supplier_id = supplier_central
      and product_name = 'Adhesivo vinílico STA 250 cc'
  );

  insert into public.supplier_products
    (supplier_id, material_id, product_name,
     package_description, package_quantity, package_unit, product_url)
  select supplier_central, material_sta,
         'Adhesivo vinílico STA 1000 cc',
         'Envase de 1000 cc', 1000, 'ml',
         'https://centralmayorista.com.ar/escolar/adhesivos-y-pegamentos/adhesivos-vinilicos/'
  where not exists (
    select 1 from public.supplier_products
    where supplier_id = supplier_central
      and product_name = 'Adhesivo vinílico STA 1000 cc'
  );

  insert into public.supplier_products
    (supplier_id, material_id, product_name,
     package_description, package_quantity, package_unit, product_url)
  select supplier_central, material_plasticola,
         'Adhesivo vinílico Plasticola 237 g',
         'Envase de 237 g', 237, 'g',
         'https://centralmayorista.com.ar/escolar/adhesivos-y-pegamentos/adhesivos-vinilicos/'
  where not exists (
    select 1 from public.supplier_products
    where supplier_id = supplier_central
      and product_name = 'Adhesivo vinílico Plasticola 237 g'
  );

  -- SUPPLIER PRODUCTS: GRÁFICA LÍMITE

  insert into public.supplier_products
    (supplier_id, material_id, product_name,
     package_description, package_quantity, package_unit, product_url)
  select supplier_limite, material_illustration_150,
         'Papel ilustración brillante A4 150 g - 100 hojas',
         'Paquete de 100 hojas', 100, 'sheet',
         'https://graficalimite.com.ar/comprar-insumos/papeles-sin-adhesivo/papel-ilustracion/papel-ilustracion-a4/'
  where not exists (
    select 1 from public.supplier_products
    where supplier_id = supplier_limite
      and product_name = 'Papel ilustración brillante A4 150 g - 100 hojas'
  );

  insert into public.supplier_products
    (supplier_id, material_id, product_name,
     package_description, package_quantity, package_unit, product_url)
  select supplier_limite, material_illustration_220,
         'Papel ilustración mate A4 220 g - 100 hojas',
         'Paquete de 100 hojas', 100, 'sheet',
         'https://graficalimite.com.ar/comprar-insumos/papeles-sin-adhesivo/papel-ilustracion/papel-ilustracion-a4/'
  where not exists (
    select 1 from public.supplier_products
    where supplier_id = supplier_limite
      and product_name = 'Papel ilustración mate A4 220 g - 100 hojas'
  );

  -- PRICE HISTORY
  -- Values taken from the published listings found during research.

  for product_id in
    select id from public.supplier_products
    where supplier_id = supplier_central
      and product_name in (
        'Adhesivo vinílico STA 250 cc',
        'Adhesivo vinílico STA 1000 cc',
        'Adhesivo vinílico Plasticola 237 g'
      )
  loop
    if not exists (
      select 1 from public.material_prices
      where supplier_product_id = product_id
        and observed_at::date = current_date
    ) then
      insert into public.material_prices
        (supplier_product_id, price, currency, observed_at, source_url, notes)
      select product_id,
        case sp.product_name
          when 'Adhesivo vinílico STA 250 cc' then 1933
          when 'Adhesivo vinílico STA 1000 cc' then 6768
          when 'Adhesivo vinílico Plasticola 237 g' then 5073
        end,
        'ARS', now(),
        'https://centralmayorista.com.ar/escolar/adhesivos-y-pegamentos/adhesivos-vinilicos/',
        'Precio publicado consultado el 26/11/2026. Verificar antes de comprar.'
      from public.supplier_products sp
      where sp.id = product_id;
    end if;
  end loop;

  for product_id in
    select id from public.supplier_products
    where supplier_id = supplier_limite
      and product_name in (
        'Papel ilustración brillante A4 150 g - 100 hojas',
        'Papel ilustración mate A4 220 g - 100 hojas'
      )
  loop
    if not exists (
      select 1 from public.material_prices
      where supplier_product_id = product_id
        and observed_at::date = current_date
    ) then
      insert into public.material_prices
        (supplier_product_id, price, currency, observed_at, source_url, notes)
      select product_id,
        case sp.product_name
          when 'Papel ilustración brillante A4 150 g - 100 hojas' then 6125
          when 'Papel ilustración mate A4 220 g - 100 hojas' then 9375
        end,
        'ARS', now(),
        'https://graficalimite.com.ar/comprar-insumos/papeles-sin-adhesivo/papel-ilustracion/papel-ilustracion-a4/',
        'Precio publicado consultado el 26/11/2026. Verificar antes de comprar.'
      from public.supplier_products sp
      where sp.id = product_id;
    end if;
  end loop;

end $$;
