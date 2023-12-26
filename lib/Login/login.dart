import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Events/page_acceuil.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

TextEditingController email = TextEditingController();
TextEditingController passe = TextEditingController();

class _ConnexionState extends State<Connexion> {
  bool chargement = false;
  snackbar (text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content:Text(text,style: TextStyle(
          color: Colors.white
      ),),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void connexion(email, password) async{
    final uri = Uri.parse('http://api.eventime.ga/');
    var reponse = await http.post(uri, body: {
      'clic': 'con',
      'matricule': email,
      'code': password,
    });
    print(reponse.body);
    setState(() {
      chargement = true;
    });
    if(email == '' || password =='') {
      snackbar('Les champs sont vide');
      setState(() {
        chargement = false;
      });
    }else {
      if(reponse.body == 'non'){
        snackbar('Compte inconnu');
      } else {
        final datas = reponse.body.split(',');
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('id_agent', datas[0]);
        prefs.setString('matricule_agent', datas[1]);
        prefs.setString('id_org', datas[2]);
        prefs.setString('nom_agent', datas[3]);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>page_acceuil(id_organisateur: datas[2], nom_agent: datas[3], matricule_agent: datas[1], id_agent: datas[0],)));
      }
      setState(() {
        chargement = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: Color.fromRGBO(125, 184, 78, 1)
            ),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width/1.1,
                height: MediaQuery.of(context).size.height/2.5,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/1.3,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(image: NetworkImage('https://eventime.ga/assets/img/icone_eventime_light.png'))
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color.fromRGBO(125, 184, 78, 1)), // Bordure personnalisée
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 19),
                        child: TextField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'votre matricule',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none, // Retire la bordure décorative du TextField
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color.fromRGBO(125, 184, 78, 1)), // Bordure personnalisée
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 19),
                        child: TextField(
                          controller: passe,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: 'votre mot de passe',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none, // Retire la bordure décorative du TextField
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        connexion(email.text, passe.text);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(125, 184, 78, 1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color.fromRGBO(125, 184, 78, 1)), // Bordure personnalisée
                        ),
                        child: Center(
                          child: chargement == false
                              ? Text(
                            'Connexion',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: Positioned(
              left: 150,
              right: 150,
              top: MediaQuery.of(context).size.height/1.2,
              bottom: 0,
              child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(image: NetworkImage('https://eventime.ga/assets/img/icone_eventime_light.png'))
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }
}
