#!/bin/bash
# Deployment script for StartNoo CRM
# Instance IP: 52.10.46.91
# Instance ID: i-0044b94074f46ed20

set -e

EC2_USER="ubuntu"
EC2_IP="52.10.46.91"
EC2_KEY="$HOME/.ssh/startnoo-prod.pem"

echo "🚀 Deploying StartNoo CRM to EC2..."
echo "   Instance: $EC2_IP"
echo ""

echo "📦 Installing prerequisites..."
ssh -i "$EC2_KEY" $EC2_USER@$EC2_IP << 'EOF'
    sudo apt update
    sudo apt upgrade -y
    
    # Install Docker
    sudo apt install -y docker.io docker-compose git curl
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ubuntu
    
    # Install Node.js 24.x
    curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
    sudo apt install -y nodejs
    
    # Install Yarn
    sudo npm install -g yarn
    yarn --version
EOF

echo ""
echo "📥 Cloning repository..."
ssh -i "$EC2_KEY" $EC2_USER@$EC2_IP << 'EOF'
    cd ~
    if [ -d "university-crm" ]; then
        cd university-crm
        git pull
    else
        git clone https://github.com/illustriam/university-crm.git
        cd university-crm
    fi
EOF

echo ""
echo "🔨 Building and installing dependencies..."
ssh -i "$EC2_KEY" $EC2_USER@$EC2_IP << 'EOF'
    cd ~/university-crm
    yarn install
EOF

echo ""
echo "🗄️ Setting up databases..."
ssh -i "$EC2_KEY" $EC2_USER@$EC2_IP << 'EOF'
    cd ~/university-crm
    
    # Start PostgreSQL
    docker run -d --name twenty_pg \
        -e POSTGRES_USER=postgres \
        -e POSTGRES_PASSWORD=postgres \
        -e POSTGRES_DB=default \
        -v twenty_db_data:/var/lib/postgresql/data \
        -p 5432:5432 \
        postgres:16
    
    # Start Redis
    docker run -d --name twenty_redis -p 6379:6379 redis/redis-stack-server:latest
    
    sleep 10
EOF

echo ""
echo "🗃️ Initializing database..."
ssh -i "$EC2_KEY" $EC2_USER@$EC2_IP << 'EOF'
    cd ~/university-crm
    npx nx run twenty-server:database:init:prod
EOF

echo ""
echo "🚀 Starting the application..."
ssh -i "$EC2_KEY" $EC2_USER@$EC2_IP << 'EOF'
    cd ~/university-crm
    
    # Start in background with nohup
    nohup yarn start > /tmp/crm.log 2>&1 &
    
    sleep 5
    
    # Show logs
    tail -20 /tmp/crm.log
EOF

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Access your CRM at: http://$EC2_IP:3000"
echo "Or set up DNS for: crm.startnoo.com"
echo ""
echo "To view logs: ssh -i $EC2_KEY $EC2_USER@$EC2_IP 'tail -f /tmp/crm.log'"

