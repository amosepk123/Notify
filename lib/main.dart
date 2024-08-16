
import 'package:call/Map/original.dart';
import 'package:call/login/auth_service.dart';
import 'package:call/profile/profile%20duplicate.dart';
import 'package:call/profile/profile.dart';
import 'package:call/provider/Name%20provider.dart';
import 'package:call/provider/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'BottomNavigation.dart';
import 'Call_and _message.dart';
import 'Map/googleMap_implement.dart';
import 'login/Phone_Number.dart';
import 'login/login.dart';
import 'login/signup.dart';
import 'login/splashScreen.dart';
import 'provider/Contact Provider.dart';
import 'Notification/FirebaseNotification.dart';


import 'login/Wrapper.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAz3gkvTVKwX6Yqbr--FEBau1Q7KPiNYE0",
          messagingSenderId: "789013470799",
          projectId: "budgetmemo-64d3c",
          appId: "1:789013470799:web:2c560d1ae8709980ba143a",
      )
  );
  await FirebaseController().initNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ContactsProvider()),
        ChangeNotifierProvider(create: (context)=>NameProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FirebaseController());
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GetMaterialApp(
      title: 'Notify',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: splash_screen(),
      builder: (context, child) => ResponsiveWrapper.builder(
        EasyLoading.init()(context, child),
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
        background: Container(color: Color(0xFFF5F5F5)),
      ),
      initialRoute: "/",
      //navigatorObservers: [EasyLoading.instance],
    );
  }
}