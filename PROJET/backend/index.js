const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const port = 3001;

app.use(cors());
app.use(express.json());

// Database connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'rootpassword',
    database: 'testdb'
});

db.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
        return;
    }
    console.log('Connected to MySQL');
});

// API endpoints
app.post('/add', (req, res) => {
    const { name } = req.body;
    const sql = 'INSERT INTO test_table (name) VALUES (?)';
    db.query(sql, [name], (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send('Database error');
        } else {
            res.send('Data added successfully');
        }
    });
});

app.get('/get', (req, res) => {
    const sql = 'SELECT * FROM test_table';
    db.query(sql, (err, results) => {
        if (err) {
            console.error(err);
            res.status(500).send('Database error');
        } else {
            res.json(results);
        }
    });
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
