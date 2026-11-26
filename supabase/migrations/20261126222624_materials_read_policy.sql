
-- PaperCost: permisos de lectura del catálogo general.

GRANT SELECT ON TABLE public.materials TO anon;
GRANT SELECT ON TABLE public.materials TO authenticated;

ALTER TABLE public.materials ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can read materials"
ON public.materials;

CREATE POLICY "Public can read materials"
ON public.materials
FOR SELECT
TO anon, authenticated
USING (true);
