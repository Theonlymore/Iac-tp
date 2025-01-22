const express = require('express');
const router = express.Router();
const db = require('./db');

// Route to get all products
router.get('/get-products', (req, res) => {
    const sql = 'SELECT * FROM products';
    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching products:', err);
            res.status(500).send('Database error');
        } else {
            res.json(results);
        }
    });
});

module.exports = router;
