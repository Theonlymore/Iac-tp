// service/ProductService.js
import axios from 'axios';

// Use environment variable or fallback to a default value
const API_URL = process.env.REACT_APP_API_URL || 'Incorrect-Host';

/**
 * Fetch all products
 */
export const getProducts = async () => {
    try {
        const response = await axios.get(`${API_URL}/get-products`);
        return response.data;
    } catch (error) {
        console.error('Error fetching products:', error);
        throw error;
    }
};

/**
 * Create a new product
 */
export const createProduct = async (product) => {
    try {
        const response = await axios.post(`${API_URL}/create-product`, product);
        return response.data;
    } catch (error) {
        console.error('Error creating product:', error);
        throw error;
    }
};

/**
 * Buy a product
 */
export const buyProduct = async (productId) => {
    try {
        const response = await axios.post(`${API_URL}/buy-product`, { productId });
        return response.data;
    } catch (error) {
        console.error('Error buying product:', error);
        throw error;
    }
};

/**
 * Send a custom message to Discord
 **/

export const sendDiscordMessage = async (message) => {
    try {
        // We post the message to /send-message
        const response = await axios.post(`${API_URL}/send-message`, { message });
        return response.data; // Might be: "Message sent to Discord: <message>"
    } catch (error) {
        console.error('Error sending Discord message:', error);
        throw error;
    }
};