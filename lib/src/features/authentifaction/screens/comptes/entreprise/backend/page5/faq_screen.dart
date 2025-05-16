import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {
      "question": "Comment créer un compte MBOX ?",
      "answer":
          "Vous pouvez créer un compte en sélectionnant votre rôle (client, transporteur, entreprise) puis en remplissant le formulaire d'inscription."
    },
    {
      "question": "Comment suivre un transport en temps réel ?",
      "answer":
          "Une fois connecté, accédez à la carte pour voir la position de vos camions en temps réel grâce à la géolocalisation intégrée."
    },
    {
      "question": "Comment contacter le support technique ?",
      "answer":
          "Depuis la page support, utilisez le bouton 'Chat support' pour discuter directement avec notre équipe."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQ"),
        backgroundColor: tPrimaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final faq = faqList[index];
          return _buildFaqItem(faq["question"]!, faq["answer"]!);
        },
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        collapsedBackgroundColor: Colors.grey.shade100,
        backgroundColor: Colors.white,
        iconColor: tPrimaryColor,
        collapsedIconColor: tPrimaryColor,
        leading: Icon(Icons.question_answer, color: tPrimaryColor),
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        children: [
          Text(
            answer,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
