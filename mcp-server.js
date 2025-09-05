const express = require('express');
const { exec } = require('child_process');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3001;

app.use(express.json());

// GitHub MCP API endpoints
app.post('/mcp/github/:action', (req, res) => {
    const { action } = req.params;
    const { repoName, description, isPrivate, localPath } = req.body;
    
    let command = `./github_mcp.sh ${action}`;
    
    switch(action) {
        case 'create-repo':
            command += ` "${repoName}" "${description || 'Created via MCP'}" ${isPrivate || true}`;
            break;
        case 'get-repo':
        case 'push-repo':
            command += ` "${repoName}"`;
            if (localPath) command += ` "${localPath}"`;
            break;
    }
    
    exec(command, { cwd: __dirname }, (error, stdout, stderr) => {
        if (error) {
            return res.status(500).json({ 
                success: false, 
                error: error.message,
                stderr 
            });
        }
        
        res.json({ 
            success: true, 
            output: stdout,
            action: action
        });
    });
});

app.get('/mcp/github/test', (req, res) => {
    exec('./github_mcp.sh test', { cwd: __dirname }, (error, stdout, stderr) => {
        if (error) {
            return res.status(500).json({ success: false, error: error.message });
        }
        res.json({ success: true, output: stdout });
    });
});

app.get('/mcp/github/repos', (req, res) => {
    exec('./github_mcp.sh list-repos', { cwd: __dirname }, (error, stdout, stderr) => {
        if (error) {
            return res.status(500).json({ success: false, error: error.message });
        }
        const repos = stdout.trim().split('\n').filter(repo => repo.length > 0);
        res.json({ success: true, repositories: repos });
    });
});

app.listen(PORT, () => {
    console.log(`🐙 GitHub MCP Server running on port ${PORT}`);
    console.log(`📡 API endpoints available at http://localhost:${PORT}/mcp/github/`);
});
