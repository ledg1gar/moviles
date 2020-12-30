import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica5/src/screens/createProduct.dart';
import 'package:practica5/src/screens/productsList.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          debugPrint("${snapshot.error}");
          return MaterialApp(home: Text("Algo salio mal"));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            home: ProductsList(),
            routes: {
              '/create': (BuildContext context) => CreateProduct(),
              '/home': (BuildContext context) => ProductsList(),
            },
          );
        }

        return MaterialApp(home: Text("Cargando . . ."));
      },
    );
  }
}
