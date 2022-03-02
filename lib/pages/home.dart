import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:voting_dapp/pages/election_info.dart';
import 'package:voting_dapp/services/functions.dart';
import 'package:voting_dapp/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? ethClient;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(INFURA_URL, httpClient!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start Election"),
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                  filled: true, hintText: "Enter election name"),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    onPressed: () async {
                      if (controller.text.length > 0) {
                        await startElection(controller.text, ethClient!);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ElectionInfo(
                                      electionName: controller.text,
                                      ethClient: ethClient!,
                                    )));
                      }
                    },
                    child: Text("Start Election")))
          ],
        ),
      ),
    );
  }
}
