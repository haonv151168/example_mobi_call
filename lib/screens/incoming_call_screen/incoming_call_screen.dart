import 'package:example_mobi_call/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:mobi_call/helper/socket_helper.dart';

class IncomingCallScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<IncomingCallScreen> {
  void _acceptCall(BuildContext context) {
    MobifoneClient().acceptCall();
  }

  void _cancelCall(BuildContext context) {
    print("_cancelCall");
    MobifoneClient().cancelCall();
  }

  void _rejectCall(BuildContext context) {
    print("_rejectCall");
    Navigator.pop(context);
    // MobifoneClient().rejectCall();
  }

  Future<bool> _onBackPressed(BuildContext context) {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            onWillPop: () => _onBackPressed(context),
            child: Scaffold(
                body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(36),
                    child: Text("${nameUser}", style: TextStyle(fontSize: 20)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 36, bottom: 8),
                    child: Text("", style: TextStyle(fontSize: 20)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 86),
                    child: Text(""),
                  ),
                  isCalling
                      ? Center(
                          child: FloatingActionButton(
                            child: Icon(
                              Icons.call_end,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.red,
                            onPressed: () => _cancelCall(context),
                          ),
                        )
                      : Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 36),
                                child: FloatingActionButton(
                                  heroTag: "RejectCall",
                                  child: Icon(
                                    Icons.call_end,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.red,
                                  onPressed: () => _rejectCall(context),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 36),
                                child: FloatingActionButton(
                                  heroTag: "AcceptCall",
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.green,
                                  onPressed: () => _acceptCall(context),
                                ),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ))));
  }
}
