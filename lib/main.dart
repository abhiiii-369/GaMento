import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/login/login_screen.dart';
import 'services/music_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(

    options:
    DefaultFirebaseOptions.currentPlatform,

  );

  await MusicService.startMusic();

  runApp(
    const GenZBrain(),
  );

}

class GenZBrain extends StatefulWidget {

  const GenZBrain({super.key});

  @override
  State<GenZBrain> createState() =>
      _GenZBrainState();

}

class _GenZBrainState
    extends State<GenZBrain>
    with WidgetsBindingObserver {

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance
        .addObserver(this);

  }

  @override
  void dispose() {

    WidgetsBinding.instance
        .removeObserver(this);

    super.dispose();

  }

  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state
      ) async {

    if (state ==
        AppLifecycleState.paused) {

      await MusicService.pauseMusic();

    }

    else if (state ==
        AppLifecycleState.resumed) {

      await MusicService.resumeMusic();

    }

  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner:
      false,

      theme:
      AppTheme.darkTheme,

      home:
      const LoginScreen(),

      routes: {

        '/login': (_) =>
        const LoginScreen(),

      },

    );

  }

}