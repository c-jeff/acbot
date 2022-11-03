import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:bubble/bubble.dart';
import 'package:ftest1/menu_drawer.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late DialogFlowtter dialogFlowtter;
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageInsert = TextEditingController();

  List<String> defFilters = ['Agua', 'Tierra', 'Clima', ''];
  List<String> filters = ['Agua', 'Tierra', 'Clima', ''];
  List<String> water = ['Técnicas de riego', 'Cantidad de agua para riego', 'Frecuencia de aplicación de agua para riego', ''];
  List<String> ground = ['Profundidad para cultivo', 'Tipo de tierra para cultivo', 'Distanciamiento de tierra entre semillas para cultivo', ''];
  List<String> weather = ['Estaciones óptimas para cultivo', 'Exposición al sol', 'Exposición a la lluvia', 'Exposición a temperaturas frías'];
  List<String> expoSun = ['Sensibilidad al sol', 'Tiempo de exposición al sol', 'Máxima temperatura', ''];
  List<String> expoRain = ['Sensibilidad a la lluvia', 'Tiempo de exposición a la lluvia', 'Máximo nivel de humedad', ''];
  List<String> expoTemp = ['Sensibilidad a temperaturas frías', 'Tiempo de exposición a temperaturas frías', 'Mínima temperatura', ''];

  int levels = 0;
  bool four = false;
  bool clean = true;
  bool limit1 = false;
  bool limit2 = false;
  bool limit3 = false;
  bool limit4 = false;

  List<Map<String, dynamic>> messages = [];

  @override
  void dispose() {
    dialogFlowtter.dispose();
    scrollController.dispose();
    messageInsert.dispose();
    super.dispose();
  }

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    messages.add({'message': Message(text: DialogText(text: const ['¡Hola! Soy AIgrary, estoy aquí para resolver tus consultas y optimizar tu uso de recursos naturales en las actividades de cultivo. ¡Espero ser de ayuda!'])), 'isUserMessage': false});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        title: const Text('AIgrary'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            //CONTROLLER MESSAGES (messages.dart)
            //Expanded(child: MessagesScreen(messages: messages)),
            Flexible(
                child: ListView.builder(
                    reverse: false,
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) =>
                        chat(
                            messages[index]["message"].text.text[0],
                            messages[index]["isUserMessage"])
                )
            ),
            const SizedBox(height: 10),

            const Divider(thickness: 1.7, height: 5.0, color: Colors.green),
            const SizedBox(height: 5),

            Container(
              //padding: const EdgeInsets.only(right: 10),
              height: 30,
              width: MediaQuery.of(context).size.width,
              child: Row(
              children: [
                IconButton(icon: const Icon(Icons.disabled_by_default_outlined, color: Colors.red, size: 16), onPressed: () {
                  if (!clean) {
                    sendMessage('Eliminar filtros');
                    setState(() {
                      filters = defFilters;
                      levels = 0;
                      four = false;
                      clean = true;
                      limit1 = false;
                      limit2 = false;
                      limit3 = false;
                      limit4 = false;
                    });
                  }
                }
                ),
                SizedBox(width: MediaQuery.of(context).size.width - 48, child:
                  ListView(
                  scrollDirection: Axis.horizontal,
                    children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: RaisedButton(
                          color: Colors.green,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              filters[0].contains('Agua') || filters[0].contains('riego') ? const Icon(Icons.water_drop, size: 20) : const SizedBox(width: 0),
                              filters[0].contains('Profundidad') ? const Icon(Icons.scatter_plot, size: 20) : const SizedBox(width: 0),
                              filters[0].contains('Estaciones') ? const Icon(Icons.sunny_snowing, size: 20) : const SizedBox(width: 0),
                              Text(filters[0]),
                            ],
                          ),
                          onPressed: () {
                            if (!limit1) {
                            if (filters[0].contains('Agua')) { sendMessage('Filtrar por agua'); }
                            if (filters[0].contains('riego')) { sendMessage('Filtrar por técnicas de riego'); }
                            if (filters[0].contains('Profundidad')) { sendMessage('Filtrar por profundidad para cultivo'); }
                            if (filters[0].contains('Estaciones')) { sendMessage('Filtrar por estaciones óptimas para cultivo'); }
                            setState(() {
                              if (levels == 1 || levels > 2){
                                filters = filters;
                                limit1 = true;
                                limit2 = false;
                                limit3 = false;
                                limit4 = false;
                              }
                              if (levels == 0) {
                                filters = water;
                                levels = 1;
                                clean = false;
                              }
                            });
                            }
                          }
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: RaisedButton(
                            color: Colors.green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                filters[1].contains('Tierra') || filters[1].contains('Tipo') ? const Icon(Icons.scatter_plot, size: 20) : const SizedBox(width: 0),
                                filters[1].contains('riego') ? const Icon(Icons.water_drop, size: 20) : const SizedBox(width: 0),
                                filters[1].contains('sol') ? const Icon(Icons.sunny, size: 20) : const SizedBox(width: 0),
                                Text(filters[1]),
                              ],
                            ),
                            onPressed: () {
                              if (!limit2) {
                              if (filters[1].contains('Tierra')) { sendMessage('Filtrar por tierra'); }
                              if (filters[1].contains('Tipo')) { sendMessage('Filtrar por tipo de tierra para cultivo'); }
                              if (filters[1].contains('riego')) { sendMessage('Filtrar por cantidad de agua para riego'); }
                              if (filters[1].contains('sol')) { sendMessage('Filtrar por exposición al sol'); }
                              setState(() {
                                if (levels == 1 || levels > 2){
                                  filters = filters;
                                  limit1 = false;
                                  limit2 = true;
                                  limit3 = false;
                                  limit4 = false;
                                }
                                if (levels == 0) {
                                  filters = ground;
                                  levels = 1;
                                  clean = false;
                                }
                              });
                              }
                            }
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: RaisedButton(
                            color: Colors.green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                filters[2].contains('Clima') ? const Icon(Icons.sunny_snowing, size: 20) : const SizedBox(width: 0),
                                filters[2].contains('Frecuencia') ? const Icon(Icons.water_drop, size: 20) : const SizedBox(width: 0),
                                filters[2].contains('semillas') ? const Icon(Icons.scatter_plot, size: 20) : const SizedBox(width: 0),
                                filters[2].contains('lluvia') ? const Icon(Icons.cloudy_snowing, size: 20) : const SizedBox(width: 0),
                                Text(filters[2]),
                              ],
                            ),
                            onPressed: () {
                              if (!limit3) {
                              if (filters[2].contains('Clima')) { sendMessage('Filtrar por clima'); }
                              if (filters[2].contains('Frecuencia')) { sendMessage('Filtrar por frecuencia de aplicación de agua para riego'); }
                              if (filters[2].contains('semillas')) { sendMessage('Filtrar por distanciamiento de tierra entre semillas'); }
                              if (filters[2].contains('lluvia')) { sendMessage('Filtrar por exposición a la lluvia'); }
                              setState(() {
                                if (levels == 1 || levels > 2){
                                  filters = filters;
                                  limit1 = false;
                                  limit2 = false;
                                  limit3 = true;
                                  limit4 = false;
                                }
                                if (levels == 0) {
                                  filters = weather;
                                  four = true;
                                  levels = 1;
                                  clean = false;
                                }
                              });
                              }
                            }
                        )
                    ),
                    four ? Container(
                        child: RaisedButton(
                            color: Colors.green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(Icons.ac_unit),
                                Text(filters[3]),
                              ],
                            ),
                            onPressed: () {
                              if (!limit4) {
                              setState(() {
                                sendMessage('Filtrar por exposición a temperaturas frías');
                                limit1 = false;
                                limit2 = false;
                                limit3 = false;
                                limit4 = true;
                                /*if (levels == 0) {
                                  filters = weather;
                                  levels = 1;
                                } else if (levels == 1 || levels > 2){
                                  filters = filters;
                                } else {
                                  four = false;
                                  filters = expoTemp;
                                  levels = 3;
                                }*/
                              });
                              }
                            }
                        )
                    ) : Container(),
                  ])
                )
              ]
              )
            ),

            const SizedBox(height: 7),
            const Divider(thickness: 1.7, height: 1.0, color: Colors.green),

            Container(

              child: ListTile(
                //leading: IconButton(icon: const Icon(Icons.person, color: Colors.green, size: 35), onPressed: () {}),
                title: Container(
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.white
                  ),
                  padding: const EdgeInsets.only(left: 13),
                  child: TextFormField(
                    controller: messageInsert,
                    decoration: const InputDecoration(
                      hintText: "Pregúntame algo...",
                      hintStyle: TextStyle(color: Colors.black26),
                      isDense: true,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),

                trailing: IconButton(
                    icon: const Icon(
                      Icons.send,
                      size: 30.0,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      sendMessage(messageInsert.text);
                      messageInsert.clear();
                    }),
              ),
            ),
            const SizedBox(height: 1.0)
          ],
        ),
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      debugPrint('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(queryInput: QueryInput(text: TextInput(text: text)));

      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
    scrollController.animateTo(scrollController.position.maxScrollExtent + 100, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }
}

Widget chat(String message, bool isUserMessage) {
  return Container(
    padding: const EdgeInsets.only(left: 20, right: 20),

    child: Row(
      mainAxisAlignment: isUserMessage == true ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isUserMessage == false ? Container(
          height: 60,
          width: 60,
          child: const CircleAvatar(backgroundImage: AssetImage("assets/robot.jpg")),
        ) : Container(),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Bubble(
              radius: const Radius.circular(15.0),
              color: isUserMessage == false ? const Color.fromRGBO(23, 157, 139, 1) : Colors.orangeAccent,
              elevation: 0.0,

              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    const SizedBox(
                      width: 3.0,
                    ),
                    Flexible(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            message,
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ))
                  ],
                ),
              )),
        ),


        isUserMessage == true ? Container(
          height: 60,
          width: 60,
          child: const CircleAvatar(backgroundImage: AssetImage("assets/default.jpg")),
        ) : Container(),

      ],
    ),
  );
}