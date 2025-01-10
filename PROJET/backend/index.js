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

// Use the routes
app.use('/', createProductsRouter);
app.use('/', buyProductsRouter);
app.use('/', getProductsRouter);

// Start the server after connecting to the database
db.connect((err) => {
    if (err) {
        console.error('Failed to connect to the database:', err);
        process.exit(1); // Exit the process if DB connection fails
    }

    app.listen(port, () => {
        console.log(`Server is running on http://localhost:${port}`);
    });
});
