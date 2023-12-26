import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  @override
  _QRViewExampleState createState() => _QRViewExampleState();
  var id_event;
  QRViewExample({required this.id_event});
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController _controller;
  String qrCodeData = "Aucun code QR scanné";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Code QR scanné : $qrCodeData',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCodeData = scanData.code.toString();
      });
      if (qrCodeData != "Aucun code QR scanné") {
        // Envoyer les données du code QR via une requête HTTP POST
        sendQRCodeData(qrCodeData);
      }
    });
  }
  snackbar (text, Color couleur) {
    final snackBar = SnackBar(
      backgroundColor: couleur,
      content:Text(text,style: TextStyle(
          color: Colors.white
      ),),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  Future<void> sendQRCodeData(numero_ticket) async {
    final uri =
    Uri.parse("http://api.eventime.ga/");
    var reponse = await http.post(uri,body: {
      'clic':'update',
      'numero_billet': numero_ticket.toString()
    });
    if (reponse.statusCode == 200) {
      print('Données envoyées avec succès');
      print(reponse.body);
      final data = json.decode(reponse.body);
      final message = data['message'];
      final result = data['result'];

      // Gérer la réponse si nécessaire
      if (message == "Ticket validé succès") {
        snackbar(message, Colors.lightGreen);
      } else {
        snackbar(message, Colors.redAccent);
      }

      setState(() {
        qrCodeData = "Aucun code QR scanné";
      });
    } else {
      print('Échec de l\'envoi des données. Code de statut : ${reponse.statusCode}');
      // Gérer l'échec de la requête si nécessaire
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
