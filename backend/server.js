const express = require('express');
const firebaseAdmin = require('firebase-admin');
const cors = require('cors');
const bodyParser = require('body-parser');

// Initialiser Firebase Admin SDK avec les clés privées
const serviceAccount = require('./config/serviceAccountKey.json');

firebaseAdmin.initializeApp({
  credential: firebaseAdmin.credential.cert(serviceAccount),
});

const app = express();
app.use(cors());
app.use(bodyParser.json()); // Parse les requêtes JSON

// Exemple de route d'authentification
app.post('/api/auth/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    // Authentification via Firebase Authentication
    const userRecord = await firebaseAdmin.auth().getUserByEmail(email);

    // Vérifier le mot de passe (Firebase Admin SDK ne gère pas la vérification du mot de passe directement)
    // Ici, tu devras utiliser Firebase Authentication côté client pour vérifier le mot de passe avant d'envoyer la requête à ton backend.

    // Si l'utilisateur est trouvé, tu peux envoyer une réponse de succès
    res.json({ message: 'Utilisateur authentifié avec succès', user: userRecord });
  } catch (error) {
    res.status(400).json({ error: 'Utilisateur introuvable ou mot de passe incorrect' });
  }
});

// Démarre ton serveur
app.listen(3000, () => {
  console.log('Serveur en cours d\'exécution sur le port 3000');
});
