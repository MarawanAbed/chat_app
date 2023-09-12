import 'package:chat_app/authen/sign_in/cubit/sign_in_cubit.dart';
import 'package:chat_app/authen/verify/verifiy_email.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/home/cubit/home_cubit.dart';
import 'package:chat_app/splash/splash_screens.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utils/bloc_observer.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          HomeCubit()
            ..getUserData(),
        ),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        darkTheme: darkThemeData(context),
        theme: lightThemeData(context),
        themeMode: ThemeMode.system,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              final user = snapshot.data;
              if (user != null) {
                return const VerifyEmail(); // Change this to your home screen
              } else if (snapshot.hasError) {
                return const Text('Something went wrong');
              } else {
                return const SplashScreen();
              }
            }
          },
        ),
      ),
    );
  }
}
