// serverWithDiscordBot.js
const express = require('express');
const cors = require('cors');
const { Client, GatewayIntentBits } = require('discord.js');

// These are your existing routers and DB connection
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

// Replace with your actual Discord bot token and channel ID
const DISCORD_BOT_TOKEN = 'YOUR_DISCORD_BOT_TOKEN';
const DISCORD_CHANNEL_ID = 'YOUR_DISCORD_CHANNEL_ID';

// Create a new Discord client
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent
    ]
});

// Use your existing routes
app.use('/', createProductsRouter);
app.use('/', buyProductsRouter);
app.use('/', getProductsRouter);

/**
 * Example route #1
 * Sends a specific message to the Discord channel
 */
app.post('/send-message', async (req, res) => {
    try {
        // Fetch the channel
        const channel = await client.channels.fetch(DISCORD_CHANNEL_ID);
        if (!channel) {
            return res.status(404).send('Discord channel not found.');
        }

        // Send a message
        await channel.send('Hello from the /send-message route!');
        res.send('Message sent!');
    } catch (err) {
        console.error('Error sending message to Discord:', err);
        res.status(500).send('Failed to send message to Discord');
    }
});

/**
 * Example route #2
 * Sends another, different message to the same Discord channel
 */
app.post('/send-another-message', async (req, res) => {
    try {
        // Fetch the channel
        const channel = await client.channels.fetch(DISCORD_CHANNEL_ID);
        if (!channel) {
            return res.status(404).send('Discord channel not found.');
        }

        // Send a different message
        await channel.send('Another message from the /send-another-message route!');
        res.send('Another message sent!');
    } catch (err) {
        console.error('Error sending another message to Discord:', err);
        res.status(500).send('Failed to send another message to Discord');
    }
});

// Connect to the database, then start the server and Discord bot
db.connect((err) => {
    if (err) {
        console.error('Failed to connect to the database:', err);
        process.exit(1); // Exit the process if DB connection fails
    }

    app.listen(port, async () => {
        console.log(`Server is running on http://localhost:${port}`);

        try {
            // Login to Discord when the server starts
            await client.login(DISCORD_BOT_TOKEN);
            console.log('Discord bot is online!');
        } catch (botErr) {
            console.error('Failed to start Discord bot:', botErr);
        }
    });
});
