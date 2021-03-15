import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/httpException.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) return _token;

    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '$urlSegment',
      {'key': 'AIzaSyAMindyrePrbRPAr48DAsmAalGnuH0Q2ms'},
    );

    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['error']['message']);
    }
    _token = responseData['idToken'];
    _expiryDate = DateTime.now().add(Duration(
      seconds: int.parse(responseData['expiresIn']),
    ));
    _userId = responseData['localId'];

    print(_token);

    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    print('signin up');
    return _authenticate(email, password, '/v1/accounts:signUp');
  }

  Future<void> login(String email, String password) async {
    print('loggin in');
    return _authenticate(email, password, '/v1/accounts:signInWithPassword');
  }
}
