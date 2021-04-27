import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:starflut/starflut.dart';
import 'package:flutter_blue/flutter_blue.dart';

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

  void getData() async {
    await getToken();
    await getJsonData();
  }

  Future<String> getToken() async {
    String code = await rootBundle.loadString('assets/res/credentials.txt');
    print(code);

    String url = 'https://api.fitbit.com/oauth2/token?code=' +
        code +
        '&grant_type=authorization_code&redirect_uri=http://127.0.0.1:9000/&expires_in=604800';
    var response = await http.post(Uri.parse(url), headers: {
      "Authorization":
          "Basic MjJDQ0pXOjI3ZDZmNTM3OGM0MWUzMDI2YWE3Nzg1MzdkOThlOGFi",
      "Content-Type": "application/x-www-form-urlencoded"
    });
    // print(response.body);
    access_token = json.decode(response.body)['access_token'].toString();
    print('access tokenul -> ' + access_token);
    setState(() {
      data1 = jsonDecode(response.body);
    });

    return 'success';
  }

  Future<String> getJsonData() async {
    var authn = 'Bearer ' + access_token;
    String url =
        'https://api.fitbit.com/1/user/-/activities/steps/date/today/today.json';
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

