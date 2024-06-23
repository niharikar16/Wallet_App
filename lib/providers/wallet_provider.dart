import 'package:flutter/material.dart';
import 'package:visible_wallet_clone/models/wallet.dart';
import 'package:visible_wallet_clone/services/api_service.dart';

class WalletProvider with ChangeNotifier {
  Wallet? _wallet;
  bool _loading = false;
  String _error = '';

  Wallet? get wallet => _wallet;
  bool get loading => _loading;
  String get error => _error;

  Future<void> createWallet(String token) async {
    _setLoading(true);
    try {
      _wallet = await ApiService.createWallet(token);
      _setError('');
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> retrieveBalance(String token) async {
    if (_wallet == null) return;
    _setLoading(true);
    try {
      _wallet = await ApiService.retrieveBalance(token, _wallet!.address);
      _setError('');
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> transferBalance(
      String token, String toAddress, double amount) async {
    if (_wallet == null) return;
    _setLoading(true);
    try {
      await ApiService.transferBalance(
          token, _wallet!.address, toAddress, amount);
      await retrieveBalance(token);
      _setError('');
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> requestAirdrop(String token) async {
    if (_wallet == null) return;
    _setLoading(true);
    try {
      await ApiService.requestAirdrop(token, _wallet!.address);
      await retrieveBalance(token);
      _setError('');
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
}
