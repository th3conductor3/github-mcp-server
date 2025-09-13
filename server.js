const express = require('express');
const { Octokit } = require('@octokit/rest');

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

const octokit = new Octokit({
  auth: process.env.GITHUB_TOKEN
});

// Root endpoint - service info
app.get('/', (req, res) => {
  res.json({
    service: "GitHub MCP Server",
    version: "1.0.0",
    endpoints: {
      "GET /mcp/github/test": "Test GitHub connection",
      "GET /mcp/github/repos": "List repositories",
      "POST /mcp/github/create-repo": "Create repository",
      "GET /health": "Health check"
    },
    github_token_configured: !!process.env.GITHUB_TOKEN
  });
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Test GitHub connection
app.get('/mcp/github/test', async (req, res) => {
  try {
    const { data } = await octokit.rest.users.getAuthenticated();
    res.json({ success: true, user: data.login });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// List repositories
app.get('/mcp/github/repos', async (req, res) => {
  try {
    const { data } = await octokit.rest.repos.listForAuthenticatedUser();
    res.json({ repos: data.map(repo => ({ name: repo.name, url: repo.html_url })) });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create repository
app.post('/mcp/github/create-repo', async (req, res) => {
  try {
    const { name, description = '', private: isPrivate = false } = req.body;
    const { data } = await octokit.rest.repos.createForAuthenticatedUser({
      name,
      description,
      private: isPrivate
    });
    res.json({ success: true, repo: { name: data.name, url: data.html_url } });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.listen(port, () => {
  console.log(`GitHub MCP Server running on port ${port}`);
});
