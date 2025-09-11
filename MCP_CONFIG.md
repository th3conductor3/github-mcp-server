# MCP Server Configuration for LLMs

## Quick Start for LLMs

### 1. Server Status Check
Always start by checking if the server is running:
```
GET http://localhost:3000/health
```

### 2. Verify GitHub Connection
Test the GitHub integration:
```
GET http://localhost:3000/mcp/github/test
```

### 3. Basic Operations
```
# List all repositories
GET http://localhost:3000/mcp/github/repos

# Create a new repository
POST http://localhost:3000/mcp/github/create-repo
{
  "name": "project-name",
  "description": "Project description",
  "private": false
}
```

## LLM Tool Integration

### For Model Context Protocol (MCP) Clients
Add this server as an MCP resource:

```json
{
  "name": "github-mcp-server",
  "type": "http",
  "baseUrl": "http://localhost:3000",
  "endpoints": {
    "test": "/mcp/github/test",
    "repos": "/mcp/github/repos", 
    "create": "/mcp/github/create-repo"
  }
}
```

### Request Patterns for LLMs

#### Pattern 1: Repository Discovery
```
1. GET /mcp/github/test (verify connection)
2. GET /mcp/github/repos (list repositories)
3. Process repository list for user
```

#### Pattern 2: Repository Creation
```
1. GET /mcp/github/test (verify connection)
2. POST /mcp/github/create-repo (create with user parameters)
3. Return repository URL to user
```

#### Pattern 3: Health Monitoring
```
1. GET /health (check server status)
2. GET /mcp/github/test (check GitHub connectivity)
3. Report status to user
```

## Response Handling for LLMs

### Success Responses
- Status 200: Process data normally
- Check `success: true` in response body
- Extract relevant data for user presentation

### Error Responses  
- Status 4xx/5xx: Handle gracefully
- Check `success: false` in response body
- Present error message to user
- Suggest troubleshooting steps

## Environment Setup

### Required Environment Variables
```bash
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx
PORT=3000
```

### GitHub Token Permissions
Minimum required scopes:
- `repo` (for repository access)
- `user` (for user information)

## Deployment Options

### Local Development
```bash
npm start
# Server runs on http://localhost:3000
```

### Production Deployment
- Vercel: Use provided `vercel.json`
- Heroku: Set environment variables
- Docker: Create container with Node.js

### Environment Variables for Production
```
GITHUB_TOKEN=your_production_token
PORT=process.env.PORT || 3000
```

## Testing the Integration

### Manual Testing
```bash
# Test all endpoints
curl http://localhost:3000/
curl http://localhost:3000/health
curl http://localhost:3000/mcp/github/test
curl http://localhost:3000/mcp/github/repos
```

### Automated Testing
```javascript
// Simple test script
const baseUrl = 'http://localhost:3000';

async function testMCPServer() {
  const tests = [
    { endpoint: '/', method: 'GET' },
    { endpoint: '/health', method: 'GET' },
    { endpoint: '/mcp/github/test', method: 'GET' },
    { endpoint: '/mcp/github/repos', method: 'GET' }
  ];
  
  for (const test of tests) {
    const response = await fetch(`${baseUrl}${test.endpoint}`);
    console.log(`${test.endpoint}: ${response.status}`);
  }
}
```
