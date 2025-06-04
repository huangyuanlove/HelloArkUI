import 'dart:convert';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Map<String, dynamic> args;

  const LoginPage(this.args, {super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("LoginPage 获取到参数--> ${widget.args}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '登录页面',
          style: TextStyle(fontSize: 20, color: Color(0xff333333)),
        ),
      ),
      body: Column(
        children: [
          Text("登录页面获取到的参数", style: TextStyle(fontSize: 16, color: Color(0xff333333))),
          Text("${jsonEncode(widget.args)}"),
          Text("name:${widget.args['name']}"),
          Text("age:${widget.args['age']}"),
          ElevatedButton(
            onPressed: () {},
            child: Text("登录成功返回",
                style: TextStyle(fontSize: 16, color: Color(0xff333333))),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("登录失败返回",
                style: TextStyle(fontSize: 16, color: Color(0xff333333))),
          )
        ],
      ),
    );
  }
}
