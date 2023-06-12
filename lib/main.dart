import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:todo_firbase_test/auth/login_screen.dart';
import 'package:todo_firbase_test/screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey = 'pk_test_51Mm3YzSENe3l8TPl56WP2g5zpEyLBZ5jMKKvnJMhMHIrUUJzMZbBjuoZiZRvSNWAfvNXpspCStBaP3GeaGWsNsDM000zqZCD5M';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ToDo-APP',
          // You can use the library anywhere in the app even in theme

          home: Home(),
        );
      },
    );
  }
}
