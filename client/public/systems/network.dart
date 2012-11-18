part of system;

class Network extends System {
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
