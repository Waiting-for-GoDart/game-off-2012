part of waiting_for_godart;

class Network {
  NetworkSocket netSock;
  
  Network(NetworkSocket ns) {
    netSock = ns;
  }
  
  void update() {
    var packet = netSock.getPacket();
    while (packet != null) {
      for (var entity in entities) {
        
      }
      packet = netSock.getPacket();
    }
  }
}
