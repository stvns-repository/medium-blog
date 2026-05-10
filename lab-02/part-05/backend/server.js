const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 3000;

// CRITICAL: This allows the backend to parse JSON sent from the frontend
app.use(express.json());
app.use(cors());

// Part 4 Logic: Handling Cart Additions
app.post('/api/cart', (req, res) => {
    const item = req.body;
    console.log(`Cart Update: Received ${item.name} (#${item.id})`);
    res.status(200).json({ message: "Item added to cart successfully!" });
});

// Part 5 Logic: Handling Payments
app.post('/api/pay', (req, res) => {
    const { items } = req.body;
    console.log("Payment request received for checkout!");
    
    // This is a simulation only to showcase that the status is indeed HTTP/200.
    res.status(200).json({ 
        message: "Payment Successful! 💳 Your cloud kittens are coming home." 
    });
});

// Health Check / Status Route
app.get('/api/status', (req, res) => {
    res.json({
        message: "Microservice Online: GitOps pipeline is fully functional.",
        timestamp: new Date().toISOString()
    });
});

app.listen(PORT, () => {
    console.log(`Backend listening at http://0.0.0.0:${PORT}`);
});