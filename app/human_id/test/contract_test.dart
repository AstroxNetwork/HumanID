import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:human_id/contracts/human_id.g.dart';
import 'package:human_id/exports.dart';
import 'package:web3dart/web3dart.dart' as web3;

void main() {
  group("HumanID contract test", () {
    final client = web3.Web3Client("http://127.0.0.1:8545", Client());
    final humanId = Human_id(
      client: client,
      address: web3.EthereumAddress.fromHex(
          '0x5fbdb2315678afecb367f032d93f642f64180aa3'),
    );
    final admin = web3.EthPrivateKey.fromHex(
        "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80");
    final ethPrivateKey = web3.EthPrivateKey.fromHex(
        "0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a");
    const scope = "astrox://human?astrox.me";
    test("add_authorize_address", () async {
      final result = await humanId.add_authorize_address(
        ethPrivateKey.address,
        credentials: admin,
      );
      result.info(tag: "add_authorize_address");
    });
    test("get_token before verify", () async {
      final result = await humanId.get_token(
        scope,
        ethPrivateKey.address,
      );
      (result as Object).info(tag: "get_token before verify");
    });
    test("detect_batch_start", () async {
      final result = await humanId.detect_batch_start();
      result.info(tag: "detect_batch_start");
      expect(result >= BigInt.zero && result < BigInt.from(4), true);
    });
    test("detect_batch_end random address", () async {
      final ethPrivateKey = web3.EthPrivateKey.createRandom(Random.secure());
      final result = await humanId.detect_batch_end(
        scope,
        ethPrivateKey.address,
        credentials: ethPrivateKey,
      );
      result.info(tag: "detect_batch_end random address");
    });
    test("detect_batch_end", () async {
      final result = await humanId.detect_batch_end(
        scope,
        ethPrivateKey.address,
        credentials: ethPrivateKey,
      );
      result.info(tag: "detect_batch_end");
    });
    test("get_token after verified", () async {
      final result = await humanId.get_token(
        scope,
        ethPrivateKey.address,
      );
      (result as Object).info(tag: "get_token after verified");
    });
  });
}
