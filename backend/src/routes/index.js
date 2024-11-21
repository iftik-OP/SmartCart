const express = require('express');
const router = express.Router();

const firebaseAuthController = require('../controllers/firebase-auth-controller');
const cartController = require('../controllers/cart-controller');
const productController = require('../controllers/product-controller');

router.post('/api/register', firebaseAuthController.registerUser);
router.post('/api/login', firebaseAuthController.loginUser);
router.post('/api/logout', firebaseAuthController.logoutUser);
router.post('/api/reset-password', firebaseAuthController.resetPassword);

router.post('/api/cart/add', cartController.addItemToCart);
router.post('/api/cart/add-online', cartController.addToCartOnline);
router.post('/api/cart/remove', cartController.removeItemFromCart);

router.get('/products', productController.getAllProducts);

module.exports = router;