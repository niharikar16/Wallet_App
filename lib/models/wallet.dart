class Wallet {
  final String address;
  final double balance;
  final String walletName;
  final String userPin;
  final String network;
  final String publicKey;
  final List<int> secretKey;

  Wallet({
    required this.address,
    required this.balance,
    required this.walletName,
    required this.userPin,
    required this.network,
    required this.publicKey,
    required this.secretKey,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      address: json['publicKey'],
      balance: json.containsKey('balance') ? json['balance'].toDouble() : 0.0,
      walletName: json['walletName'] ?? '',
      userPin: json['userPin'] ?? '',
      network: json['network'] ?? '',
      publicKey: json['publicKey'],
      secretKey: List<int>.from(json['secretKey']),
    );
  }
}
