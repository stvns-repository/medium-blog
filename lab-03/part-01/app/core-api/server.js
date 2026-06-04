const http = require('http');

const PORT = 8080;

const server = http.createServer((req, res) => {
    // Check if the route matches our feature flag endpoint
    if (req.url === '/api/v1/flags' && req.method === 'GET') {
        const flagResponse = {
            feature: "v2_premium_checkout",
            enabled: true,
            version: "1.0.0"
        };

        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(flagResponse));
    } else {
        // Fallback for unmatched routes
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: "Not Found" }));
    }
});

server.listen(PORT, () => {
    console.log(`Feature Flag API starting on port ${PORT}...`);
});

