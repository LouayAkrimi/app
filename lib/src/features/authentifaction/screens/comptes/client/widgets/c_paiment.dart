import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';

class PaiementScreen extends StatefulWidget {
  const PaiementScreen({Key? key}) : super(key: key);

  @override
  _PaiementScreenState createState() => _PaiementScreenState();
}

class _PaiementScreenState extends State<PaiementScreen> {
  int soldePoints = 1500;
  double soldeEnArgent = 100.0;
  TextEditingController montantController = TextEditingController();
  bool isLoading = false;

  void convertirEnPoints(double montant) {
    if (montant <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez entrer un montant valide")),
      );
      return;
    }

    setState(() {
      int pointsConvertis = (montant * 10).toInt();
      soldePoints += pointsConvertis;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$pointsConvertis points ajoutés avec succès")),
      );
    });
  }

  void ajouterCarte() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AjouterCarteScreen(
          onPaiementSuccess: (montant) {
            convertirEnPoints(montant);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet,
                        color: tPrimaryColor, size: 40),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Solde des points",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("$soldePoints pts",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: montantController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Montant (TND)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.monetization_on, color: tPrimaryColor),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ajouterCarte,
              style: ElevatedButton.styleFrom(
                backgroundColor: tPrimaryColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Ajouter une carte bancaire"),
            ),
          ],
        ),
      ),
    );
  }
}

class AjouterCarteScreen extends StatefulWidget {
  final Function(double) onPaiementSuccess;
  AjouterCarteScreen({required this.onPaiementSuccess, Key? key})
      : super(key: key);

  @override
  _AjouterCarteScreenState createState() => _AjouterCarteScreenState();
}

class _AjouterCarteScreenState extends State<AjouterCarteScreen> {
  TextEditingController numeroCarteController = TextEditingController();
  TextEditingController dateExpirationController = TextEditingController();
  TextEditingController codeSecuriteController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: numeroCarteController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Numéro de carte',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.credit_card, color: tPrimaryColor),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: dateExpirationController,
              decoration: InputDecoration(
                labelText: 'Date d\'expiration (MM/AA)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.calendar_today, color: tPrimaryColor),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: codeSecuriteController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Code de sécurité',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.lock, color: tPrimaryColor),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (numeroCarteController.text.isEmpty ||
                    dateExpirationController.text.isEmpty ||
                    codeSecuriteController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Veuillez remplir tous les champs")),
                  );
                  return;
                }
                setState(() {
                  isLoading = true;
                });
                await Future.delayed(Duration(seconds: 2));
                widget.onPaiementSuccess(10.0);
                setState(() {
                  isLoading = false;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: tPrimaryColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Payer et convertir"),
            ),
          ],
        ),
      ),
    );
  }
}
