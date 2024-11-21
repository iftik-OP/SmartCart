const { admin } = require('../config/firebase');

class ProductController {

    async getAllProducts(req, res) {
        try {
            const stockCollectionRef = admin.firestore().collection('Stock');
            const stockSnapshot = await stockCollectionRef.get();
            const products = [];

            stockSnapshot.forEach(stockDoc => {
                const stockData = stockDoc.data();

                products.push({
                    id: stockData.id,         // Stock document ID
                    title: stockData.title,         // Product name
                    price: stockData.price,        // Product price
                    description: stockData.description,  // Product description
                    imageUrl: stockData.imageURL,   // Product image URL
                    category: stockData.category,
                    items: stockData.items.length  // Number of items in the 'items' array
                });
            });

            res.status(200).json(products);

        } catch (error) {
            console.error('Error fetching products:', error);
            res.status(500).json({ error: "Internal Server Error" });
        }
    }
}

module.exports = new ProductController();
