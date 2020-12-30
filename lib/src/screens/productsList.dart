import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica5/src/providers/firebase.dart';
import 'package:practica5/src/views/CardProduct.dart';

class ProductsList extends StatefulWidget {
  ProductsList({Key key}) : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  FirebaseProvider _provider;

  @override
  void initState() {
    super.initState();

    _provider = FirebaseProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos"),
        actions: <Widget>[
          MaterialButton(
              child: Icon(Icons.add_circle, color: Colors.amber),
              onPressed: () {
                Navigator.pushNamed(context, "/create");
              })
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _provider.getAllProducts(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return CircularProgressIndicator();
          else {
            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return CardProduct(productDocument: document);
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
