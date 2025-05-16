const bcrypt = require("bcryptjs");
const User = require("../models/user"); // Le modèle User

// Inscription
exports.signup = async (req, res) => {
  const { email, password } = req.body;

  // Vérifier si l'utilisateur existe déjà
  const existingUser = await User.findOne({ email: email.toLowerCase() });
  if (existingUser) {
    return res.status(400).json({ message: "Email déjà utilisé" });
  }

  // Hachage du mot de passe
  const hashedPassword = await bcrypt.hash(password, 10);

  // Création d'un nouvel utilisateur
  const newUser = new User({
    email: email.toLowerCase(),
    password: hashedPassword,
  });

  await newUser.save();

  res.status(201).json({ message: "Utilisateur créé avec succès" });
};

// Connexion
exports.login = async (req, res) => {
  const { email, password } = req.body;

  // Recherche de l'utilisateur par email
  const user = await User.findOne({ email: email.toLowerCase() });
  if (!user) {
    return res.status(401).json({ message: "Identifiant incorrect" });
  }

  // Comparaison du mot de passe
  const passwordMatch = await bcrypt.compare(password, user.password);
  if (!passwordMatch) {
    return res.status(401).json({ message: "Mot de passe incorrect" });
  }

  res.status(200).json({ message: "Connexion réussie" });
};
