#!/bin/bash

# GitHub MCP Server for Amazon Q Enhanced Workflow
# Provides GitHub API integration for repository management

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRETS_SCRIPT="../../scripts/secrets-manager.sh"

get_github_token() {
    bash "$SECRETS_SCRIPT" get github token 2>/dev/null
}

github_api_call() {
    local method="$1"
    local endpoint="$2"
    local data="$3"
    local token=$(get_github_token)
    
    if [ -z "$token" ]; then
        echo "❌ GitHub token not found. Run: q-workflow secrets set github token YOUR_TOKEN"
        return 1
    fi
    
    if [ -n "$data" ]; then
        curl -s -X "$method" \
            -H "Authorization: token $token" \
            -H "Accept: application/vnd.github.v3+json" \
            -H "Content-Type: application/json" \
            -d "$data" \
            "https://api.github.com$endpoint"
    else
        curl -s -X "$method" \
            -H "Authorization: token $token" \
            -H "Accept: application/vnd.github.v3+json" \
            "https://api.github.com$endpoint"
    fi
}

case "$1" in
    "setup")
        echo "🐙 Setting up GitHub MCP server..."
        token=$(get_github_token)
        if [ -z "$token" ]; then
            echo "❌ No GitHub token found. Please run:"
            echo "   q-workflow secrets set github token YOUR_TOKEN"
            exit 1
        fi
        echo "✅ GitHub MCP server setup complete!"
        echo "🔗 Token configured and ready for use"
        ;;
        
    "test")
        echo "🧪 Testing GitHub API connection..."
        response=$(github_api_call "GET" "/user")
        if echo "$response" | grep -q '"login"'; then
            username=$(echo "$response" | grep '"login"' | cut -d'"' -f4)
            echo "✅ GitHub API connection successful!"
            echo "👤 Connected as: $username"
        else
            echo "❌ GitHub API connection failed"
            echo "Response: $response"
            exit 1
        fi
        ;;
        
    "create-repo")
        if [ -z "$2" ]; then
            echo "Usage: $0 create-repo <repo-name> [description] [private]"
            exit 1
        fi
        
        repo_name="$2"
        description="${3:-Created via Amazon Q Enhanced Workflow}"
        private="${4:-true}"
        
        echo "🚀 Creating repository: $repo_name"
        
        data="{\"name\":\"$repo_name\",\"description\":\"$description\",\"private\":$private}"
        response=$(github_api_call "POST" "/user/repos" "$data")
        
        if echo "$response" | grep -q '"clone_url"'; then
            clone_url=$(echo "$response" | grep '"clone_url"' | cut -d'"' -f4)
            echo "✅ Repository created successfully!"
            echo "🔗 Clone URL: $clone_url"
        else
            echo "❌ Failed to create repository"
            echo "Response: $response"
            exit 1
        fi
        ;;
        
    "list-repos")
        echo "📋 Listing repositories..."
        response=$(github_api_call "GET" "/user/repos?per_page=50&sort=updated")
        
        if echo "$response" | grep -q '"name"'; then
            echo "$response" | grep '"name"' | cut -d'"' -f4 | head -20
        else
            echo "❌ Failed to list repositories"
            exit 1
        fi
        ;;
        
    "get-repo")
        if [ -z "$2" ]; then
            echo "Usage: $0 get-repo <repo-name>"
            exit 1
        fi
        
        repo_name="$2"
        username=$(github_api_call "GET" "/user" | grep '"login"' | cut -d'"' -f4)
        
        echo "📖 Getting repository info: $repo_name"
        response=$(github_api_call "GET" "/repos/$username/$repo_name")
        
        if echo "$response" | grep -q '"name"'; then
            echo "✅ Repository found!"
            echo "$response" | jq '.' 2>/dev/null || echo "$response"
        else
            echo "❌ Repository not found"
            exit 1
        fi
        ;;
        
    "push-repo")
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Usage: $0 push-repo <local-path> <repo-name>"
            exit 1
        fi
        
        local_path="$2"
        repo_name="$3"
        username=$(github_api_call "GET" "/user" | grep '"login"' | cut -d'"' -f4)
        
        if [ ! -d "$local_path" ]; then
            echo "❌ Local path does not exist: $local_path"
            exit 1
        fi
        
        echo "📤 Pushing local repository to GitHub..."
        cd "$local_path"
        
        if [ ! -d ".git" ]; then
            git init
        fi
        
        git remote add origin "https://github.com/$username/$repo_name.git" 2>/dev/null || \
        git remote set-url origin "https://github.com/$username/$repo_name.git"
        
        git add .
        git commit -m "Push via Amazon Q Enhanced Workflow MCP" || true
        git branch -M main
        git push -u origin main
        
        echo "✅ Repository pushed successfully!"
        ;;
        
    *)
        echo "GitHub MCP Server - Amazon Q Enhanced Workflow"
        echo ""
        echo "Available commands:"
        echo "  setup           - Setup GitHub MCP server"
        echo "  test            - Test GitHub API connection"
        echo "  create-repo     - Create new repository"
        echo "  list-repos      - List all repositories"
        echo "  get-repo        - Get repository details"
        echo "  push-repo       - Push local repo to GitHub"
        echo ""
        echo "Usage examples:"
        echo "  $0 setup"
        echo "  $0 test"
        echo "  $0 create-repo my-project 'Project description' true"
        echo "  $0 list-repos"
        echo "  $0 push-repo /path/to/repo repo-name"
        ;;
esac
