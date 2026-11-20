# Dashboard comercial con Electron y Supabase

## Ejecutar

1. Instala Node.js si aún no está instalado.
2. En la carpeta del proyecto ejecuta `npm install` una vez.
3. Ejecuta `npm start` para abrir el programa de escritorio.
4. En **Configuración**, pega la URL de tu proyecto Supabase y una clave pública `publishable` o `anon`.

La aplicación consulta las tablas `CLIENTES`, `PRODUCTOS` y `VENTAS` mediante la API REST de Supabase. Usa la clave pública únicamente; nunca pegues una clave `service_role` o secreta. Las consultas requieren políticas RLS que permitan la lectura correspondiente.

## Datos que utiliza

Los indicadores cuentan los registros devueltos por cada tabla y suman el importe de las ventas. Para asociar registros, se reconocen nombres habituales como `id_cliente`/`cliente_id`, `id_producto`/`producto_id`, y campos `nombre`, `fecha`, `cantidad`, `importe` o `total`. Las categorías se agrupan desde `categoria` y el inventario se ordena por `precio` o `existencia` cuando esos campos existen.

Las tres gráficas se construyen en Canvas usando los resultados recibidos: importe de ventas por mes, productos por categoría y cantidad vendida por producto. Si el esquema de la práctica 4 emplea otros nombres de columnas, ajusta los alias candidatos en `renderer.js` para que coincidan con tu esquema. La búsqueda filtra la sección activa; ventas admite fechas desde/hasta y productos permite ordenar.

## Seguridad y alcance

Electron mantiene `contextIsolation` habilitado, `nodeIntegration` deshabilitado y el sandbox del renderer activo. La URL y la clave pública se guardan en el almacenamiento local de esta app en el equipo para poder reconectar al volver a abrirla. Supabase debe limitar el acceso con RLS; una clave pública no reemplaza esas políticas.

El proyecto no incluye registros de demostración: sin conexión, las métricas permanecen vacías y la aplicación muestra el error de consulta.

## Evidencia y reflexión

Para las evidencias de entrega, captura la ventana del dashboard conectado y las secciones de clientes, productos y ventas con datos reales. Compara los totales con consultas SQL en Supabase y prueba búsqueda, fechas, ordenamiento y actualización.

Herramientas usadas: Electron, HTML, CSS, JavaScript, Canvas 2D y la API REST de Supabase. La reflexión individual de aprendizaje debe redactarla cada integrante a partir de su experiencia con el esquema, la conexión y las pruebas de su base de datos.
