const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 3000;

app.use(cors());

app.get('/api/status', (req, res) => {
    res.json({
        message: "Hello from the Node.js Backend! GitOps is working.",
        timestamp: new Date().toISOString()
    });
});

app.listen(PORT, () => {
    console.log(`Backend listening at http://localhost:${PORT}`);
});