
import { supabase } from '../lib/supabase'

export interface Material {
  id: string
  name: string
  category: string
  brand: string | null
  grammage: number | null
  width_mm: number | null
  height_mm: number | null
  thickness_mm: number | null
  base_unit: string
  description: string | null
  created_at: string
}

export async function getMaterials(): Promise<Material[]> {
  const { data, error } = await supabase
    .from('materials')
    .select('*')
    .order('category', { ascending: true })
    .order('name', { ascending: true })

  if (error) {
    console.error('Error al consultar materiales:', error.message)
    throw new Error('No se pudieron cargar los materiales.')
  }

  return data ?? []
}

export async function createMaterial(
  material: Omit<Material, 'id' | 'created_at'>
): Promise<Material> {
  const { data, error } = await supabase
    .from('materials')
    .insert(material)
    .select()
    .single()

  if (error) {
    console.error('Error al crear material:', error.message)
    throw new Error('No se pudo crear el material.')
  }

  return data
}
