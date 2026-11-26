
import { useEffect, useState } from 'react'
import { Search, Plus, RefreshCw, Package, AlertCircle } from 'lucide-react'
import { getMaterials, type Material } from '../services/materialService'
import './Materials.css'

function Materials() {
  const [materials, setMaterials] = useState<Material[]>([])
  const [search, setSearch] = useState('')
  const [category, setCategory] = useState('Todas')
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    let active = true

    async function fetchMaterials() {
      try {
        const data = await getMaterials()

        if (active) {
          setMaterials(data)
          setError('')
        }
      } catch {
        if (active) {
          setError('No pudimos cargar los materiales. Intentá nuevamente.')
        }
      } finally {
        if (active) {
          setLoading(false)
        }
      }
    }

    void fetchMaterials()

    return () => {
      active = false
    }
  }, [])

  async function loadMaterials() {
    try {
      setLoading(true)
      setError('')
      const data = await getMaterials()
      setMaterials(data)
    } catch {
      setError('No pudimos cargar los materiales. Intentá nuevamente.')
    } finally {
      setLoading(false)
    }
  }

  const categories = [
    'Todas',
    ...Array.from(new Set(materials.map((item) => item.category))),
  ]

  const filteredMaterials = materials.filter((item) => {
    const matchesSearch = [
      item.name,
      item.brand ?? '',
      item.category,
    ].join(' ').toLowerCase().includes(search.toLowerCase())

    const matchesCategory =
      category === 'Todas' || category === item.category

    return matchesSearch && matchesCategory
  })

  return (
    <section className="materials-page">
      <div className="materials-heading">
        <div>
          <span className="eyebrow">CATÁLOGO DE INSUMOS</span>
          <h2>Materiales</h2>
          <p>Consultá los materiales disponibles para tus producciones.</p>
        </div>

        <button className="primary-button" disabled>
          <Plus size={18} />
          Nuevo material
        </button>
      </div>

      <div className="materials-summary">
        <div className="materials-summary-icon">
          <Package size={22} />
        </div>
        <div>
          <strong>{materials.length}</strong>
          <span>Materiales en el catálogo</span>
        </div>
      </div>

      <div className="materials-toolbar">
        <div className="materials-search">
          <Search size={18} />
          <input
            type="search"
            placeholder="Buscar material o marca..."
            value={search}
            onChange={(event) => setSearch(event.target.value)}
          />
        </div>

        <select
          value={category}
          onChange={(event) => setCategory(event.target.value)}
        >
          {categories.map((item) => (
            <option key={item} value={item}>{item}</option>
          ))}
        </select>

        <button
          className="materials-refresh"
          onClick={() => void loadMaterials()}
          disabled={loading}
          aria-label="Actualizar materiales"
        >
          <RefreshCw size={18} />
        </button>
      </div>

      {loading ? (
        <div className="materials-message">Cargando materiales...</div>
      ) : error ? (
        <div className="materials-message error">
          <AlertCircle size={19} />
          <span>{error}</span>
          <button onClick={() => void loadMaterials()}>Reintentar</button>
        </div>
      ) : filteredMaterials.length === 0 ? (
        <div className="materials-message">
          No se encontraron materiales.
        </div>
      ) : (
        <div className="materials-table-wrapper">
          <table className="materials-table">
            <thead>
              <tr>
                <th>MATERIAL</th>
                <th>CATEGORÍA</th>
                <th>MARCA</th>
                <th>GRAMAJE</th>
                <th>UNIDAD</th>
              </tr>
            </thead>
            <tbody>
              {filteredMaterials.map((material) => (
                <tr key={material.id}>
                  <td>
                    <strong>{material.name}</strong>
                    {material.description && (
                      <small>{material.description}</small>
                    )}
                  </td>
                  <td>
                    <span className="material-category">
                      {material.category}
                    </span>
                  </td>
                  <td>{material.brand || '—'}</td>
                  <td>
                    {material.grammage !== null
                      ? `${material.grammage} g/m²`
                      : '—'}
                  </td>
                  <td>{material.base_unit}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      <p className="materials-footnote">
        Catálogo general de referencia. Los precios de proveedores se
        consultarán en una sección específica.
      </p>
    </section>
  )
}

export default Materials
