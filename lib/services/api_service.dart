import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visible_wallet_clone/models/wallet.dart';

class ApiService {
  static const String baseUrl = 'https://api.socialverseapp.com';

//---------------------------login-----------------------------------------
  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'mixed': username,
        'password': password,
      }),
    );
    print('-----------------------login-------------------');
    print('Login request URL: ${response.request!.url}');
    print('Login request headers: ${response.request!.headers}');
    // print('Login request body: ${response.request!.body}');
    print('Login response status: ${response.statusCode}');
    print('Login response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['token'];
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

//-----------------------------create----------------------------------------
  static Future<Wallet> createWallet(String token) async {
    final url = '$baseUrl/solana/wallet/create';
    final headers = {
      'Content-Type': 'application/json',
      'Flic-Token': token,
    };
    final body = jsonEncode({
      'wallet_name': "Michael's Wallet",
      'network': 'devnet',
      'user_pin': '123456',
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    print('-----------------------create-------------------');
    print('Create wallet request URL: ${response.request!.url}');
    print('Create wallet request headers: ${response.request!.headers}');
    print('Create wallet response status: ${response.statusCode}');
    print('Create wallet response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return Wallet.fromJson(responseBody);
    } else {
      throw Exception('Failed to create wallet: ${response.body}');
    }
  }

//-----------------------------retrieve---------------------------------------
  static Future<Wallet> retrieveBalance(String token, String address) async {
    final response = await http.get(
      Uri.parse('$baseUrl/solana/wallet/balance?address=$address'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return Wallet.fromJson(responseBody);
    } else {
      throw Exception('Failed to retrieve balance: ${response.body}');
    }
  }

//-------------------transfer-------------------------------------
  static Future<void> transferBalance(
      String token, String fromAddress, String toAddress, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/solana/wallet/transfer'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'fromAddress': fromAddress,
        'toAddress': toAddress,
        'amount': amount,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to transfer balance: ${response.body}');
    }
  }

//-----------------------airdrop------------------------------------------
  static Future<void> requestAirdrop(String token, String address) async {
    final response = await http.post(
      Uri.parse('$baseUrl/solana/wallet/airdrop'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'address': address,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to request airdrop: ${response.body}');
    }
  }
}
