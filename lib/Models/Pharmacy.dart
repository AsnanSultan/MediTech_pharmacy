import 'Product.dart';

class Pharmacy {
  String _id = "";
  String _name;
  String _email;
  String _phone;
  num _lat;
  num _lng;
  List<Product> products = [];
  Pharmacy(
      this._id, this._name, this._email, this._phone, this._lat, this._lng);
  Pharmacy.fromSnapshot(snapshot)
      : _id = snapshot.id,
        _name = snapshot.data()['name'],
        _email = snapshot.data()['email'],
        _phone = snapshot.data()['number'],
        _lat = snapshot.data()['lat'],
        _lng = snapshot.data()['lng'];

  num get lng => _lng;

  set lng(num value) {
    _lng = value;
  }

  num get lat => _lat;

  set lat(num value) {
    _lat = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
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
