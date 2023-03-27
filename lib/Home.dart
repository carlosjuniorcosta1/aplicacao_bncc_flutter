

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

  bool _sextoAnoBox = false;
  bool _setimoAnoBox = false;
  bool _oitavoAnoBox = false;


  Stream<QuerySnapshot> _stream =
  FirebaseFirestore.instance.collection('materias').snapshots();
  
    TextEditingController _controllerField = TextEditingController();


  _getList() async{
     List<String> listaUnidadesTematicasTemp = <String>[];
     List<String> listaAnoFaixaTemp = <String>[];
     var pesquisa = await FirebaseFirestore.instance.collection('materias').get();
     pesquisa.docs.forEach((x) {

       listaUnidadesTematicasTemp.add(x.data()['unidades_tematicas']);
       listaAnoFaixaTemp.add(x.data()['ano_faixa']);

     });
     Set<String> conjuntoAnoFaixaTemp = listaAnoFaixaTemp.toSet();
     List<String> listaAnoFaixa = conjuntoAnoFaixaTemp.toList();

     Set<String> listaUnidadesTematicasTemp2 = listaUnidadesTematicasTemp.toSet();
     List<String> listaUnidadesTematicas = listaUnidadesTematicasTemp2.toList();
     setState(() {
       _dropValues = listaUnidadesTematicas;
     });

     if(_sextoAnoBox == true && _setimoAnoBox == false && _oitavoAnoBox ==false){
       var procura = FirebaseFirestore.instance.collection('materias')
           .where('ano_faixa', isEqualTo: '6').where('unidades_tematicas', isEqualTo: _dropFirstValue);

       setState(() {
         _stream = procura.snapshots();

       });
     }
     if(_sextoAnoBox == true && _setimoAnoBox == true && _oitavoAnoBox == false){
       var procura = FirebaseFirestore.instance.collection('materias').
           where('ano_faixa', whereIn: ['6', '7'])
      .where('unidades_tematicas', isEqualTo: _dropFirstValue);

       setState(() {
         _stream = procura.snapshots();

       });
     }
     if(_sextoAnoBox == true && _setimoAnoBox == true && _oitavoAnoBox == true){
       var procura = FirebaseFirestore.instance.collection('materias')
       .where('ano_faixa', whereIn: ['6', '7', '8'])
       .where('unidades_tematicas', isEqualTo: _dropFirstValue);


       setState(() {
         _stream = procura.snapshots();

       });
     }
     if(_sextoAnoBox == false && _setimoAnoBox == true && _oitavoAnoBox == false){
       var procura = FirebaseFirestore.instance.collection('materias')
       .where('ano_faixa', isEqualTo: '7').where('unidades_tematicas', isEqualTo: _dropFirstValue);

       setState(() {
         _stream = procura.snapshots();

       });
     }
     if(_sextoAnoBox == false && _setimoAnoBox == false && _oitavoAnoBox ==true){
       var procura = FirebaseFirestore.instance.collection('materias')
           .where('ano_faixa', isEqualTo: '8').where('unidades_tematicas', isEqualTo: _dropFirstValue);

       setState(() {
         _stream = procura.snapshots();

       });
     }

     if(_sextoAnoBox == false && _setimoAnoBox == true && _oitavoAnoBox ==true){
       var procura = FirebaseFirestore.instance.collection('materias')
           .where('ano_faixa', whereIn: ['7', '8']).where('unidades_tematicas', isEqualTo: _dropFirstValue);

       setState(() {
         _stream = procura.snapshots();

       });
     }

     if(_sextoAnoBox == true && _setimoAnoBox == false && _oitavoAnoBox ==true){
       var procura = FirebaseFirestore.instance.collection('materias')
           .where('ano_faixa', whereIn: ['6', '8']).where('unidades_tematicas', isEqualTo: _dropFirstValue);

       setState(() {
         _stream = procura.snapshots();

       });
     }





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
              Text("Escolha o ano", style: TextStyle(fontSize: 16),),
              CheckboxListTile(value: _sextoAnoBox,
                  title: Text("6º"),
                  onChanged: (bool? newValue) {

                setState(() {
                  _sextoAnoBox = newValue!;
                });
                if(_sextoAnoBox == true){


                }
                  }),
              CheckboxListTile(value: _setimoAnoBox,
                  title: Text("7º"),
                  onChanged: (bool? newValue) {

                    setState(() {
                      _setimoAnoBox = newValue!;
                    });
                  }),

          CheckboxListTile(value: _oitavoAnoBox,
              title: Text("8º"),
              onChanged: (bool? val) {
            setState(() {
              _oitavoAnoBox = val!;
            });
              }),


Text('Escolha a unidade temática', style: TextStyle(fontSize: 16),),
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
                        itemCount: streamSnapshot.data!.docs.length,

                        itemBuilder: (context, indice) {
                          DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[indice];
                          return Column(
                            children: [
                              Card(
                          child:
                              ListTile(
                                title: Text(" ${documentSnapshot['unidades_tematicas']} - ${documentSnapshot['ano_faixa']}º Ano"),
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