
import { useState } from 'react'
import {
  LayoutDashboard,
  Package,
  Layers3,
  Factory,
  Calculator,
  Tags,
  ChartNoAxesCombined,
  Settings,
  Search,
  Bell,
  Plus,
  ArrowUpRight,
  ArrowDownRight,
  Wallet,
  Boxes,
  Clock3,
  Menu,
  X,
} from 'lucide-react'

import Materials from './pages/Materials'
import './App.css'

const navigation = [
  { label: 'Inicio', icon: LayoutDashboard },
  { label: 'Materiales', icon: Layers3 },
  { label: 'Productos', icon: Package },
  { label: 'Producción', icon: Factory },
  { label: 'Calculadora de costos', icon: Calculator },
  { label: 'Precios y rentabilidad', icon: Tags },
  { label: 'Reportes', icon: ChartNoAxesCombined },
]

function App() {
  const [activePage, setActivePage] = useState('Inicio')
  const [sidebarOpen, setSidebarOpen] = useState(false)

  return (
    <div className="app-container">
      <aside className={`sidebar ${sidebarOpen ? 'sidebar-open' : ''}`}>
        <div className="brand">
          <div className="brand-symbol">P</div>
          <div>
            <h1>PaperCost</h1>
            <span>GESTIÓN INTELIGENTE</span>
          </div>

          <button
            className="mobile-close"
            onClick={() => setSidebarOpen(false)}
            aria-label="Cerrar menú"
          >
            <X size={20} />
          </button>
        </div>

        <div className="business-selector">
          <div className="business-avatar">P</div>
          <div>
            <strong>Mi emprendimiento</strong>
            <span>Plan inicial</span>
          </div>
        </div>

        <span className="menu-caption">MENÚ PRINCIPAL</span>

        <nav className="navigation">
          {navigation.map((item) => {
            const Icon = item.icon

            return (
              <button
                key={item.label}
                className={`nav-item ${
                  activePage === item.label ? 'active' : ''
                }`}
                onClick={() => {
                  setActivePage(item.label)
                  setSidebarOpen(false)
                }}
              >
                <Icon size={19} strokeWidth={1.8} />
                <span>{item.label}</span>
              </button>
            )
          })}
        </nav>

        <div className="sidebar-bottom">
          <button className="nav-item">
            <Settings size={19} />
            <span>Configuración</span>
          </button>

          <div className="profile">
            <div className="profile-avatar">M</div>
            <div>
              <strong>Mi cuenta</strong>
              <span>Administrador</span>
            </div>
          </div>
        </div>
      </aside>

      {sidebarOpen && (
        <div
          className="sidebar-overlay"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      <main className="main-content">
        <header className="topbar">
          <button
            className="mobile-menu"
            onClick={() => setSidebarOpen(true)}
            aria-label="Abrir menú"
          >
            <Menu size={22} />
          </button>

          <div className="breadcrumb">
            <span>PaperCost</span>
            <span className="breadcrumb-divider">/</span>
            <strong>{activePage}</strong>
          </div>

          <div className="topbar-actions">
            <button className="icon-button" aria-label="Buscar">
              <Search size={19} />
            </button>

            <button
              className="icon-button notification"
              aria-label="Notificaciones"
            >
              <Bell size={19} />
              <span />
            </button>

            <div className="topbar-avatar">M</div>
          </div>
        </header>

        <div className="page-content">
          {activePage === 'Materiales' ? (
            <Materials />
          ) : (
            <>
              <section className="welcome-section">
                <div>
                  <span className="eyebrow">PANEL DE CONTROL</span>

                  <h2>
                    {activePage === 'Inicio'
                      ? '¡Hola! Bienvenido a PaperCost'
                      : activePage}
                  </h2>

                  <p>
                    {activePage === 'Inicio'
                      ? 'Este es el resumen general de tu emprendimiento.'
                      : `Desde aquí podrás gestionar ${activePage.toLowerCase()}.`}
                  </p>
                </div>

                <button className="primary-button">
                  <Plus size={18} />
                  Nuevo producto
                </button>
              </section>

              <section className="stats-grid">
                <article className="stat-card">
                  <div className="stat-header">
                    <span>Productos registrados</span>
                    <div className="stat-icon teal">
                      <Package size={20} />
                    </div>
                  </div>

                  <strong className="stat-value">24</strong>

                  <div className="stat-footer">
                    <span className="positive">
                      <ArrowUpRight size={15} /> 8,5%
                    </span>
                    <span>vs. período anterior</span>
                  </div>
                </article>

                <article className="stat-card">
                  <div className="stat-header">
                    <span>Materiales registrados</span>
                    <div className="stat-icon blue">
                      <Boxes size={20} />
                    </div>
                  </div>

                  <strong className="stat-value">38</strong>

                  <div className="stat-footer">
                    <span className="neutral">Inventario</span>
                    <span>materiales activos</span>
                  </div>
                </article>

                <article className="stat-card">
                  <div className="stat-header">
                    <span>Costo promedio</span>
                    <div className="stat-icon orange">
                      <Wallet size={20} />
                    </div>
                  </div>

                  <strong className="stat-value">$ 8.450</strong>

                  <div className="stat-footer">
                    <span className="neutral">Por unidad</span>
                    <span>valores ilustrativos</span>
                  </div>
                </article>

                <article className="stat-card">
                  <div className="stat-header">
                    <span>Margen promedio</span>
                    <div className="stat-icon purple">
                      <ChartNoAxesCombined size={20} />
                    </div>
                  </div>

                  <strong className="stat-value">42%</strong>

                  <div className="stat-footer">
                    <span className="positive">
                      <ArrowUpRight size={15} /> 3,2%
                    </span>
                    <span>vs. período anterior</span>
                  </div>
                </article>
              </section>

              <section className="dashboard-grid">
                <article className="panel products-panel">
                  <div className="panel-heading">
                    <div>
                      <h3>Productos recientes</h3>
                      <p>Últimos productos de tu catálogo</p>
                    </div>

                    <button className="text-button">
                      Ver todos <ArrowUpRight size={15} />
                    </button>
                  </div>

                  <div className="table-wrapper">
                    <table>
                      <thead>
                        <tr>
                          <th>PRODUCTO</th>
                          <th>COSTO UNITARIO</th>
                          <th>PRECIO DE VENTA</th>
                          <th>ESTADO</th>
                        </tr>
                      </thead>

                      <tbody>
                        <tr>
                          <td>
                            <div className="product-name">
                              <span className="product-dot mint" />
                              Figura decorativa
                            </div>
                          </td>
                          <td>$ 8.450</td>
                          <td>$ 15.900</td>
                          <td>
                            <span className="status-badge">Activo</span>
                          </td>
                        </tr>

                        <tr>
                          <td>
                            <div className="product-name">
                              <span className="product-dot peach" />
                              Animal papercraft
                            </div>
                          </td>
                          <td>$ 6.200</td>
                          <td>$ 12.500</td>
                          <td>
                            <span className="status-badge">Activo</span>
                          </td>
                        </tr>

                        <tr>
                          <td>
                            <div className="product-name">
                              <span className="product-dot lavender" />
                              Objeto geométrico
                            </div>
                          </td>
                          <td>$ 4.800</td>
                          <td>$ 9.500</td>
                          <td>
                            <span className="status-badge">Activo</span>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>

                  <p className="demo-note">
                    Datos de ejemplo. Todavía no están conectados a una base
                    de datos.
                  </p>
                </article>

                <article className="panel activity-panel">
                  <div className="panel-heading">
                    <div>
                      <h3>Actividad reciente</h3>
                      <p>Movimientos de tu emprendimiento</p>
                    </div>

                    <Clock3 size={19} className="muted-icon" />
                  </div>

                  <div className="activity-item">
                    <div className="activity-icon teal">
                      <Package size={17} />
                    </div>

                    <div>
                      <strong>Producto creado</strong>
                      <span>Figura decorativa</span>
                      <small>Hace 2 horas</small>
                    </div>
                  </div>

                  <div className="activity-item">
                    <div className="activity-icon orange">
                      <Layers3 size={17} />
                    </div>

                    <div>
                      <strong>Material actualizado</strong>
                      <span>Cartulina blanca 200 g</span>
                      <small>Ayer</small>
                    </div>
                  </div>

                  <div className="activity-item">
                    <div className="activity-icon blue">
                      <Calculator size={17} />
                    </div>

                    <div>
                      <strong>Costo calculado</strong>
                      <span>Animal papercraft</span>
                      <small>Hace 2 días</small>
                    </div>
                  </div>
                </article>
              </section>

              <section className="bottom-grid">
                <article className="quick-card">
                  <div className="quick-icon">
                    <Calculator size={22} />
                  </div>

                  <div>
                    <h3>Calculá tus costos</h3>
                    <p>
                      Conocé cuánto cuesta fabricar cada producto.
                    </p>
                  </div>

                  <button
                    className="quick-action"
                    aria-label="Ir a calculadora"
                    onClick={() => setActivePage('Calculadora de costos')}
                  >
                    <ArrowUpRight size={20} />
                  </button>
                </article>

                <article className="quick-card">
                  <div className="quick-icon orange">
                    <Tags size={22} />
                  </div>

                  <div>
                    <h3>Definí tus precios</h3>
                    <p>Analizá márgenes y rentabilidad.</p>
                  </div>

                  <button
                    className="quick-action"
                    aria-label="Ir a precios"
                    onClick={() => setActivePage('Precios y rentabilidad')}
                  >
                    <ArrowDownRight size={20} />
                  </button>
                </article>
              </section>

              <footer className="page-footer">
                <span>
                  PaperCost · Gestión inteligente para emprendimientos
                  papercraft
                </span>
                <span>Versión inicial · 2026</span>
              </footer>
            </>
          )}
        </div>
      </main>
    </div>
  )
}

export default App
