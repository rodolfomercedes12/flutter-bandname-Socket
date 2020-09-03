import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<Band> bands =[
    Band(id: "1", name: "Metalica", votes: 5),
    Band(id: "2", name: "Queen", votes: 5),
    Band(id: "3", name: "Heroes del Silencio", votes: 5),
    Band(id: "4", name: "Kiss", votes: 5),
    Band(id: "5", name: "Bon Jovi", votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text("BandNames",style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: ( context, i) =>_buildTile(bands[i])
          ),
      floatingActionButton: FloatingActionButton(onPressed: addNewBand,
      child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  Widget _buildTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction:  DismissDirection.startToEnd,
      onDismissed: (direction){
        print(direction);
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
      child: Align(
        alignment: Alignment.centerLeft ,
        child: Text("Delete Band",style: TextStyle(color: Colors.white),) ,
      )
      ),
      child: ListTile(
        onTap: (){
          print(band.name);
        },
              leading: CircleAvatar(
                child: Text(band.name.substring(0,2)),
                backgroundColor: Colors.blue[100],
              ),
        title: Text(band.name),
        trailing: Text("${band.votes}",style: TextStyle(fontSize: 20),),
            ),
    );
  }


  addNewBand(){
    final textController = new TextEditingController();

    if(Platform.isAndroid ){
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("New Band Name:"),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                  onPressed: () => addBandToList(textController.text),
                  child: Text("Add"),
                  textColor: Colors.blue,
                  elevation: 5,
                )
              ],
            );
          }
      );
    }
    showCupertinoDialog(
        context: context,
        builder: (_){
          return CupertinoAlertDialog(
            title: Text("New Band Name"),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Add"),
                  onPressed: () => addBandToList(textController.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text("Dismiss"),
                onPressed: () => Navigator.pop(context)
              ),
            ],
          );
        });


  }

  void addBandToList(String name){
    print(name);
    if(name.length>1){

      this.bands.add(new Band(
        id: DateTime.now().toString(),
        name: name,
        votes: 0,
      ));

      setState(() {

      });

    }

    Navigator.pop(context);
  }


}
