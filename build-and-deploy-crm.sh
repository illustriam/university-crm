#!/bin/bash
# Build locally and deploy to EC2

set -e

EC2_USER="ubuntu"
EC2_IP="52.10.46.91"
SSH_KEY="$HOME/.ssh/startnoo-prod.pem"

echo "🔨 Step 1: Building your customized CRM locally..."
echo "   This may take 10-15 minutes"
echo ""

# Build the project locally
npm run build 2>&1 | tail -20 || yarn build 2>&1 | tail -20

echo ""
echo "✅ Build complete!"
echo ""
echo "📦 Step 2: Creating deployment package..."
echo ""

# Create a tarball of just what we need
tar --exclude='node_modules' \
    --exclude='.git' \
    --exclude='dist' \
    --exclude='build' \
    --exclude='coverage' \
    --exclude='.nx' \
    -czf /tmp/university-crm-src.tar.gz .

echo "✅ Package created: /tmp/university-crm-src.tar.gz"
echo ""
echo "🚀 Step 3: Uploading to EC2..."
echo ""

# Upload to server
scp -i "$SSH_KEY" /tmp/university-crm-src.tar.gz $EC2_USER@$EC2_IP:/tmp/

echo ""
echo "✅ Upload complete!"
echo ""
echo "🔧 Step 4: Setting up on EC2..."
echo ""

# Extract and set up on server
ssh -i "$SSH_KEY" $EC2_USER@$EC2_IP << 'REMOTE'
    cd ~
    
    # Stop old processes
    docker-compose -f ~/twenty-crm/docker-compose.yml stop 2>/dev/null || true
    pkill -f "nx start" 2>/dev/null || true
    
    # Remove old install
    rm -rf university-crm
    
    # Extract new code
    tar -xzf /tmp/university-crm-src.tar.gz -C ~/university-crm
    
    cd ~/university-crm
    
    echo "📦 Installing dependencies on server..."
    yarn install 2>&1 | tail -20
    
    echo ""
    echo "✅ Dependencies installed!"
    echo ""
    echo "🗄️ Starting databases..."
    
    # Start databases with Docker
    docker-compose up -d
    
    sleep 10
    
    echo ""
    echo "🔧 Initializing database..."
    npx nx run twenty-server:database:init:prod 2>&1 | tail -10
    
    echo ""
    echo "🚀 Starting application..."
    nohup yarn start > /tmp/crm.log 2>&1 &
    
    sleep 5
    
    echo ""
    echo "✅ Deployment complete!"
    echo ""
    tail -20 /tmp/crm.log
REMOTE

echo ""
echo "🎉 Your customized StartNoo CRM is deployed!"
echo ""
echo "Access at: http://52.10.46.91:3000"
echo "Login: tim@apple.dev / tim@apple.dev"
echo ""
echo "To check logs: ssh-crm 'tail -f /tmp/crm.log'"

