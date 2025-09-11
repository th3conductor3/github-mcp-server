# GitHub MCP Server

A minimal GitHub API server that provides MCP (Model Context Protocol) endpoints for LLM integration.

## 🚀 Quick Start

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Configure environment:**
   ```bash
   cp .env.example .env
   # Edit .env and add your GitHub Personal Access Token
   ```

3. **Start server:**
   ```bash
   npm start
   ```

4. **Test connection:**
   ```bash
   curl http://localhost:3000/mcp/github/test
   ```

## 🤖 LLM Integration

### For Q Developer / Amazon Q
This server is designed to work seamlessly with Q Developer and other LLMs. See [MCP_INTEGRATION.md](./MCP_INTEGRATION.md) for detailed integration guide.

### Quick Test for LLMs
```javascript
// Check server status
fetch('http://localhost:3000/health')

// Test GitHub connection  
fetch('http://localhost:3000/mcp/github/test')

// List repositories
fetch('http://localhost:3000/mcp/github/repos')
```

## 📡 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Service information |
| `/health` | GET | Health check |
| `/mcp/github/test` | GET | Test GitHub connection |
| `/mcp/github/repos` | GET | List repositories |
| `/mcp/github/create-repo` | POST | Create repository |

## 🔧 Configuration

### Environment Variables
```bash
GITHUB_TOKEN=your_github_personal_access_token
PORT=3000
```

### GitHub Token Setup
1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Generate new token with `repo` and `user` scopes
3. Add token to `.env` file

## 🚀 Deployment

### Vercel (Recommended)
```bash
vercel --prod
```
Set `GITHUB_TOKEN` in Vercel dashboard environment variables.

### Local Development
```bash
npm start
# Server runs on http://localhost:3000
```

### Docker
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

## 📚 Documentation

- **[MCP Integration Guide](./MCP_INTEGRATION.md)** - Complete LLM integration documentation
- **[Configuration Guide](./MCP_CONFIG.md)** - Setup and configuration details

## 🔍 Example Usage

### Create a Repository
```bash
curl -X POST http://localhost:3000/mcp/github/create-repo \
  -H "Content-Type: application/json" \
  -d '{
    "name": "my-new-project",
    "description": "Created via MCP server",
    "private": false
  }'
```

### List Repositories
```bash
curl http://localhost:3000/mcp/github/repos
```

## 🛡️ Security

- Keep GitHub token secure and rotate regularly
- Use minimal required token permissions
- Consider rate limiting for production use
- Run server in secure environment

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test with LLM integration
5. Submit pull request

## 📄 License

MIT License - see LICENSE file for details
