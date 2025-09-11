# GitHub MCP Server - LLM Integration Guide

## Overview
This GitHub MCP (Model Context Protocol) server provides GitHub API access through standardized endpoints. LLMs can interact with GitHub repositories, create repos, and manage GitHub resources.

## Server Information
- **Service**: GitHub MCP Server
- **Version**: 1.0.0
- **Base URL**: `http://localhost:3000` (local) or your deployed URL
- **Authentication**: GitHub Personal Access Token required

## Available Endpoints

### 1. Service Information
```http
GET /
```
**Purpose**: Get server status and available endpoints
**Response**:
```json
{
  "service": "GitHub MCP Server",
  "version": "1.0.0",
  "endpoints": {
    "GET /mcp/github/test": "Test GitHub connection",
    "GET /mcp/github/repos": "List repositories",
    "POST /mcp/github/create-repo": "Create repository",
    "GET /health": "Health check"
  },
  "github_token_configured": true
}
```

### 2. Health Check
```http
GET /health
```
**Purpose**: Verify server is running
**Response**:
```json
{
  "status": "ok",
  "timestamp": "2025-09-11T16:59:55.578Z"
}
```

### 3. Test GitHub Connection
```http
GET /mcp/github/test
```
**Purpose**: Verify GitHub token and connection
**Response** (Success):
```json
{
  "success": true,
  "user": "username"
}
```
**Response** (Error):
```json
{
  "success": false,
  "error": "Bad credentials"
}
```

### 4. List Repositories
```http
GET /mcp/github/repos
```
**Purpose**: Get all repositories for authenticated user
**Response**:
```json
{
  "repos": [
    {
      "name": "my-repo",
      "url": "https://github.com/username/my-repo"
    }
  ]
}
```

### 5. Create Repository
```http
POST /mcp/github/create-repo
Content-Type: application/json

{
  "name": "new-repo-name",
  "description": "Repository description (optional)",
  "private": false
}
```
**Purpose**: Create a new GitHub repository
**Response** (Success):
```json
{
  "success": true,
  "repo": {
    "name": "new-repo-name",
    "url": "https://github.com/username/new-repo-name"
  }
}
```
**Response** (Error):
```json
{
  "success": false,
  "error": "Repository creation failed"
}
```

## LLM Integration Examples

### For Q Developer / Amazon Q
```javascript
// Test connection
const response = await fetch('http://localhost:3000/mcp/github/test');
const result = await response.json();

// List repositories
const repos = await fetch('http://localhost:3000/mcp/github/repos');
const repoList = await repos.json();

// Create repository
const newRepo = await fetch('http://localhost:3000/mcp/github/create-repo', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    name: 'my-new-project',
    description: 'Created via MCP server',
    private: false
  })
});
```

### For curl/HTTP clients
```bash
# Test connection
curl http://localhost:3000/mcp/github/test

# List repositories
curl http://localhost:3000/mcp/github/repos

# Create repository
curl -X POST http://localhost:3000/mcp/github/create-repo \
  -H "Content-Type: application/json" \
  -d '{"name":"test-repo","description":"Test repository","private":false}'
```

## Error Handling
All endpoints return appropriate HTTP status codes:
- `200`: Success
- `400`: Bad Request (invalid parameters)
- `401`: Unauthorized (invalid GitHub token)
- `500`: Internal Server Error

Error responses include descriptive messages:
```json
{
  "error": "Descriptive error message",
  "success": false
}
```

## Setup Requirements
1. GitHub Personal Access Token with appropriate permissions
2. Environment variable `GITHUB_TOKEN` set
3. Node.js server running on specified port

## Common Use Cases for LLMs
1. **Repository Management**: List, create, and manage repositories
2. **Project Setup**: Automatically create repos for new projects
3. **GitHub Integration**: Connect development workflows with GitHub
4. **Repository Discovery**: Find and explore existing repositories

## Security Notes
- GitHub token should have minimal required permissions
- Server should run in secure environment
- Consider rate limiting for production use
- Token should be kept confidential and rotated regularly
