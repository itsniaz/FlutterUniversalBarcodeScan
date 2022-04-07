import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Scan Barcode';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title),centerTitle: true,),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  final FocusNode _focusNode = FocusNode();
  String? _message = "";


  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  var rawCode = "";
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      setState(() {
        if (event.physicalKey != PhysicalKeyboardKey.enter) {
          if (event.physicalKey == PhysicalKeyboardKey.backspace) {
            _message = "";
          }else{
            rawCode = "$rawCode${event.character}";
          }
        } else {
          _message = "$_message$rawCode\n";
          rawCode = "";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: DefaultTextStyle(
          style: TextStyle(fontSize: 16),
          child: RawKeyboardListener(
            focusNode: _focusNode,
            onKey: _handleKeyEvent,
            child: AnimatedBuilder(
              animation: _focusNode,
              builder: (BuildContext context, Widget? child) {
                FocusScope.of(context).requestFocus(_focusNode);
                return Text(_message ?? '');
              },
            ),
          ),
        ),
      ),
    );
  }
}
