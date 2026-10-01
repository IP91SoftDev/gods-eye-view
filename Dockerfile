FROM node:24.14.0-bookworm-slim

WORKDIR /app

# Puppeteer is a devDependency used only by local QA scripts; its postinstall
# browser download is unnecessary (and network-heavy) for the deployed image.
ENV PUPPETEER_SKIP_DOWNLOAD=true

COPY package.json package-lock.json ./
RUN npm ci --include=dev

COPY . .

ENV HOST=0.0.0.0
ENV PORT=3000

EXPOSE 3000

# Build at startup so Coolify-provided runtime environment values (e.g.
# GOOGLE_MAPS_API_KEY, CESIUM_ION_TOKEN) reach the generated browser bundle,
# then run the existing Vite preview server with its provider middleware.
CMD ["sh", "-c", "npm run build && exec node node_modules/vite/bin/vite.js preview --host 0.0.0.0 --port 3000 --strictPort"]
