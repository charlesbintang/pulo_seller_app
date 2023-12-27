import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String userName = "";
String userPhone = "";
String userID = FirebaseAuth.instance.currentUser!.uid;

String googleMapKey = "AIzaSyC6LgH8lt4IILgH2KaM-Nk9V2jcpomkiu4";
String serverKeyFCM = "AAAAkFWosfE:APA91bHjETxqkG8Ryp-8JNn-SSVZnjPDeta16rSZfW3775J0yA3_2rtuqrbvMHWfh3z4OWK9kkaUp5neQ58IpsXUaTYSSg92_m3CgpbYZyLfQQYOYtBSWYbKcMcQ-DjvUCTWMEoGkZ5O";

const CameraPosition googlePlexInitialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
);