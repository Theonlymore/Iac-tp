// App.js
import React from 'react';
import './App.css';
import useProducts from './hooks/useProducts';  // Correct path
import ProductList from './components/ProductList';

function App() {
  const { products, createRandomProduct, handleBuyProduct } = useProducts();

  return (
    <div className="App">
      <div className="hero">
        <h1>Bienvenue sur Néo-Earth!</h1>
        <p>Explorez notre site de vente de photos uniques de Néo-Earth, une planète lointaine semblable à la Terre. Découvrez des paysages spectaculaires et des souvenirs inoubliables, directement depuis l’espace!</p>
      </div>

      <div className="product-section">
        <button className="create-button" onClick={createRandomProduct}>Créer un Objet</button>
        <ProductList products={products} onBuyProduct={handleBuyProduct} />
      </div>
    </div>
  );
}

export default App;
