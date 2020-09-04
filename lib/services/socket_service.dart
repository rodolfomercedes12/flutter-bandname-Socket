import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
 Online,
 Offline,
 Connecting
}
class SocketService with ChangeNotifier{

  //variables
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  //Getters
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  //Constructor
  SocketService(){
    this._initConfig();
  }

  void _initConfig(){

    // Dart client
    this._socket = IO.io('http://192.168.43.122:3000/',{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();

    });

    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    /*socket.on('nuevo-mensaje', ( payload) {
      print( "nuevo-mensaje");
      print("Nombre: " + payload['nombre']);
      print("Mensaje: " + payload['mensaje']);
      print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'No hay!!');
    });*/


  }


}