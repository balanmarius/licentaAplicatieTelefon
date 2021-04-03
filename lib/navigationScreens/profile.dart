import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var data1;
  var data2;
  String access_token;

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  void getData() async{
    await getToken();
    await getJsonData();
  }

  Future<String> getCode() async {
    String url='https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=22CCR2&redirect_uri=http://localhost&scope=activity%20nutrition%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight';

  }

  Future<String> getToken() async {
    String url =
        'https://api.fitbit.com/oauth2/token?code=b7bbb406dac5e2682b8e752d5331916a6ce6303c&grant_type=authorization_code&redirect_uri=http://localhost&expires_in=3600';
    var response = await http.post(Uri.parse(url), headers: {
      "Authorization":
          "Basic MjJDQ1IyOmJkMjhiMDJkMjE1ZDkxNTczZWY5ZWQ1YzgyODczMmY0",
      "Content-Type": "application/x-www-form-urlencoded"
    });
    print(response.body);
    // print('access tokenul -> '+'${json.decode(response.body)['access_token']}');
    access_token = json.decode(response.body)['access_token'].toString();
    print('access tokenul -> ' + access_token);
    setState(() {
      data1 = jsonDecode(response.body);
    });

    // getJsonData();
    return 'success';
  }

  Future<String> getJsonData() async {
    var authn = 'Bearer ' + access_token;
    String url = 'https://api.fitbit.com/1/user/-/activities.json/';
    var response = await http.get(Uri.parse(url),
        headers: {"Accept": "application/json", "Authorization": authn});

    print(response.body);

    setState(() {
      data2 = jsonDecode(response.body);
    });

    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Text(data2['best']['total'].toString()),
    );
  }
}
