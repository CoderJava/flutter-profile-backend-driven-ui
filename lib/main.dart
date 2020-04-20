import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double paddingTop = mediaQueryData.padding.top;
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0xFFB86C6A),
              height: paddingTop,
            ),
            Expanded(
              child: FutureBuilder(
                future: _buildWidgetFromApi(context),
                builder: (context, snapshot) {
                  var connectionState = snapshot.connectionState;
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  } else if (connectionState == ConnectionState.active || connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container(
                      child: snapshot.data,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> _buildWidgetFromApi(BuildContext context) async {
    // Get JSON from local
    /*var response = await rootBundle.loadString('assets/profile-page.json');
    await Future.delayed(Duration(seconds: 2));
    return DynamicWidgetBuilder.build(response, context, DefaultClickListener());*/

    // Get JSON from endpoint
    var response = await Dio().get('https://bengkelrobot.net:8003/api/dynamic-widget/profile-page');
    var responseJson = json.encode(response.data);
    return DynamicWidgetBuilder.build(responseJson, context, DefaultClickListener());
  }
}

class DefaultClickListener extends ClickListener {
  @override
  void onClicked(String event) {
    // TODO: do something in here when receive clicked
  }
}