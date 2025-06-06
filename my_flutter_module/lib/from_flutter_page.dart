
import 'package:flutter/material.dart';
import 'package:flutter_router/flutter_router.dart';
class FromFlutterPage extends StatefulWidget {
  final Map<String, dynamic> args;
  const FromFlutterPage(this.args,{  super.key});

  @override
  State<FromFlutterPage> createState() => _FromFlutterPageState();
}

class _FromFlutterPageState extends State<FromFlutterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('from flutter',style: TextStyle(fontSize: 16,color: Color(0xff333333)),),),
      body: Column(
        children: [
            Text("收到上个页面传过来的数据"),
          Text("${widget.args}"),
          ElevatedButton(
            onPressed: () {
              FlutterRouter().pop(context,{"user_id":"xuan","page_name":"FromFlutterPage"});
            },
            child: const Text("带数据返回上个页面",
                style: TextStyle(fontSize: 16, color: Color(0xff333333))),
          ),
        ],
      ),
    );
  }
}
