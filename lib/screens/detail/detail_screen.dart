import 'package:example_mobi_call/models/TokenModel.dart';
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

class _DetailScreenState extends State<DetailScreen >implements MobifoneHelperListener, CallListener{
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    Config.socketUrl = "http://103.199.79.64:3000";

    Config.jwt_token = widget.model.token ;
    print("thanh " + Config.jwt_token);
    print("thanh2: " + widget.model.token);
    MobifoneClient().mobifoneHelperListener = this;
    MobifoneClient().callListener = this;
    MobifoneClient().connectServer(context);
  }

  void _incrementCounter() {
    setState(() {
    });
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
      print("message " + message);
    }

  }

  @override
  onSignalingStateChange(String state, SignalResponModel model) {
    // TODO: implement onSignalingStateChange
    print("state: " + state);
    print("SignalResponModel: " + model.toString());
  }

  void call() {
    print("token la ${widget.model.token}");
    MobifoneClient().makeCall(null, '', 'hao', 'c2c');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text("Quang_daxua_vjp_pr0_n0_1"),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:  call,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

}
