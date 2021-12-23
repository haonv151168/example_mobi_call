import 'package:example_mobi_call/constants/constants.dart';
import 'package:example_mobi_call/models/TokenModel.dart';
import 'package:example_mobi_call/screens/incoming_call_screen/incoming_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobi_call/config/config.dart';
import 'package:mobi_call/config/globals.dart';
import 'package:mobi_call/helper/socket_helper.dart';
import 'package:mobi_call/mobifone_helper/call_listener.dart';
import 'package:mobi_call/mobifone_helper/mobifone_helper.dart';
import 'package:mobi_call/models/SignalResponModel.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.model}) : super(key: key);

  final TokenModel model;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    implements MobifoneHelperListener, CallListener {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    Config.socketUrl = "http://103.199.79.64:3000";

    Config.jwt_token = widget.model.token;
    print("thanh " + Config.jwt_token);
    print("thanh2: " + widget.model.token);
    MobifoneClient().mobifoneHelperListener = this;
    MobifoneClient().callListener = this;
    MobifoneClient().connectServer(context);
  }

  void _incrementCounter() {
    setState(() {});
  }

  @override
  onConnectionConnect() {
    print("onConnectionConnect");
  }

  @override
  onConnectionError() {
    print("onConnectionError");
  }

  @override
  onError(String? message) {
    // TODO: implement onError
    if (message != null) {
      _showToast(context, message);
      print("message onError: " + message.toString());
    }
  }

  @override
  onSignalingStateChange(String state, SignalResponModel? model) {
    // TODO: implement onSignalingStateChange

    switch (state) {
      case Config.EVENT_CALLING:
        pushToIncomingCallScreen(true, toUser);
        break;
      case Config.EVENT_RINGING:
        pushToIncomingCallScreen(false, fromUser);
        break;
      case Config.EVENT_MISS:
        Navigator.pop(context);
        break;
      case Config.EVENT_REJECT:
        Navigator.pop(context);
        break;
      case Config.EVENT_CANCEL:
        Navigator.pop(context);
        break;
      case Config.EVENT_ACCEPT:
        Navigator.pop(context);
        MobifoneClient().joinMeeting();
        break;
      case Config.EVENT_END:
        print('EVENT_END');
        MobifoneClient().closeMeeting();
        break;
      case Config.EVENT_TERMINATED:
        print('EVENT_TERMINATED');
        MobifoneClient().endCall();
        // Navigator.pop(context);
        break;
      default:
        break;
    }
    print("state: " + state);
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('${text}'),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void pushToIncomingCallScreen(bool status, String name) {
    isCalling = status;
    nameUser = name;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IncomingCallScreen()),
    );
  }

  void call() {
    print("token la ${widget.model.token}");
    MobifoneClient().makeCall("19001009", "", null, "c2h");
    // MobifoneClient().makeCall(null, "", "daxua3", "c2c");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calling"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: call,
              tooltip: 'Increment',
              child: const Icon(Icons.phone),
            ),
          ],
        ),
      ),
    );
  }
}
