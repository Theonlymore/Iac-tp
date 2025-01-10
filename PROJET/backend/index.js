const express = require('express');
const cors = require('cors');
const createProductsRouter = require('./createProducts');
const buyProductsRouter = require('./buyProducts');
const getProductsRouter = require('./getProducts');
const db = require('./db');

const app = express();
const port = 3001;
const corsOptions = {
    origin: '*',
};

app.use(cors(corsOptions));
app.use(express.json());



// Initialize the products table if it doesn't exist
db.query(
    `CREATE TABLE IF NOT EXISTS products (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        price DECIMAL(10, 2) NOT NULL,
        picture VARCHAR(255) NOT NULL
    )`,
    (err) => {
        if (err) {
            console.error('Error creating table:', err);
        } else {
            console.log('Products table initialized');
        }
    }
);

// Use the routes
app.use('/', createProductsRouter);
app.use('/', buyProductsRouter);
app.use('/', getProductsRouter);

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
