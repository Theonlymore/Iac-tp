// serverWithDiscordWebhook.js
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const axios = require('axios');

// Existing routers
const createProductsRouter = require('./createProducts');
const buyProductsRouter = require('./buyProducts');
const getProductsRouter = require('./getProducts');
const db = require('./db');

const app = express();
const port = 3001;

// Configure CORS
app.use(cors({ origin: '*' }));
app.use(express.json());

// Load webhook info from environment variables
const { DISCORD_WEBHOOK_ID, DISCORD_WEBHOOK_TOKEN } = process.env;
const DISCORD_WEBHOOK_URL = `https://discord.com/api/webhooks/${DISCORD_WEBHOOK_ID}/${DISCORD_WEBHOOK_TOKEN}`;

// Use your existing routes
app.use('/', createProductsRouter);
app.use('/', buyProductsRouter);
app.use('/', getProductsRouter);

// Single endpoint for sending Discord messages
app.post('/send-message', async (req, res) => {
    try {
        // The frontend should send { "message": "some text" } in the request body
        const { message } = req.body;
        if (!message) {
            return res.status(400).send('No message provided');
        }

        // Post the message to Discord via the webhook
        await axios.post(DISCORD_WEBHOOK_URL, {
            content: message,
        });

        // Return a success response
        return res.status(200).send(`Message sent to Discord: ${message}`);
    } catch (err) {
        console.error('Error sending message to Discord webhook:', err);
        return res.status(500).send('Failed to send message to Discord webhook');
    }
});

// DB connect & start server
db.connect((err) => {
    if (err) {
        console.error('Failed to connect to the database:', err);
        process.exit(1);
    }
    app.listen(port, () => {
        console.log(`Server is running on http://localhost:${port}`);
        console.log('Ready to send messages via Discord Webhook!');
    });
});
