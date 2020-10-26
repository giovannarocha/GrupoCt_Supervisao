import 'package:geolocator/geolocator.dart';

class LocationValidator{

  var now = pickPosition();

  static pickPosition() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double distanceInMeters = await Geolocator().distanceBetween(position.latitude, position.longitude,-23.5617179,-46.7121154);
    print(position);
    bool aux = false;
    distanceInMeters > 300 ? aux = false : aux = true;
    String nova = "o que pegou: $position \n Resultado na comparação: $distanceInMeters + $aux";
    return nova;
  }



}

