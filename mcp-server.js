const express = require('express');
const { exec } = require('child_process');
const https = require('https');

const app = express();
const PORT = process.env.PORT || 3001;
const GITHUB_TOKEN = process.env.GITHUB_TOKEN;

app.use(express.json());

// GitHub API helper function
function githubAPI(method, endpoint, data = null) {
    return new Promise((resolve, reject) => {
        if (!GITHUB_TOKEN) {
            return reject(new Error('GITHUB_TOKEN environment variable not set'));
        }

        const options = {
            hostname: 'api.github.com',
            path: endpoint,
            method: method,
            headers: {
                'Authorization': `token ${GITHUB_TOKEN}`,
                'User-Agent': 'GitHub-MCP-Server',
                'Accept': 'application/vnd.github.v3+json'
            }
        };

        if (data) {
            options.headers['Content-Type'] = 'application/json';
        }

        const req = https.request(options, (res) => {
            let responseData = '';
            res.on('data', chunk => responseData += chunk);
            res.on('end', () => {
                try {
                    const parsed = JSON.parse(responseData);
                    resolve(parsed);
                } catch (e) {
                    resolve(responseData);
                }
            });
        });

        req.on('error', reject);
        
        if (data) {
            req.write(JSON.stringify(data));
        }
        
        req.end();
    });
}

// Test GitHub connection
app.get('/mcp/github/test', async (req, res) => {
    try {
        const user = await githubAPI('GET', '/user');
        res.json({ 
            success: true, 
            message: `Connected as ${user.login}`,
            user: user.login 
        });
    } catch (error) {
        res.status(500).json({ 
            success: false, 
            error: error.message 
        });
    }
});

// List repositories
app.get('/mcp/github/repos', async (req, res) => {
    try {
        const repos = await githubAPI('GET', '/user/repos?per_page=100&sort=updated');
        const repoList = repos.map(repo => ({
            name: repo.name,
            description: repo.description,
            private: repo.private,
            url: repo.html_url,
            updated: repo.updated_at
        }));
        res.json({ success: true, repositories: repoList });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// Create repository
app.post('/mcp/github/create-repo', async (req, res) => {
    try {
        const { repoName, description = 'Created via GitHub MCP Server', isPrivate = true } = req.body;
        
        if (!repoName) {
            return res.status(400).json({ success: false, error: 'repoName is required' });
        }

        const repoData = {
            name: repoName,
            description: description,
            private: isPrivate
        };

        const repo = await githubAPI('POST', '/user/repos', repoData);
        res.json({ 
            success: true, 
            repository: {
                name: repo.name,
                url: repo.html_url,
                clone_url: repo.clone_url
            }
        });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// Health check
app.get('/health', (req, res) => {
    res.json({ 
        status: 'healthy', 
        timestamp: new Date().toISOString(),
        github_token_configured: !!GITHUB_TOKEN
    });
});

// Root endpoint
app.get('/', (req, res) => {
    res.json({
        service: 'GitHub MCP Server',
        version: '1.0.0',
        endpoints: {
            'GET /mcp/github/test': 'Test GitHub connection',
            'GET /mcp/github/repos': 'List repositories',
            'POST /mcp/github/create-repo': 'Create repository',
            'GET /health': 'Health check'
        },
        github_token_configured: !!GITHUB_TOKEN
    });
});

app.listen(PORT, () => {
    console.log(`🐙 GitHub MCP Server running on port ${PORT}`);
    console.log(`🔐 GitHub token configured: ${!!GITHUB_TOKEN}`);
    console.log(`📡 API available at http://localhost:${PORT}`);
});
