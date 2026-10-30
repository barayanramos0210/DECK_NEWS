# Esquema de Base de Datos - Firestore

## Colecciones

### 1. `usuarios`
- `uid` (Document ID)
- `nombre`: String
- `email`: String
- `fecha_registro`: Timestamp
- `preferencias`: Map

### 2. `analisis`
- `id` (Document ID)
- `userId`: String (Referencia a usuarios)
- `url`: String
- `texto_original`: String
- `resumen_neutral`: String
- `categorias_aplicables`: List<String>
- `datos_analisis`: Map (Almacena los hallazgos de las 4 categorías)
- `fecha_analisis`: Timestamp

### 3. `retroalimentacion`
- `id` (Document ID)
- `analisisId`: String (Referencia a analisis)
- `userId`: String (Referencia a usuarios)
- `util`: Boolean
- `no_aplicaba`: Boolean
- `comentario`: String
- `fecha`: Timestamp

### 4. `chats`
- `id` (Document ID)
- `analisisId`: String (Referencia a analisis)
- `userId`: String (Referencia a usuarios)
- `mensajes`: List<Map> 
    - `role`: String ("user" | "assistant")
    - `content`: String
    - `timestamp`: Timestamp
