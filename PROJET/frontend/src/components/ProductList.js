// components/ProductList.js
import React from 'react';
import ProductCard from './ProductCard';

const ProductList = ({ products, onBuyProduct }) => {
    return (
        <div className="product-list">
            {products.map((product) => (
                <ProductCard key={product.id} product={product} onBuyProduct={onBuyProduct} />
            ))}
        </div>
    );
};

export default ProductList;
