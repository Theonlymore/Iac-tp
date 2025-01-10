const express = require('express');
const router = express.Router();
const db = require('./db');

// Route to create a new product
router.post('/create-product', (req, res) => {
    const { name, description, price, picture } = req.body;
    const sql = 'INSERT INTO products (name, description, price, picture) VALUES (?, ?, ?, ?)';
    db.query(sql, [name, description, price, picture], (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send('Database error');
        } else {
            res.send('Product created');
        }
    });
});

module.exports = router;
