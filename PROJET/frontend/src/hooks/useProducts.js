// hooks/useProducts.js
import { useState, useEffect } from 'react';
import {
    getProducts,
    createProduct,
    buyProduct,
    sendDiscordMessage
} from '../service/ProductService';

const useProducts = () => {
    const [products, setProducts] = useState([]);

    useEffect(() => {
        const fetchProducts = async () => {
            try {
                const data = await getProducts();
                setProducts(data);
            } catch (error) {
                console.error('Error fetching products:', error);
            }
        };

        fetchProducts();
        const intervalId = setInterval(fetchProducts, 1000);
        return () => clearInterval(intervalId);
    }, []);

    // 1) Create
    const createRandomProduct = async () => {
        const randomProduct = {
            name: `Product ${Math.floor(Math.random() * 1000)}`,
            description: 'This is a random product description.',
            price: (Math.random() * 100).toFixed(2),
            picture: `https://picsum.photos/200/300?random=${Math.floor(Math.random() * 1000)}`
        };

        try {
            // Create the product
            await createProduct(randomProduct);
            setProducts((prev) => [...prev, randomProduct]);

            // Send different message for create
            await sendDiscordMessage(`Object created: ${randomProduct.name} (Price: $${randomProduct.price})`);
        } catch (error) {
            console.error('Error creating product:', error);
        }
    };

    // 2) Buy
    const handleBuyProduct = async (productId) => {
        try {
            // Buy the product
            await buyProduct(productId);
            setProducts((prev) => prev.filter((p) => p.id !== productId));

            // Send different message for buy
            await sendDiscordMessage(`Object bought: Product ID ${productId}`);
        } catch (error) {
            console.error('Error buying product:', error);
        }
    };

    return {
        products,
        createRandomProduct,
        handleBuyProduct,
    };
};

export default useProducts;
