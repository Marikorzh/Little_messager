import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messager/firebase_options.dart';
import 'package:messager/services/auth/auth_gate.dart';
import 'package:messager/services/auth/auth_service.dart';
import 'package:messager/services/chat/%D1%81hat_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ChatService().initPushNotification();
  runApp(
      ChangeNotifierProvider(
        create: (context) => AuthService(),
        child: const MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}



