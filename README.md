# GitHub MCP Server

Standalone GitHub MCP (Model Context Protocol) server for Amazon Q Enhanced Workflow. Provides REST API endpoints for GitHub repository management.

## 🚀 Deploy to Vercel

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/th3conductor3/github-mcp-server)

### Quick Deploy Steps:
1. Click "Deploy with Vercel" button above
2. Connect your GitHub account
3. Set environment variable: `GITHUB_TOKEN=your_github_token`
4. Deploy!

## 🔧 Environment Variables

Set this in Vercel dashboard:
```
GITHUB_TOKEN=ghp_your_github_token_here
```

## 📡 API Endpoints

### Test Connection
```bash
GET /mcp/github/test
```

### List Repositories
```bash
GET /mcp/github/repos
```

### Create Repository
```bash
POST /mcp/github/create-repo
Content-Type: application/json

{
  "repoName": "my-new-repo",
  "description": "Repository description",
  "isPrivate": true
}
```

### Push Repository
```bash
POST /mcp/github/push-repo
Content-Type: application/json

{
  "repoName": "existing-repo",
  "localPath": "/path/to/local/repo"
}
```

## 🤖 Usage with Amazon Q

Once deployed, Amazon Q Developer can use your MCP server:

```bash
# Test connection
curl https://your-mcp-server.vercel.app/mcp/github/test

# Create repository
curl -X POST https://your-mcp-server.vercel.app/mcp/github/create-repo \
  -H "Content-Type: application/json" \
  -d '{"repoName":"ai-project","description":"Created by Amazon Q"}'

# List all repositories
curl https://your-mcp-server.vercel.app/mcp/github/repos
```

## 🔐 Security

- GitHub token stored as Vercel environment variable
- All repositories created as private by default
- API endpoints secured with token authentication

## 🛠️ Local Development

```bash
npm install
npm start
# Server runs on http://localhost:3001
```

## 📚 Integration

This MCP server integrates with:
- Amazon Q Enhanced Workflow
- Any AI assistant that can make HTTP requests
- GitHub API for full repository management

---

**Part of the Amazon Q Enhanced Workflow ecosystem** 🧠✨
