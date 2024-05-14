import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spider-robot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Spider-robot controller'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _MyHomePageState extends State<MyHomePage> {
  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();
    /*BluetoothConnection.toAddress("00:21:13:00:19:5C").then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });*/
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 120, 0, 209),
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            Container(
              color: Colors.grey,
            ),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          _sendMessage("text");
                        },
                        icon: Icon(
                          Icons.arrow_circle_left,
                          size: 60,
                          color: Colors.blueGrey,
                        ))
                  ], //кнопка влево
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          _sendMessage("text");
                        },
                        icon: Icon(
                          Icons.arrow_circle_up,
                          size: 60,
                          color: Colors.blueGrey,
                        )), //кнопка вверх
                    IconButton(
                        onPressed: () {
                          _sendMessage("text");
                        },
                        icon: Icon(
                          Icons.arrow_circle_down,
                          size: 60,
                          color: Colors.blueGrey,
                        )) //кнопка вниз
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          _sendMessage("text");
                        },
                        icon: Icon(
                          Icons.arrow_circle_right,
                          size: 60,
                          color: Colors.blueGrey,
                        )) //кнопка вправо
                  ],
                )
              ],
            ),
            Row(children: [
              Padding(padding: EdgeInsets.fromLTRB(250, 0, 0, 0)),
              Column(
                children: [
                  Text(
                    "Скорость передвижения",
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            _sendMessage("text");
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.blueGrey),
                            minimumSize: MaterialStatePropertyAll(Size(30, 50)),
                          ),
                          child: const Text(
                            "x1",
                            style: TextStyle(color: Colors.white),
                          )), //кнопка скорости х1
                      ElevatedButton(
                          onPressed: () {
                            _sendMessage("text");
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.blueGrey),
                            minimumSize: MaterialStatePropertyAll(Size(30, 50)),
                          ),
                          child: const Text("x2",
                              style: TextStyle(
                                  color: Colors.white))), //кнопка скорости х2
                      ElevatedButton(
                          onPressed: () {
                            _sendMessage("text");
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.blueGrey),
                            minimumSize: MaterialStatePropertyAll(Size(30, 50)),
                          ),
                          child: const Text("x5",
                              style: TextStyle(
                                  color: Colors.white))), //кнопка скорости х5
                    ],
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                  Text(
                    "Расстояние до объекта",
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: [
                      Text(
                        "расстояние",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        " см",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
                      Column(
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(0, 0, 100, 0)),
                          Text(
                            "MQ-9",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "data",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(120, 0, 0, 0)),
                          Text(
                            "MQ-135",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "data",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
              Column(
                
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                      ElevatedButton(
                          onPressed: () {
                            _sendMessage("text");
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.blueGrey),
                            minimumSize: MaterialStatePropertyAll(Size(30, 50)),
                          ),
                          child: Text("Встать", style: TextStyle(color: Colors.white, fontSize: 13),)),//кнопка встать
                      ElevatedButton(
                          onPressed: () {
                            _sendMessage("text");
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.blueGrey),
                            minimumSize: MaterialStatePropertyAll(Size(30, 50)),
                          ),
                          child: Text("Сесть", style: TextStyle(color: Colors.white, fontSize: 13),))//кнопка сесть

                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                      ElevatedButton(
                          onPressed: () {
                            _sendMessage("text");
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.blueGrey),
                            minimumSize: MaterialStatePropertyAll(Size(30, 50)),
                          ),
                          child: Text("Танец", style: TextStyle(color: Colors.white, fontSize: 13),)),//кнопка танец
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                      ElevatedButton(
                          onPressed: () {
                            _sendMessage("text");
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.blueGrey),
                            minimumSize: MaterialStatePropertyAll(Size(30, 50)),
                          ),
                          child: Text("Шейк", style: TextStyle(color: Colors.white, fontSize: 13),)),//кнопка шейк
                      ElevatedButton(
                          onPressed: () {
                            _sendMessage("text");
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.blueGrey),
                            minimumSize: MaterialStatePropertyAll(Size(30, 50)),
                          ),
                          child: Text("Волна", style: TextStyle(color: Colors.white, fontSize: 13),))//кнопка волна

                ],
              ),
            ])
          ],
        )));
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
