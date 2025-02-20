# -----------------------------
# Etapa 1: Build de la aplicación orders-ms
# -----------------------------
    FROM node:22-alpine AS builder
    WORKDIR /app
    
    # Copia package.json y package-lock.json (si existe)
    COPY package*.json ./
    
    # Instala todas las dependencias necesarias (incluidas devDependencies)
    RUN npm install
    
    # Copia el resto del código fuente
    COPY . .
    
    # Ejecuta el proceso de build
    RUN npm run build
    
    # -----------------------------
    # Etapa 2: Imagen de producción para orders-ms
    # -----------------------------
    FROM node:22-alpine
    WORKDIR /app
    
    # Copia el package.json para instalar solo las dependencias de producción
    COPY package*.json ./
    
    # Instala solo las dependencias de producción
    RUN npm install --production
    
    # Copia la carpeta 'dist' generada en la etapa de build
    COPY --from=builder /app/dist ./dist
    
    # 🔹 Copia la carpeta prisma/ para que exista en producción
    COPY --from=builder /app/prisma ./prisma
    
    # 🔹 Genera el cliente de Prisma en producción
    RUN npx prisma generate
    
    # Expone el puerto en el que corre la aplicación
    EXPOSE 3002
    
    # Comando para iniciar la aplicación
    CMD ["node", "dist/main.js"]
