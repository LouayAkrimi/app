import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';
import 'package:get_storage/get_storage.dart';

class TProfil extends StatefulWidget {
  @override
  _TProfilState createState() => _TProfilState();
}

class _TProfilState extends State<TProfil> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isDrawerOpen = false;
  late AnimationController _animationController;
  late Animation<Offset> _drawerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _drawerAnimation =
        Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.10, 0.0)).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOut));

    _nameController.text = GetStorage().read('userName') ?? '';
    _emailController.text = GetStorage().read('userEmail') ?? '';
    _phoneController.text = GetStorage().read('userPhone') ?? '';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      if (_isDrawerOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _closeDrawer() {
    setState(() {
      _isDrawerOpen = false;
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        centerTitle: true,
        backgroundColor: tPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: _toggleDrawer,
        ),
      ),
      body: Stack(
        children: [
          _buildProfileContent(context),
          if (_isDrawerOpen)
            GestureDetector(
              onTap: _closeDrawer,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          SlideTransition(
            position: _drawerAnimation,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: screenWidth * 0.90, // 90% de l'écran
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(-5, 0),
                    ),
                  ],
                ),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(); // Exemple action de logout
                    },
                    icon: Icon(Icons.logout, size: 24), // Icône stylée
                    label: Text(
                      "LOGOUT", // Texte en majuscules
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          ColorRed, // Utilisation de la couleur définie
                      foregroundColor: Colors.white, // Texte blanc
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(50), // Arrondi premium
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: tPrimaryColor,
                        width: 3,
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/images/profile.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tPrimaryColor,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.white, size: 20),
                        onPressed: () {
                          // Ajouter la logique pour changer l'image de profil
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextField('Nom', Icons.person, _nameController),
                    SizedBox(height: 16),
                    buildTextField('Email', Icons.email, _emailController),
                    SizedBox(height: 16),
                    buildTextField('Téléphone', Icons.phone, _phoneController),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    GetStorage().write('userName', _nameController.text);
                    GetStorage().write('userEmail', _emailController.text);
                    GetStorage().write('userPhone', _phoneController.text);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Modifications enregistrées !'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [tPrimaryColor, tSecondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Enregistrer les modifications',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: tDarkColor,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Entrez votre $label',
            prefixIcon: Icon(icon, color: tPrimaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: tPrimaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: tPrimaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }
}
