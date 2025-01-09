// hooks/useProducts.js
import { useState, useEffect } from 'react';
import { getProducts, createProduct, buyProduct } from '../service/ProductService';

const useProducts = () => {
    const [products, setProducts] = useState([]);

    useEffect(() => {
        const fetchProducts = async () => {
            try {
                const productsData = await getProducts();
                setProducts(productsData);
            } catch (error) {
                console.error('Error fetching products:', error);
            }
        };

        fetchProducts();
        const intervalId = setInterval(fetchProducts, 1000);
        return () => clearInterval(intervalId);
    }, []);

    const createRandomProduct = async () => {
        const randomProduct = {
            name: `Product ${Math.floor(Math.random() * 1000)}`,
            description: 'This is a random product description.',
            price: (Math.random() * 100).toFixed(2),
            picture: `https://picsum.photos/200/300?random=${Math.floor(Math.random() * 1000)}`
        };

        try {
            await createProduct(randomProduct);
            setProducts((prevProducts) => [...prevProducts, randomProduct]);
        } catch (error) {
            console.error('Error creating product:', error);
        }
    };

    const handleBuyProduct = async (productId) => {
        try {
            await buyProduct(productId);
            setProducts((prevProducts) => prevProducts.filter(product => product.id !== productId));
            alert('Product bought successfully!');
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
