import 'package:http/http.dart';
import 'package:human_id/exports.dart';
import 'package:live_detection_plugin/live_detection.dart';
import 'package:web3dart/web3dart.dart' as web3;

import 'human_id.g.dart';

class HumanIDService {
  final Human_id _humanId;
  final web3.EthPrivateKey privateKey;
  static HumanIDService? _service;

  factory HumanIDService() {
    if (_service == null) {
      final client = web3.Web3Client("http://192.168.101.4:8545", Client());
      final humanId = Human_id(
        client: client,
        address: web3.EthereumAddress.fromHex(
            '0x5fbdb2315678afecb367f032d93f642f64180aa3'),
      );
      final ethPrivateKey = web3.EthPrivateKey.fromHex(
          "0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a");
      _service = HumanIDService._(humanId, ethPrivateKey);
    }
    return _service!;
  }

  HumanIDService._(this._humanId, this.privateKey);

  Future<bool> isVerified(String scope) async {
    final result = await _humanId.get_token(
      scope,
      privateKey.address,
    );
    final list = (result as List).cast<String>();
    return list[1].isNotBlank;
  }

  Future<List<LiveAction>> getActions() async {
    final result = await _humanId.detect_batch_start();
    final actions = [...LiveAction.values];
    actions.removeAt(result.toInt());
    actions.shuffle();
    return actions;
  }

  Future<bool> setVerified(String scope) async {
    await _humanId.detect_batch_end(
      scope,
      privateKey.address,
      credentials: privateKey,
    );
    return isVerified(scope);
  }
}
