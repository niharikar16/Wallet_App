import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visible_wallet_clone/providers/wallet_provider.dart';

class WalletScreen extends StatelessWidget {
  final String token;

  WalletScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WalletProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Wallet'),
        ),
        body: WalletScreenBody(token: token),
      ),
    );
  }
}

class WalletScreenBody extends StatefulWidget {
  final String token;

  WalletScreenBody({required this.token});

  @override
  _WalletScreenBodyState createState() => _WalletScreenBodyState();
}

class _WalletScreenBodyState extends State<WalletScreenBody> {
  final _toAddressController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<WalletProvider>(context, listen: false)
          .createWallet(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);

    return walletProvider.loading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // if (walletProvider.error.isNotEmpty)
              //   Text(walletProvider.error, style: TextStyle(color: Colors.red)),

              Text('Balance: ${walletProvider.wallet?.balance ?? 0.0}'),
              ElevatedButton(
                onPressed: () => walletProvider.retrieveBalance(widget.token),
                child: Text('Refresh Balance'),
              ),
              TextField(
                controller: _toAddressController,
                decoration: InputDecoration(labelText: 'Recipient Address'),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  double amount =
                      double.tryParse(_amountController.text) ?? 0.0;
                  if (amount <= 0.0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid amount.')),
                    );
                  } else {
                    walletProvider.transferBalance(
                        widget.token, _toAddressController.text, amount);
                  }
                },
                child: Text('Transfer'),
              ),
              ElevatedButton(
                onPressed: () => walletProvider.requestAirdrop(widget.token),
                child: Text('Request Airdrop'),
              ),
            ],
          );
  }
}
