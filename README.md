# DevBox - Complete Development Environment

A lightweight, containerized development environment with PHP, Node.js, Oracle OCI8 support, and build tools.

## 🚀 Quick Start

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -p 3000:3000 -p 8000:8000 -p 8080:8080 -p 5173:5173 \
  azharizkita/devbox:latest
```

This command will:

- Start an interactive terminal session
- Mount your current directory to `/workspace` inside the container
- Expose ports for common development servers
- Remove the container when you exit (clean up)

## 📦 What's Included

### Languages & Runtimes

- **PHP 8.2** with CLI, FPM, and essential extensions
- **Node.js** (latest) with npm
- **Oracle OCI8** support (x86_64 only)

### Development Tools

- **Composer** - PHP dependency manager
- **Laravel Installer** - Global Laravel installer
- **Vercel CLI** - For Vercel deployments
- **Build Tools** - gcc, g++, make, autoconf
- **Git** - Version control
- **Standard utilities** - curl, wget, zip, unzip, bash

### PHP Extensions

- JSON, XML, XMLWriter, XMLReader
- PDO (MySQL, PostgreSQL)
- cURL, Zip, BCMath, OpenSSL
- Mbstring, Tokenizer, DOM, Session
- FileInfo, Ctype, Phar

## 🛠️ Common Usage Patterns

### Laravel Development

```bash
# Start the container
docker run -it --rm \
  -v $(pwd):/workspace \
  -p 8000:8000 \
  azharizkita/devbox:latest

# Inside the container
composer install
php artisan serve --host=0.0.0.0 --port=8000
```

Access your Laravel app at: http://localhost:8000

### Node.js/React Development

```bash
# Start the container with Vite port
docker run -it --rm \
  -v $(pwd):/workspace \
  -p 3000:3000 -p 5173:5173 \
  azharizkita/devbox:latest

# Inside the container
npm install
npm run dev -- --host 0.0.0.0
```

### Oracle Database Projects

```bash
# For projects requiring Oracle connectivity
docker run -it --rm \
  -v $(pwd):/workspace \
  -p 8000:8000 \
  azharizkita/devbox:latest

# Inside the container (x86_64 only)
composer install  # OCI8 extension available
php artisan migrate  # Connect to Oracle DB
```

## 🐳 Docker Compose Setup

Create a `docker-compose.yml` file:

```yaml
version: "3.8"
services:
  devbox:
    image: azharizkita/devbox:latest
    volumes:
      - .:/workspace
      - /workspace/node_modules # Prevent overwriting node_modules
    ports:
      - "3000:3000" # Node.js/React
      - "8000:8000" # Laravel/PHP
      - "8080:8080" # Alternative HTTP
      - "5173:5173" # Vite dev server
    stdin_open: true
    tty: true
    working_dir: /workspace
```

Run with:

```bash
docker-compose up -d
docker-compose exec devbox bash
```

## 🔧 Platform Support

### x86_64 (Intel/AMD)

- ✅ Full feature support including Oracle OCI8
- ✅ All PHP extensions available

### ARM64 (Apple Silicon)

- ✅ All features except Oracle OCI8
- ⚠️ For Oracle projects: `composer install --ignore-platform-req=ext-oci8`

To force x86_64 on ARM64 machines:

```bash
docker run --platform=linux/amd64 -it --rm \
  -v $(pwd):/workspace \
  -p 3000:3000 -p 8000:8000 -p 8080:8080 -p 5173:5173 \
  azharizkita/devbox:latest
```

## 📋 Environment Variables

The container sets these environment variables:

```bash
ORACLE_HOME=/opt/oracle/instantclient
LD_LIBRARY_PATH=/opt/oracle/instantclient:/usr/lib
PATH includes Composer global bin and Oracle client
```

## 💡 Tips & Best Practices

### Port Mapping

- `3000` - Node.js development servers
- `8000` - Laravel artisan serve (default)
- `8080` - Alternative web server port
- `5173` - Vite development server

### Volume Mounting

- Always mount your project root to `/workspace`
- Consider excluding `node_modules` for better performance
- Your files will persist on the host machine

### Server Binding

Always bind to `0.0.0.0` when starting development servers:

```bash
# Laravel
php artisan serve --host=0.0.0.0 --port=8000

# Node.js/Vite
npm run dev -- --host 0.0.0.0

# Express.js
app.listen(3000, '0.0.0.0')
```

## 🔍 Troubleshooting

### Can't access the application from browser

- Ensure you're binding to `0.0.0.0`, not `127.0.0.1` or `localhost`
- Check that the port is mapped in your docker run command
- Verify the application is running inside the container

### Oracle OCI8 issues on ARM64

```bash
# Install dependencies without OCI8
composer install --ignore-platform-req=ext-oci8

# Or use the x86_64 version
docker run --platform=linux/amd64 ...
```

### Permission issues

The container runs as a non-root user (`devuser`) for security. If you need root access:

```bash
docker run -it --rm --user root \
  -v $(pwd):/workspace \
  azharizkita/devbox:latest
```

## 📚 Examples

### Full-stack Laravel + React project

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -p 8000:8000 -p 3000:3000 \
  azharizkita/devbox:latest

# Terminal 1: Laravel backend
php artisan serve --host=0.0.0.0 --port=8000

# Terminal 2: React frontend
cd frontend && npm run dev -- --host 0.0.0.0 --port=3000
```

### Building and deploying

```bash
# Build assets
npm run build

# Deploy to Vercel
vercel deploy

# Or build for production
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

## 🏷️ Available Tags

- `latest` - Latest stable build from main branch
- `v*.*.*` - Semantic version releases
- `main` - Latest main branch build

