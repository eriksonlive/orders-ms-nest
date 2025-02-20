# -----------------------------
# Etapa 1: Build de la aplicación orders-ms
# -----------------------------
    FROM node:22-alpine AS builder
    WORKDIR /app
    
    # Copia el package.json y package-lock.json (si existe)
    COPY package*.json ./
    
    # Instala todas las dependencias necesarias para construir la aplicación
    RUN npm install
    
    # Copia el resto del código fuente al contenedor
    COPY . .
    
    # Ejecuta el proceso de build para generar la carpeta 'dist'
    RUN npm run build
    
    # Genera el cliente de Prisma (si es necesario)
    RUN npx prisma generate
    
    # -----------------------------
    # Etapa 2: Imagen de producción para orders-ms
    # -----------------------------
    FROM node:22-alpine
    WORKDIR /app
    
    # Copia el package.json para instalar sólo las dependencias de producción
    COPY package*.json ./
    
    # Instala las dependencias de producción
    RUN npm install --production
    
    # Copia la carpeta 'dist' generada en la etapa de build a la imagen final
    COPY --from=builder /app/dist ./dist
    
    # Expone el puerto en el que corre la aplicación (ajusta según tu configuración; aquí se usa 3002)
    EXPOSE 3002
    
    # Comando para iniciar la aplicación; asegúrate de que en package.json el script "start" ejecute, por ejemplo, "node dist/main.js"
    CMD ["npm", "start"]
    