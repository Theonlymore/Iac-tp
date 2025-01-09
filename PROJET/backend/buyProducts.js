const express = require('express');
const router = express.Router();
const db = require('./db'); // Import the database connection

// Route to buy a product
router.post('/buy-product', (req, res) => {
    const { productId } = req.body;
    const sql = 'DELETE FROM products WHERE id = ?';
    db.query(sql, [productId], (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send('Database error');
        } else if (result.affectedRows === 0) {
            res.status(404).send('Product not found');
        } else {
            res.send('Product bought');
        }
    });
});

module.exports = router;
