import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_application_m3awda/firebase_options.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/client/client_screen.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/entreprise_screen.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/transporteur/transporteur_screen.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/splash_screen/splash_screen.dart';
import 'package:flutter_application_m3awda/src/repository/authentication_repository/authentication_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Injection de AuthenticationRepository
  Get.put(AuthenticationRepository());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/clientInterface': (context) => const ClientScreen(),
        '/transporteurInterface': (context) => TransporteurScreen(),
        '/entrepriseInterface': (context) => EntrepriseScreen(),
        // ⛔ PAS de '/truckForm' ici car il a besoin d'un paramètre
      },
    );
  }
}
