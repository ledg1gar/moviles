class ProductDAO {
  String model;
  String description;
  String image;
  String clave;

  ProductDAO({this.model, this.description, this.image, this.clave});

  Map<String, dynamic> toMap() {
    return {"model": model, "description": description, "image": image, "clave" : clave};
  }
}
