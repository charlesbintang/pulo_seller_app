import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pulo_seller_app/appInfo/app_info.dart';
import 'package:pulo_seller_app/splash/splash_screen.dart';
import 'package:pulo_seller_app/utils/light_themes.dart';

import 'auth/widgets/sign_in_widget.dart';
import 'firebase_options.dart';
import 'pages/dashboard.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/single_order.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Permission.locationWhenInUse.isDenied.then((valueOfPermission) {
    if (valueOfPermission) {
      Permission.locationWhenInUse.request();
    }
  });

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (BuildContext context, Widget? child) {
          return ChangeNotifierProvider(
            create: (context) => AppInfo(),
            child: MaterialApp(
              title: 'Pulo Seller',
              debugShowCheckedModeBanner: false,
              theme: light,
              navigatorKey: navigatorKey,
              // ThemeData(
              //   scaffoldBackgroundColor: Constants.scaffoldBackgroundColor,
              //   visualDensity: VisualDensity.adaptivePlatformDensity,
              //   textTheme: GoogleFonts.poppinsTextTheme(),
              // ),
              // initialRoute: "/",
              // onGenerateRoute: _onGenerateRoute,
              home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final user = snapshot.data;
                    if (user == null) {
                      return SplashScreen(
                        onInitializationComplete: () {
                          navigatorKey.currentState?.pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const Home(),
                            ),
                          );
                        },
                      );
                    } else {
                      return SplashScreen(
                        onInitializationComplete: () {
                          navigatorKey.currentState?.pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const Dashboard(),
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    return const MaterialApp(
                      debugShowCheckedModeBanner: false,
                      home: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          );
        });
  }
}

// Route<dynamic> _onGenerateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case "/":
//       return MaterialPageRoute(builder: (BuildContext context) {
//         return const Home();
//       });
//     case "/oldlogin":
//       return MaterialPageRoute(builder: (BuildContext context) {
//         return const Login();
//       });
//     case "/login":
//       return MaterialPageRoute(builder: (BuildContext context) {
//         return const SignInWidget();
//       });
//     case "/dashboard":
//       return MaterialPageRoute(builder: (BuildContext context) {
//         return const Dashboard();
//       });
//     case "/single-order":
//       return MaterialPageRoute(builder: (BuildContext context) {
//         return const SingleOrder();
//       });
//     default:
//       return MaterialPageRoute(builder: (BuildContext context) {
//         return const Home();
//       });
//   }
// }
