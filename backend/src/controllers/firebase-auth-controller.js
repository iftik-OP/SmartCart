const { 
  auth, 
  createUserWithEmailAndPassword, 
  signInWithEmailAndPassword, 
  signOut, 
  sendEmailVerification,
  sendPasswordResetEmail
} = require('../config/firebase');

const { admin } = require('../config/firebase');

class FirebaseAuthController {
  async registerUser(req, res) {
      const { email, password, name, phoneNumber } = req.body;
      
      if (!email || !password || !name || !phoneNumber) {
        return res.status(422).json({
          email: "Email is required",
          password: "Password is required",
          name: "Name is required",
          phoneNumber: "Phone number is required"
        });
      }
  
      try {
        // Create user with email and password
        const userCredential = await createUserWithEmailAndPassword(auth, email, password);
        
        // Send email verification
        await sendEmailVerification(auth.currentUser);
        
        // Store user details in Firestore
        await admin.firestore().collection('users').doc(userCredential.user.uid).set({
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          cart: []
        });
        
        res.status(201).json({ message: "Verification email sent! User created successfully!" });
      } catch (error) {
        console.error('Error during sign-up:', error);
        const errorMessage = error.message || "An error occurred while registering user";
        res.status(500).json({ error: errorMessage });
      }
    }
    
    async loginUser(req, res) {
      const { email, password } = req.body;
      if (!email || !password) {
          return res.status(422).json({
              email: "Email is required",
              password: "Password is required",
          });
      }

      try {
          // Authenticate user with email and password
          const userCredential = await signInWithEmailAndPassword(auth, email, password);
          const user = userCredential.user;

          // Check if email is verified
          if (!user.emailVerified) {
              return res.status(403).json({
                  error: "Email not verified. Please check your inbox for the verification email."
              });
          }

          const userId = user.uid;

          // Fetch user details from Firestore
          const userDoc = await admin.firestore().collection('users').doc(userId).get();

          if (!userDoc.exists) {
              return res.status(404).json({ error: "User data not found" });
          }

          const userData = userDoc.data();

          // Set the JWT token as a cookie
          const idToken = userCredential._tokenResponse.idToken;
          if (idToken) {
              res.cookie('access_token', idToken, { httpOnly: true });
              return res.status(200).json({
                  message: "User logged in successfully",
                  user: {
                      id: userId,
                      name: userData.name,
                      email: userData.email,
                      cart: userData.cart
                  }
              });
          } else {
              return res.status(500).json({ error: "Internal Server Error" });
          }

      } catch (error) {
          console.error('Error during login:', error);
          const errorMessage = error.message || "An error occurred while logging in";
          return res.status(500).json({ error: errorMessage });
      }
  }

  logoutUser(req, res) {
      signOut(auth)
      .then(() => {
          res.clearCookie('access_token');
          res.status(200).json({ message: "User logged out successfully" });
      })
      .catch((error) => {
          console.error(error);
          res.status(500).json({ error: "Internal Server Error" });
      });
  }

  resetPassword(req, res) {
      const { email } = req.body;
      if (!email) {
        return res.status(422).json({
          email: "Email is required"
        });
      }
      sendPasswordResetEmail(auth, email)
        .then(() => {
          res.status(200).json({ message: "Password reset email sent successfully!" });
        })
        .catch((error) => {
          console.error(error);
          res.status(500).json({ error: "Internal Server Error" });
        });
  }
}

module.exports = new FirebaseAuthController();
