import 'package:flutter/services.dart';
import 'package:voting_dapp/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString("assets/abi.json");
  String contract_address = contract_address1;
  final contract = DeployedContract(ContractAbi.fromJson(abi, "Eection"),
      EthereumAddress.fromHex(contract_address));
  return contract;
}

Future<String> callFunction(String functionName, List<dynamic> args,
    Web3Client ethClient, String _privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(_privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(functionName);
  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: contract, function: ethFunction, parameters: args),
      chainId: null,
      fetchChainIdFromNetworkId: true);

  return result;
}

Future<String> startElection(String name, Web3Client ethclient) async {
  var response =
      await callFunction("startElection", [name], ethclient, owner_privateKey);
  print("election started successfully");
  return response;
}

Future<String> addcandidate(String name, Web3Client ethclient) async {
  var response =
      await callFunction("addCandidate", [name], ethclient, owner_privateKey);
  print("cndidate added successfully");
  return response;
}

Future<String> authorizeVotes(String address, Web3Client ethclient) async {
  var response = await callFunction("authorizeVoter",
      [EthereumAddress.fromHex(address)], ethclient, owner_privateKey);
  print("candidate authorised successfully");
  return response;
}

Future<List> getCandidatesNum(Web3Client ethClient) async {
  List<dynamic> result = await ask("getNumCandidates", [], ethClient);
  return result;
}

Future<List> getTotalVotes(Web3Client ethClient) async {
  List<dynamic> result = await ask("getTotalVotes", [], ethClient);
  return result;
}

Future<List> candidateInfo(int index, Web3Client ethClient) async {
  List<dynamic> result =
      await ask("candidateInfo", [BigInt.from(index)], ethClient);

  return result;
}

Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result =
      ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

Future<String> vote(int candidateIndex, Web3Client ethClient) async {
  var response;
  try {
    response = await callFunction(
        "vote", [BigInt.from(candidateIndex)], ethClient, voter_privateKey);
    print("vote counted successfully");
  } catch (e) {
    print(e);
  }

  return response;
}
