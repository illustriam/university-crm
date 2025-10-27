# StartNoo CRM Deployment Workflow

## Initial Setup (One-Time)
Once dependencies finish installing, these steps remain:

### Step 1: Start Databases (Docker)
```bash
# PostgreSQL
docker run -d --name twenty_pg \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=default \
  -v twenty_db_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:16

# Redis
docker run -d --name twenty_redis -p 6379:6379 redis/redis-stack-server:latest

# Wait for databases to be ready
sleep 10
```

### Step 2: Initialize Database
```bash
cd ~/university-crm
npx nx run twenty-server:database:init:prod
```

### Step 3: Start the Application
```bash
# Build and start everything
npx nx start

# OR start in background
nohup npx nx start > /tmp/crm.log 2>&1 &
```

---

## Ongoing Deployment Workflow

### ❌ You DON'T need to do this every time!

Once the initial setup is complete, here's the simple workflow:

### Option A: Simple Restart (if code is already up to date)
```bash
# SSH into server
ssh-crm

# Stop the application (if running in background)
pkill -f "nx start" || pkill -f "yarn start"

# Start it again
cd ~/university-crm
npx nx start
```

### Option B: Update Code + Restart
```bash
# SSH into server
ssh-crm

# Pull latest code
cd ~/university-crm
git pull origin main

# Restart (if needed)
pkill -f "nx start"
nohup npx nx start > /tmp/crm.log 2>&1 &
```

### Option C: Full Reinstall (Only if dependencies changed)
```bash
ssh-crm
cd ~/university-crm
git pull origin main
yarn install
pkill -f "nx start"
nohup npx nx start > /tmp/crm.log 2>&1 &
```

---

## Automated Deployment (Recommended)

Create a simple deploy script on your server:

```bash
#!/bin/bash
# Save as: ~/deploy-crm-update.sh

cd ~/university-crm
echo "📥 Pulling latest code..."
git pull origin main

echo "🔨 Checking for dependency changes..."
if git diff HEAD~1 package.json > /dev/null 2>&1; then
    echo "📦 Installing dependencies..."
    yarn install
fi

echo "🔄 Restarting application..."
pkill -f "nx start"
sleep 2
nohup npx nx start > /tmp/crm.log 2>&1 &

echo "✅ Deployment complete!"
echo "📋 Check logs: tail -f /tmp/crm.log"
```

Then you can just run:
```bash
ssh-crm 'bash ~/deploy-crm-update.sh'
```

---

## Production-Ready Deployment (Future)

For production, consider:

1. **PM2 Process Manager** - Auto-restart if crashes
2. **Nginx Reverse Proxy** - Handle SSL and route to app
3. **GitHub Actions CI/CD** - Auto-deploy on push
4. **Docker Compose** - Containerize entire stack
5. **Backup Strategy** - Regular database backups

---

## Quick Commands Reference

```bash
# Check if app is running
ssh-crm 'ps aux | grep "nx start" | grep -v grep'

# View logs
ssh-crm 'tail -f /tmp/crm.log'

# Restart app
ssh-crm 'cd ~/university-crm && pkill -f "nx start" && sleep 2 && nohup npx nx start > /tmp/crm.log 2>&1 &'

# Check database connection
ssh-crm 'docker ps | grep postgres'

# Stop everything
ssh-crm 'pkill -f "nx start" && docker stop twenty_pg twenty_redis'
```

