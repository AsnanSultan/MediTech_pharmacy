class Product {
  String _id;
  String _name;
  String _category;
  num _sellPrice;
  num _purchasePrice;
  String _description;
  int _totalItem;
  String _expireDate;
  String _imagePath;
  String _pharmacyId;

  Product(
      this._id,
      this._name,
      this._category,
      this._sellPrice,
      this._purchasePrice,
      this._description,
      this._totalItem,
      this._expireDate,
      this._imagePath,
      this._pharmacyId);

  Product.fromSnapshot(snapshot)
      : _id = snapshot.id,
        _name = snapshot.data()["Name"],
        _category = snapshot.data()["category"],
        _sellPrice = snapshot.data()["sellPrice"],
        _purchasePrice = snapshot.data()["purchasePrice"],
        _description = snapshot.data()["description"],
        _totalItem = snapshot.data()["totalItems"],
        _expireDate = snapshot.data()["expireDate"],
        _imagePath = snapshot.data()["imageUrl"],
        _pharmacyId = snapshot.data()["pharmacyId"];

  String get pharmacyId => _pharmacyId;

  set pharmacyId(String value) {
    _pharmacyId = value;
  }

  String get imagePath => _imagePath;

  set imagePath(String value) {
    _imagePath = value;
  }

  String get expireDate => _expireDate;

  set expireDate(String value) {
    _expireDate = value;
  }

  int get totalItem => _totalItem;

  set totalItem(int value) {
    _totalItem = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  num get purchasePrice => _purchasePrice;

  set purchasePrice(num value) {
    _purchasePrice = value;
  }

  num get sellPrice => _sellPrice;

  set sellPrice(num value) {
    _sellPrice = value;
  }

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
