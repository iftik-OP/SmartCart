const { admin } = require('../config/firebase');  // Import Firebase Admin SDK

class CartController {

    // Add an item to the cart
    async addItemToCart(req, res) {
        const { userId, stockId, itemId } = req.body;
    
        if (!userId || !stockId || !itemId) {
            return res.status(422).json({ 
                error: "User ID, Stock ID, and Item ID are required" 
            });
        }
    
        try {
            const stockRef = admin.firestore().collection('Stock').doc(stockId);
            const stockSnapshot = await stockRef.get();
    
            if (!stockSnapshot.exists) {
                return res.status(404).json({ error: "Stock not found" });
            }
    
            const stockData = stockSnapshot.data();
    
            // Find the item in the product's items array
            const itemIndex = stockData.items.indexOf(itemId);
            if (itemIndex === -1) {
                return res.status(404).json({ error: "Item not found in stock" });
            }
    
            // Remove the item from the 'items' array of the Stock document
            stockData.items.splice(itemIndex, 1);
            await stockRef.update({ items: stockData.items });
    
            const userCartRef = admin.firestore().collection('users').doc(userId);
            const userDoc = await userCartRef.get();
    
            if (!userDoc.exists) {
                return res.status(404).json({ error: "User not found" });
            }
    
            const userCart = userDoc.data().cart || [];
            let itemExists = false;
    
            // Check if the stockId is already in the user's cart
            userCart.forEach(cartItem => {
                if (cartItem.stockId === stockId) {
                    cartItem.itemIds.push(itemId);  // Add itemId to the list
                    cartItem.quantity = cartItem.itemIds.length;  // Update quantity
                    itemExists = true;
                }
            });
    
            if (!itemExists) {
                // Add a new entry to the cart if the product isn't already there
                userCart.push({
                    stockId,
                    name: stockData.title,
                    itemIds: [itemId],
                    quantity: 1
                });
            }
    
            // Update the user's cart
            await userCartRef.update({ cart: userCart });
    
            res.status(200).json({ 
                message: "Item added to cart and removed from stock successfully" 
            });
        } catch (error) {
            console.error('Error adding item to cart:', error);
            res.status(500).json({ error: "Internal Server Error" });
        }
    }

    // New method: addToCartOnline
    async addToCartOnline(req, res) {
        const { userId, stockId } = req.body; // Only userId and stockId are required

        if (!userId || !stockId) {
            return res.status(422).json({
                error: "User ID and Stock ID are required"
            });
        }

        try {
            const stockRef = admin.firestore().collection('Stock').doc(stockId);
            const stockSnapshot = await stockRef.get();

            if (!stockSnapshot.exists) {
                return res.status(404).json({ error: "Stock not found" });
            }

            const stockData = stockSnapshot.data();

            // Check if there are any items in the stock
            if (!stockData.items || stockData.items.length === 0) {
                return res.status(404).json({ error: "No items available in stock" });
            }

            // Pick a random item from the stock's items array
            const randomItemId = stockData.items[Math.floor(Math.random() * stockData.items.length)];

            // Remove the selected random item from the 'items' array of the Stock document
            stockData.items = stockData.items.filter(itemId => itemId !== randomItemId);
            await stockRef.update({ items: stockData.items });

            const userCartRef = admin.firestore().collection('users').doc(userId);
            const userDoc = await userCartRef.get();

            if (!userDoc.exists) {
                return res.status(404).json({ error: "User not found" });
            }

            const userCart = userDoc.data().cart || [];
            let itemExists = false;

            // Check if the stockId is already in the user's cart
            userCart.forEach(cartItem => {
                if (cartItem.stockId === stockId) {
                    cartItem.itemIds.push(randomItemId);  // Add the random itemId to the list
                    cartItem.quantity = cartItem.itemIds.length;  // Update quantity
                    itemExists = true;
                }
            });

            if (!itemExists) {
                // Add a new entry to the cart if the product isn't already there
                userCart.push({
                    stockId,
                    name: stockData.title,
                    itemIds: [randomItemId],
                    quantity: 1
                });
            }

            // Update the user's cart
            await userCartRef.update({ cart: userCart });

            res.status(200).json({
                message: "Random item added to cart and removed from stock successfully",
                addedItemId: randomItemId
            });
        } catch (error) {
            console.error('Error adding random item to cart:', error);
            res.status(500).json({ error: "Internal Server Error" });
        }
    }
    
    // Remove an item from the cart
    async removeItemFromCart(req, res) {
        const { userId, stockId, itemId } = req.body;
    
        if (!userId || !stockId || !itemId) {
            return res.status(422).json({ 
                error: "User ID, Stock ID, and Item ID are required" 
            });
        }
    
        try {
            const userCartRef = admin.firestore().collection('users').doc(userId);
            const userDoc = await userCartRef.get();
    
            if (!userDoc.exists) {
                return res.status(404).json({ error: "User not found" });
            }
    
            const userCart = userDoc.data().cart || [];
            let itemRemoved = false;
    
            // Find and remove the item from the user's cart
            userCart.forEach((cartItem, index) => {
                if (cartItem.stockId === stockId) {
                    const itemIndex = cartItem.itemIds.indexOf(itemId);
                    if (itemIndex > -1) {
                        cartItem.itemIds.splice(itemIndex, 1);  // Remove the itemId
                        cartItem.quantity = cartItem.itemIds.length;  // Update quantity
    
                        if (cartItem.quantity === 0) {
                            // Remove the entire product if no items left
                            userCart.splice(index, 1);
                        }
    
                        itemRemoved = true;
                    }
                }
            });
    
            if (!itemRemoved) {
                return res.status(404).json({ error: "Item not found in cart" });
            }
    
            // Add the item back to the 'items' array in the Stock document
            const stockRef = admin.firestore().collection('Stock').doc(stockId);
            const stockSnapshot = await stockRef.get();
    
            if (!stockSnapshot.exists) {
                return res.status(404).json({ error: "Stock not found" });
            }
    
            const stockData = stockSnapshot.data();
            stockData.items.push(itemId);  // Add the item back to the stock's items array
            await stockRef.update({ items: stockData.items });
    
            // Update the user's cart
            await userCartRef.update({ cart: userCart });
    
            res.status(200).json({ 
                message: "Item removed from cart and added back to stock successfully" 
            });
        } catch (error) {
            console.error('Error removing item from cart:', error);
            res.status(500).json({ error: "Internal Server Error" });
        }
    }
}

module.exports = new CartController();
