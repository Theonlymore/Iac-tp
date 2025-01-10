// service/ProductService.js
import axios from 'axios';

// Use environment variable or fallback to a default value
const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3001';

// Function to get the list of products
export const getProducts = async () => {
    try {
        const response = await axios.get(`${API_URL}/get-products`);
        return response.data;
    } catch (error) {
        console.error('Error fetching products:', error);
        throw error;
    }
};

// Function to create a new product
export const createProduct = async (product) => {
    try {
        const response = await axios.post(`${API_URL}/create-product`, product);
        return response.data;
    } catch (error) {
        console.error('Error creating product:', error);
        throw error;
    }
};

// Function to buy a product
export const buyProduct = async (productId) => {
    try {
        const response = await axios.post(`${API_URL}/buy-product`, { productId });
        return response.data;
    } catch (error) {
        console.error('Error buying product:', error);
        throw error;
    }
};
