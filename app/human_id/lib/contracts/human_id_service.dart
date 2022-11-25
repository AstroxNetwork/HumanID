import 'package:http/http.dart';
import 'package:human_id/exports.dart';
import 'package:live_detection_plugin/live_detection.dart';
import 'package:web3dart/web3dart.dart' as web3;

import 'human_id.g.dart';

class EthNetwork {
  final String name;
  final String rpcUrl;
  final int chainId;

  const EthNetwork({
    required this.name,
    required this.rpcUrl,
    required this.chainId,
  });

  static EthNetwork selected = networks.first;

  static const networks = [
    EthNetwork(
      name: "Scroll L2 Testnet",
      rpcUrl: "https://prealpha.scroll.io/l2",
      chainId: 534354,
    ),
    EthNetwork(
      name: "Mumbai Testnet",
      rpcUrl: "https://rpc-mumbai.maticvigil.com",
      chainId: 80001,
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EthNetwork &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          rpcUrl == other.rpcUrl &&
          chainId == other.chainId;

  @override
  int get hashCode => name.hashCode ^ rpcUrl.hashCode ^ chainId.hashCode;
}

class HumanIDService {
  final Human_id _humanId;
  static final privateKey = web3.EthPrivateKey.fromInt(
    BigInt.parse(const String.fromEnvironment("pk")),
  );

  factory HumanIDService([EthNetwork? network]) {
    network ??= EthNetwork.selected;
    final client = web3.Web3Client(network.rpcUrl, Client());
    final humanId = Human_id(
      client: client,
      address:
          web3.EthereumAddress.fromHex(const String.fromEnvironment("addr")),
      chainId: network.chainId,
    );
    return HumanIDService._(humanId);
  }

  HumanIDService._(this._humanId);

  Future<bool> isVerified(String scope) async {
    try {
      final address = web3.EthereumAddress.fromHex(
          Uri.parse(scope).queryParameters['address'] as String);
      final result = await _humanId.get_token(scope, address);
      final list = (result as List).cast<String>();
      return list[1].isNotBlank;
    } catch (e, s) {
      e.error(stackTrace: s);
      rethrow;
    }
  }

  Future<List<LiveAction>> getActions() async {
    try {
      final result = await _humanId.detect_batch_start();
      final actions = [...LiveAction.values];
      actions.removeAt(result.toInt());
      actions.shuffle();
      return actions;
    } catch (e, s) {
      e.error(stackTrace: s);
      rethrow;
    }
  }

  Future<bool> setVerified(String scope) async {
    try {
      scope.debug();
      final address = web3.EthereumAddress.fromHex(
          Uri.parse(scope).queryParameters['address'] as String);
      await _humanId.detect_batch_end(
        scope,
        address,
        credentials: privateKey,
      );
      return isVerified(scope);
    } catch (e, s) {
      e.error(stackTrace: s);
      rethrow;
    }
  }
}
