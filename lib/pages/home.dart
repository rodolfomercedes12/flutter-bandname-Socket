import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<Band> bands =[];

  @override
  void initState() {

    final  socketService = Provider.of<SocketService>(context,listen: false);

    socketService.socket.on('active-bands', _handleActiveBands);
    
    super.initState();
  }

  _handleActiveBands(dynamic payload){
    this.bands = (payload as List).map((band) =>  Band.fromMap(band))
        .toList();

    setState(() {

    });
  }

  @override
  void dispose() {
    final  socketService = Provider.of<SocketService>(context,listen: false);
    socketService.socket.off('active-bands');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final  socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text("BandNames",style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              socketService.serverStatus == ServerStatus.Online ? Icons.check_circle :
              Icons.offline_bolt
              , color: socketService.serverStatus == ServerStatus.Online ? Colors.blue[300] : Colors.red,),
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: ( context, i) =>_buildTile(bands[i])
            ),
          ),  
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: addNewBand,
      child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  Widget _buildTile(Band band) {
    final socketService = Provider.of<SocketService>(context,listen: false);
    
    
    return Dismissible(
      key: Key(band.id),
      direction:  DismissDirection.startToEnd,
      onDismissed: ( _ ) => socketService.socket.emit('delete-band', ( { 'id': band.id } )),
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
      child: Align(
        alignment: Alignment.centerLeft ,
        child: Text("Delete Band",style: TextStyle(color: Colors.white),) ,
      )
      ),
      child: ListTile(
        onTap: ()=> socketService.socket.emit('vote-band',{ 'id': band.id }),
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
          builder: ( _ ) => AlertDialog(
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
            )
      );
    }
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
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
          )
        );


  }

  void addBandToList(String name){

    final socketService = Provider.of<SocketService>(context,listen: false);



    if(name.length>1){
      //agregar
      //emitir: add-band
      //{ name:  name }
      socketService.socket.emit('add-band', { 'name': name });

    }

    Navigator.pop(context);
  }


  //Mostrar grafica

Widget _showGraph(){
  Map<String, double> dataMap = new Map();
  bands.forEach((band) {
    dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
  });

  final List<Color> colorList = [
    Colors.blue[50],
    Colors.blue[200],
    Colors.yellow[50],
    Colors.yellow[200],
    Colors.pink[50],
    Colors.pink[200],
  ];

  return Container(
      padding: EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 200.0,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32.0,
        showChartValuesInPercentage: true,
        showChartValues: true,
        showChartValuesOutside: false,
        chartValueBackgroundColor: Colors.grey[200],
        colorList: colorList,
        showLegends: true,
        legendPosition: LegendPosition.right,
        decimalPlaces: 0,
        initialAngle: 0,
        chartType: ChartType.ring,
      ));

}


}
