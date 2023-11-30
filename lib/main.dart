import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jimmy_exchange/firebase_options.dart';

import 'app/app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    //initialize firebase from firebase core plugin
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {}
  runApp(MyApp());
}
