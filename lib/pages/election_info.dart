import 'package:flutter/material.dart';
import 'package:voting_dapp/services/functions.dart';
import 'package:web3dart/web3dart.dart';

class ElectionInfo extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;

  const ElectionInfo(
      {Key? key, required this.ethClient, required this.electionName})
      : super(key: key);

  @override
  _ElectionInfoState createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController authorizeVoterController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FutureBuilder<List>(
                        future: getTotalVotes(widget.ethClient),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data!.first.toString(),
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                    Text("Total Votes")
                  ],
                ),
                Column(
                  children: [
                    FutureBuilder<List>(
                        future: getCandidatesNum(widget.ethClient),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data!.first.toString(),
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                    Text("Total Candidates")
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: addCandidateController,
                    decoration:
                        InputDecoration(hintText: "Enter Candidate Name"),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (addCandidateController.text.isNotEmpty) {
                        addcandidate(
                            addCandidateController.text, widget.ethClient);
                      }
                    },
                    child: Text("Add candidate"))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: authorizeVoterController,
                    decoration:
                        InputDecoration(hintText: "Enter Voter Address"),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      authorizeVotes(
                          authorizeVoterController.text, widget.ethClient);
                    },
                    child: Text("Add voter"))
              ],
            ),
            Divider(),
            FutureBuilder<List>(
              future: getCandidatesNum(widget.ethClient),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    for (int i = 0; i < snapshot.data![0].toInt(); i++)
                      FutureBuilder<List>(
                        future: candidateInfo(i, widget.ethClient),
                        builder: (context, candidatesnapshot) {
                          if (candidatesnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListTile(
                            title: Text(
                                "Nane: ${candidatesnapshot.data![0][0].toString()}"),
                            subtitle: Text(
                                "Votes: ${candidatesnapshot.data![0][1].toString()}"),
                            trailing: ElevatedButton(
                              onPressed: () {
                                vote(i, widget.ethClient);
                              },
                              child: Text("Vote"),
                            ),
                          );
                        },
                      )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
