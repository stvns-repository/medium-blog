const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 8080;

// 1. Core Feature Flag Configuration Context
const FEATURES = {
    environment: process.env.APP_ENV || "development",
    v2_premium_checkout: process.env.ENABLE_PREMIUM_CHECKOUT === "true"
};

// 2. Serve static portal frontend assets automatically
app.use(express.static(path.join(__dirname, 'public')));

// 3. API Route for runtime cluster configuration parsing
app.get('/api/v1/flags', (req, res) => {
    res.setHeader('Content-Type', 'application/json');
    res.json(FEATURES);
});

// 4. Wildcard to catch and default redirect back to root dashboard layout
app.get('*all', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 System Online: Servicing API context engine on port ${PORT}`);
});
