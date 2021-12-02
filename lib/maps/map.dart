import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double? latitude, double? longitude) async {
    String googleUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    final String encodedURl = Uri.encodeFull(googleUrl);
    if (await canLaunch(encodedURl)) {
      await launch(encodedURl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
