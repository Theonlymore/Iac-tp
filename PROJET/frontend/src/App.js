import React, { useState, useEffect } from 'react';
import './App.css';
import { getProducts, createProduct, buyProduct } from './service';
import ProductList from './ProductList';

function App() {
  const [products, setProducts] = useState([]);

  // Fetch the list of products on component mount and periodically
  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const productsData = await getProducts();
        setProducts(productsData);
      } catch (error) {
        console.error('Error fetching products:', error);
      }
    };

    // Initial fetch
    fetchProducts();

    // Polling to fetch updates every second
    const intervalId = setInterval(fetchProducts, 1000);

    // Cleanup interval on component unmount
    return () => clearInterval(intervalId);
  }, []);

  // Create a random product
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

  // Buy a product
  const handleBuyProduct = async (productId) => {
    try {
      await buyProduct(productId);
      setProducts((prevProducts) => prevProducts.filter(product => product.id !== productId));
      alert('Product bought successfully!');
    } catch (error) {
      console.error('Error buying product:', error);
    }
  };

  return (
    <div className="App">
      <h1>Bienvenue</h1>
      <button onClick={createRandomProduct}>Create Object</button>
      <ProductList products={products} onBuyProduct={handleBuyProduct} />
    </div>
  );
}

export default App;
