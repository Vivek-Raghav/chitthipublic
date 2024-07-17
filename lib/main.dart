import 'package:chitthi/colors.dart';
import 'package:chitthi/common/widgets/error.dart';
import 'package:chitthi/common/widgets/loader.dart';
import 'package:chitthi/features/auth/controller/auth_controller.dart';
import 'package:chitthi/firebase_options.dart';
import 'package:chitthi/router.dart';
import 'package:chitthi/screens/mobile_layout_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/landing Screens/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chitthi',
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: darkbackgroundColor,
            appBarTheme: const AppBarTheme(color: appBarColor, elevation: 0)),
        onGenerateRoute: (routeSettings) => generateRoute(routeSettings),
        home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileLayoutScreen();
            },
            error: (err, trace) {
              return ErrorScreen(error: err.toString());
            },
            loading: () => const Loader())
            );
  }
}
