#!/bin/bash

echo "🚀 Deploying GitHub MCP Server..."

# Install dependencies
npm install

echo "🌐 Choose deployment option:"
echo "1. Vercel (Recommended)"
echo "2. Railway"
echo "3. Render"
echo "4. Docker Local"

read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo "📡 Deploying to Vercel..."
        if ! command -v vercel &> /dev/null; then
            npm install -g vercel
        fi
        
        # Set GitHub token as environment variable
        echo "🔐 Setting GitHub token..."
        echo "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" | vercel env add GITHUB_TOKEN production
        
        # Deploy
        vercel --prod
        echo "✅ MCP Server deployed to Vercel!"
        ;;
        
    2)
        echo "🚂 Deploy to Railway:"
        echo "1. Connect your GitHub repo to Railway"
        echo "2. Set environment variable: GITHUB_TOKEN=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"
        echo "3. Set start command: cd mcp-servers/github && npm start"
        ;;
        
    3)
        echo "🎨 Deploy to Render:"
        echo "1. Connect your GitHub repo to Render"
        echo "2. Set environment variable: GITHUB_TOKEN=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"
        echo "3. Set build command: cd mcp-servers/github && npm install"
        echo "4. Set start command: cd mcp-servers/github && npm start"
        ;;
        
    4)
        echo "🐳 Building Docker container..."
        docker build -t github-mcp-server .
        docker run -d -p 3001:3001 \
            -e GITHUB_TOKEN="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" \
            --name github-mcp-server \
            github-mcp-server
        echo "✅ MCP Server running at http://localhost:3001"
        ;;
esac

echo ""
echo "🔗 MCP Server API Endpoints:"
echo "  POST /mcp/github/create-repo"
echo "  POST /mcp/github/push-repo"
echo "  GET  /mcp/github/repos"
echo "  GET  /mcp/github/test"
