import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:practica5/src/models/Product.dart';
import 'package:practica5/src/providers/firebase.dart';

class CreateProduct extends StatefulWidget {
  CreateProduct({Key key}) : super(key: key);

  @override
  _CreateProductState createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  FirebaseProvider _provider;
  FirebaseStorage _storage;
  TextEditingController txtClave = TextEditingController();
  TextEditingController txtDescription = TextEditingController();
  TextEditingController txtModel = TextEditingController();

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _provider = FirebaseProvider();
    _storage = FirebaseStorage.instanceFor(
      bucket: 'gs://patm1-b339c.appspot.com/images',
    );
  }

  String imagePath = "";

  @override
  Widget build(BuildContext context) {
    final imgFinal = imagePath == ""
        ? CircleAvatar(
            backgroundImage: NetworkImage(
                "https://image.shutterstock.com/image-vector/red-vector-banner-new-product-260nw-1135814726.jpg"),
          )
        : ClipOval(
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
          );

    final camara = FloatingActionButton(
      child: Icon(Icons.camera_alt, color: Colors.white),
      onPressed: () async {
        await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
          setState(() {
            imagePath = image.path;
          });
        });
      },
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("Productos"),
          actions: <Widget>[
            MaterialButton(
                child: Icon(Icons.save, color: Colors.white),
                onPressed: () async {
                  String url = "";
                  File img = File(imagePath);
                  var now = new DateTime.now();
                  Reference ref = _storage.ref('images/${now}.png');

                  ref.putFile(img).whenComplete(() async {
                    var dowurl = await ref.getDownloadURL();
                    url = dowurl.toString();

                    final product = ProductDAO(
                      clave: txtClave.text,
                      description: txtDescription.text,
                      model: txtModel.text,
                      image: url,
                    );

                    _provider.saveProduct(product);
                    Navigator.pop(context);
                  });
                })
          ],
        ),
        body: Stack(children: <Widget>[
          Container(
              child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                  height: 200.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: imgFinal),
              camara,
              SizedBox(height: 20),
              Card(
                  elevation: 6.0,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: TextField(
                        controller: txtClave,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Clave del producto',
                        ),
                      ))),
              SizedBox(height: 20),
              Card(
                  elevation: 6.0,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: TextField(
                        controller: txtDescription,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Descripción',
                        ),
                      ))),
              SizedBox(height: 20),
              Card(
                  elevation: 6.0,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: TextField(
                        controller: txtModel,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Model',
                        ),
                      ))),
            ],
          ))
        ]));
  }
}
