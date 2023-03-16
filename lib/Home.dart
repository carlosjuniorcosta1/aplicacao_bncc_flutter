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

  Stream<QuerySnapshot> _stream =
  FirebaseFirestore.instance.collection('materias').snapshots();

  TextEditingController _controllerField = TextEditingController();

   searchFF(String query) async{

    final result = await FirebaseFirestore.instance
        .collection('materias')
        .where('unidades_tematicas',
     isEqualTo: query);

setState(() {
  _stream= result.snapshots();
});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("BNCC - Matemática"),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body:
        Column(
            children: [
              TextField(
                controller: _controllerField,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Buscar"
                ),
                onChanged: (query) {
                  searchFF(query);
                },
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
                        itemCount: streamSnapshot.data!.docs.length,

                        itemBuilder: (context, indice) {
                          DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[indice];
                          return Column(
                            children: [
                              ListTile(
                                title: Text(" ${documentSnapshot['unidades_tematicas']} Ano: ${documentSnapshot['ano_faixa']}º ano "),
                                subtitle: Text(documentSnapshot['habilidades']),
                              )
                              ],

                          );
                        }));
                  }
                  return Container(
                  );
                },
              )
            ]
        )
    );
  }


}