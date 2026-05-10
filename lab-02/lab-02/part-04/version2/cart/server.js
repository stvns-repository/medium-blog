const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json()); // POST request

// Updated /api/cart
app.post('/api/cart', (req, res) => {
    const item = req.body;
    console.log(`Received item: Kitten #${item.id}`);
    
    res.json({
        status: 'success',
        message: `Kitten #${item.id} is now in the backend database!`
    });
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Backend is purring on port ${PORT}`);
});