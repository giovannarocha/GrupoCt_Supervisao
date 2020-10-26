import 'package:grupoct_supervisao/base/model/post.dart';
import 'package:geolocator/geolocator.dart';

class ValidarEndereco {
  static validar() async {
    List<Post> list = await Post.getPosts();

    if (list.isNotEmpty) {
      for (var post in list) {
        List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
            double.parse(post.latitude), double.parse(post.longitude));
        print(
            "${post.codPost} - ${post.postTitle};${placemark[0].thoroughfare}, ${placemark[0].subThoroughfare}; ${post.latitude}; ${post.longitude}");
      }
    }
  }
}
