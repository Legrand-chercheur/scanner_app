import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../Scanner/Scanne_pages.dart';

class Details extends StatefulWidget {
  var Plus;
  Details({required this.Plus});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  var participant = "0";
  var based_url = 'http://api.eventime.ga/';

  Future Evenements(String id_event)async{
    final uri =
    Uri.parse(based_url);
    var reponse = await http.post(uri,body: {
      'clic':'nb_ticket',
      'id_event': id_event,
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
    Evenements(widget.Plus['id_event']);
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: size.height/2,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                          image: NetworkImage('https://eventime.pixelga.com/Controllers/couverture/'+widget.Plus['image']),
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Text('Participant(s): $participant',style:TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),),
                    ),
                  ),
                  Positioned(
                      bottom: size.height/500,
                      child: Container(
                        width: size.width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))
                        ),
                        child: Center(
                          child: Text(widget.Plus['nom'],style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                  )
                ],
              ),
              SizedBox(height: 30,),
              Text('DESCRIPTION',style: TextStyle(
                color: Colors.green,
                fontSize: 20
              ),),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Text(widget.Plus['description']),
              )
            ],
          ),
          Positioned(
            bottom: size.height/20,
              left: size.width/2.48,
              child: Container(
                width: 80,
                height: 80,
                child: ElevatedButton(
                  onPressed: (){
                    participant != '0'
                        ?Navigator.push(context, MaterialPageRoute(builder: (context)=>QRViewExample(id_event: widget.Plus['id_event'])))
                        :snackbar('il y\'a encore aucun participant');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    primary: Colors.green,
                  ),
                  child: Icon(
                    Icons.qr_code_outlined,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}
