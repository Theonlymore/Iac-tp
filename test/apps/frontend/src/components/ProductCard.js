import React from 'react';

const ProductCard = ({ product, onBuyProduct }) => {
    return (
        <div className="product-card">
            <img src={product.picture} alt={product.name} />
            <h2>{product.name}</h2>
            <p>{product.description}</p>
            <p>Price: ${product.price}</p>
            <button onClick={() => onBuyProduct(product.id)}>Buy</button>
        </div>
    );
};

export default ProductCard;
