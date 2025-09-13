# Dual Protocol GitHub Server

This repository provides **two implementations** for maximum compatibility:

## 🌐 HTTP REST API Server
**File**: `server.js`  
**Usage**: Web deployment, direct HTTP calls  
**URL**: https://github-mcp-server-th3conductor3-gmailcoms-projects.vercel.app/

### Start HTTP Server:
```bash
npm start
# or
node server.js
```

### HTTP Endpoints:
```bash
GET  /                      # Service info
GET  /health               # Health check
GET  /mcp/github/test      # Test GitHub connection
GET  /mcp/github/repos     # List repositories
POST /mcp/github/create-repo # Create repository
```

## 🔌 True MCP Server
**File**: `mcp-server.js`  
**Usage**: MCP Inspector, MCP clients, stdio communication  
**Protocol**: JSON-RPC 2.0 over stdio

### Start MCP Server:
```bash
npm run mcp
# or
node mcp-server.js
```

### MCP Tools:
- `github_test_connection` - Test GitHub API connection
- `github_list_repos` - List all repositories
- `github_create_repo` - Create new repository

## 🧪 Testing Both Versions

### Test HTTP REST API:
```bash
# Health check
curl https://github-mcp-server-th3conductor3-gmailcoms-projects.vercel.app/health

# Test GitHub connection
curl https://github-mcp-server-th3conductor3-gmailcoms-projects.vercel.app/mcp/github/test

# Create repository
curl -X POST https://github-mcp-server-th3conductor3-gmailcoms-projects.vercel.app/mcp/github/create-repo \
  -H "Content-Type: application/json" \
  -d '{"name":"test-repo","description":"Test repository"}'
```

### Test MCP Server:
```bash
# Using MCP Inspector
# Go to: https://modelcontextprotocol.io/legacy/tools/inspector
# Command: node mcp-server.js

# Or test manually with JSON-RPC:
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{}}' | node mcp-server.js
echo '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}' | node mcp-server.js
```

## 🔧 Configuration

### For MCP Clients:
Add to your MCP client config:
```json
{
  "mcpServers": {
    "github-mcp-server": {
      "command": "node",
      "args": ["mcp-server.js"],
      "cwd": "/path/to/github-mcp-server"
    }
  }
}
```

### For HTTP Clients:
```javascript
const baseUrl = 'https://github-mcp-server-th3conductor3-gmailcoms-projects.vercel.app';
const response = await fetch(`${baseUrl}/mcp/github/test`);
```

## 🎯 Use Cases

### HTTP REST API:
- ✅ Web applications
- ✅ Vercel/Netlify deployment
- ✅ Direct LLM integration
- ✅ Browser-based tools
- ✅ Mobile apps

### True MCP Server:
- ✅ MCP Inspector testing
- ✅ Desktop MCP clients
- ✅ Claude Desktop integration
- ✅ Local development tools
- ✅ Command-line workflows

## 🚀 Deployment

### HTTP Version (Vercel):
Already deployed at: https://github-mcp-server-th3conductor3-gmailcoms-projects.vercel.app/

### MCP Version (Local):
```bash
git clone https://github.com/th3conductor3/github-mcp-server
cd github-mcp-server
npm install
npm run mcp
```

Both versions provide identical GitHub functionality with different communication protocols for maximum compatibility!
