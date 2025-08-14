#!/bin/bash

# Load environment variables from .env
set -o allexport
source .env
set +o allexport

# Run commands on the server
ssh -p "$DEPLOY_PORT" "$DEPLOY_USER@$DEPLOY_HOST" <<EOF
  echo "🔹 Connecting to server and deploying updates..."

  if [ -d "$APP_DIR" ]; then
    echo "📥 Pulling latest changes..."
    cd "$APP_DIR"
    git reset --hard
    git pull origin main
  else
    echo "📦 Cloning repository..."
    git clone "$GIT_REPO" "$APP_DIR"
    cd "$APP_DIR"
  fi

  cd "$TARGET_DIR"
  echo "Current target dir: $TARGET_DIR"

  # Restart Docker without sudo
  echo "🚀 Restarting Docker containers..."
  docker-compose down
  docker-compose up --build -d

  # Verify if Docker containers are running
  if ! docker-compose ps | grep "Up"; then
    echo "❌ Docker failed to start. Check logs with 'docker-compose logs'."
    exit 1
  fi

  echo "✅ Deployment successful!"
EOF
