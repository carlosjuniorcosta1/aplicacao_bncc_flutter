

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Home.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {

  List<String>_dropValues = <String>[];

  String _dropFirstValue = "";

  Stream<QuerySnapshot> _stream =
  FirebaseFirestore.instance.collection('materias').snapshots();
  
    TextEditingController _controllerField = TextEditingController();


  _getList() async{
     List<String> listaUnidadesTematicasTemp = <String>[];
     var pesquisa = await FirebaseFirestore.instance.collection('materias').where('unidades_tematicas').get();
     pesquisa.docs.forEach((x) {

       listaUnidadesTematicasTemp.add(x.data()['unidades_tematicas']);

     });
     Set<String> listaUnidadesTematicasTemp2 = listaUnidadesTematicasTemp.toSet();
     List<String> listaUnidadesTematicas = listaUnidadesTematicasTemp2.toList();
     setState(() {
       _dropValues = listaUnidadesTematicas;
     });
     var procura = FirebaseFirestore.instance.collection('materias')
     .where('unidades_tematicas', isEqualTo: _dropFirstValue);

     setState(() {
       _stream = procura.snapshots();
     });

  }

  @override
  Widget build(BuildContext context) {
     _getList();
    return Scaffold(
        appBar: AppBar(
          title: Text("BNCC - Matemática"),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body:
            Container(
              margin: EdgeInsets.only(top: 10),
        child:
        Column(
            children: [
          DropdownButton<String>(
          value: _dropFirstValue.isNotEmpty ? _dropFirstValue : null,
          icon: const Icon(Icons.arrow_downward),
          elevation: 5,

          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              _dropFirstValue = value!;
            });
          },
          items: _dropValues.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),

            );
          }).toList(),
        ),

               StreamBuilder(
                stream: _stream,
                builder: (context,
                    AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {

                       return
                          Expanded(child:
                          ListView.builder(
                      scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 10,

                        itemBuilder: (context, indice) {
                          DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[indice];
                          return Column(
                            children: [
                              Card(
                          child:
                              ListTile(
                                title: Text(" ${documentSnapshot['unidades_tematicas']}"),
                                subtitle: Text(documentSnapshot['habilidades']),
                              ),
                                color: Theme.of(context).colorScheme.surfaceVariant,

                              )],

                          );
                        }));
                  }
                  return Container(
                  );
                },
              )
            ]
        )
    ));
  }


}