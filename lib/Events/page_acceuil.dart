import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'details_pages.dart';

class page_acceuil extends StatefulWidget {
  var id_organisateur, nom_agent, matricule_agent, id_agent;
  page_acceuil({this.id_organisateur, this.nom_agent, this.matricule_agent, this.id_agent});

  @override
  State<page_acceuil> createState() => _page_acceuilState();
}
var based_url = 'http://api.eventime.ga/';

class _page_acceuilState extends State<page_acceuil> {
  String id_evenement_en_cours = "";
  String nom_evenement_en_cours = "";
  String image_evenement_en_cours = "";

  String participant = "0";
  String tk_restant = "0";

  Future Evenements(String id_organisateur)async{
    final uri =
    Uri.parse(based_url);
    var reponse = await http.post(uri,body: {
      'clic':'event',
      'id_organisateur': id_organisateur,
    });
    print(reponse.body);
    return json.decode(reponse.body);
  }

  snackbar (text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content:Text(text,style: TextStyle(
          color: Colors.white
      ),),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future Evenements_en_cours(String id_organisateur)async{
    final uri =
    Uri.parse(based_url);
    var reponse = await http.post(uri,body: {
      'clic':'event_en_cours',
      'id_organisateur': id_organisateur,
    });
    print("id evenement en cour: "+reponse.body);
    if(reponse.body == "non"){
      snackbar("Aucun evenement en cours");
    }
    if(reponse.body == ""){
      snackbar("Aucun evenement en cours");
    }
    if(reponse.body != "non" || reponse.body != ""){
      var data = reponse.body.split(',');
      setState(() {
        id_evenement_en_cours = data[0];
        nom_evenement_en_cours = data[1];
        image_evenement_en_cours = data[2];
      });
    }
  }

  Future Tk_Restant(String id_organisateur)async{
    final uri =
    Uri.parse(based_url);
    var reponse = await http.post(uri,body: {
      'clic':'event',
      'id_organisateur': id_organisateur,
    });
    print(reponse.body);
    setState(() {
      tk_restant = reponse.body;
    });
  }

  Future Participant(String id_organisateur)async{
    final uri =
    Uri.parse(based_url);
    var reponse = await http.post(uri,body: {
      'clic':'event',
      'id_organisateur': id_organisateur,
    });
    print(reponse.body);
    setState(() {
      participant = reponse.body;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Evenements(widget.id_organisateur);
    Evenements_en_cours(widget.id_organisateur);
  }

  @override
  Widget build(BuildContext context) {
    if(id_evenement_en_cours !=""){
      Tk_Restant(widget.id_organisateur);
      Participant(widget.id_organisateur);
    }
    var size = MediaQuery.of(context).size;
    List? evenements;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text(widget.nom_agent.split('')[0],style: TextStyle(
                            color: Colors.white
                          ),),
                        ),
                    ),
                    SizedBox(width: 10,),
                    Text(widget.nom_agent),
                  ],
                ),
                Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text(widget.matricule_agent,style: TextStyle(
                    color: Colors.white
                  ),)),
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
          Divider(),
          id_evenement_en_cours == ""?Container(
            width: size.width/1.1,
            height: size.height/3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.green
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 200,
                    height: 200,
                    child: Lottie.asset('assets/noevents.json'),
                ),
                Text('Aucun evenement en cours',style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),)
              ],
            ),
          ):Container(
            width: size.width/1.1,
            height: size.height/3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: NetworkImage('https://eventime.pixelga.com/Controllers/couverture/$image_evenement_en_cours'),
                    fit: BoxFit.cover
                ),
                color: Colors.green
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width/2.4,
                  height: size.height/3.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Tickets restant'),
                      Text(tk_restant,style: TextStyle(
                        fontSize: 80,
                      ),)
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  width: size.width/2.4,
                  height: size.height/3.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Participant(s)'),
                      Text(participant,style: TextStyle(
                        fontSize: 80,
                      ),)
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              SizedBox(width: 20,),
              Container(
                width: 10,
                height: 60,
                color: Colors.green,
              ),
              SizedBox(width: 20,),
              Text('Evenements'),
            ],
          ),
          SizedBox(height: 20,),
          Expanded(
            child: Container(
                child: FutureBuilder(
                    future: Evenements(widget.id_organisateur),
                    builder: (context, snapshot){
                      evenements = snapshot.data;
                      if(evenements == null){
                        return Scaffold(
                          backgroundColor: Colors.white,
                          body: Center(
                            child: CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          ),
                        );
                      }else{
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: evenements!.length,
                            itemBuilder: (context, element){
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(Plus: evenements![element])));
                                  },
                                  child: Container(
                                    width: size.width/1.1,
                                    height: size.height/3,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: size.width/1.1,
                                          height: size.height/3.06,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                              image: DecorationImage(
                                                  image: NetworkImage('https://eventime.pixelga.com/Controllers/couverture/'+evenements![element]['image']),
                                                  fit: BoxFit.cover
                                              )
                                          ),

                                        ),
                                        Container(
                                          width: size.width/1.1,
                                          height: 62.5,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                          ),
                                          child: Center(
                                            child: Text(evenements![element]['nom'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    })
            ),
          ),
        ],
      ),
    );
  }
}
