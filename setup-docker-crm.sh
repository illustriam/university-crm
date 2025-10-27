#!/bin/bash
# Set up CRM using Docker Compose on EC2

ssh -i ~/.ssh/startnoo-prod.pem ubuntu@52.10.46.91 << 'EOF'
    cd ~
    
    # Install Docker Compose if not present
    sudo apt update
    sudo apt install -y docker-compose-plugin
    
    # Clone if not already there
    if [ ! -d "university-crm" ]; then
        git clone https://github.com/illustriam/university-crm.git
    fi
    
    cd university-crm
    
    # Create a production-ready docker-compose setup
    cat > docker-compose.prod.yml << 'COMPOSE'
version: '3.8'

services:
  db:
    image: postgres:16
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: default
    volumes:
      - db-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis/redis-stack-server:latest
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  db-data:
COMPOSE

    # Start databases
    docker compose -f docker-compose.prod.yml up -d
    
    # Wait for databases
    echo "Waiting for databases..."
    sleep 20
    
    # Check database health
    docker compose -f docker-compose.prod.yml ps
    
    echo "Databases are ready!"
    echo "Next steps:"
    echo "1. Initialize database"
    echo "2. Start the application"
EOF

echo "✅ Docker setup complete! Databases are running."

