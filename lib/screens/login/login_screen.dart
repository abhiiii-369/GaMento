import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';


import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;

  bool showStartButton = false;

  @override
  void initState() {
    super.initState();

    checkExistingLogin();
  }

  /// CHECK LOGIN

  Future<void> checkExistingLogin() async {
    final prefs = await SharedPreferences.getInstance();

    bool loggedIn = prefs.getBool("loggedIn") ?? false;

    if (loggedIn) {
      setState(() {
        showStartButton = true;
      });
    } else {
      setState(() {
        showStartButton = false;
      });
    }
  }

  /// START APP

  Future<void> startApp() async {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    }
  }

  /// GOOGLE AUTH

  Future<void> authenticateUser(bool isSignup) async {
    try {
      setState(() {
        loading = true;
      });

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

      if (googleUser == null) {
        setState(() {
          loading = false;
        });

        return;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: null,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      /// SIGN UP
if (isSignup) {

  if (doc.exists) {

    if (context.mounted) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(
            "Account already exists. Use Sign In.",
          ),

        ),

      );

    }

    return;

  }

  await FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid)
      .set({

    "uid": user.uid,

    "username":
    user.displayName ??
    "Player",

    "email":
    user.email,

    "photo":
    user.photoURL,

    "createdAt":
    FieldValue.serverTimestamp(),

  });

  final prefs =
  await SharedPreferences.getInstance();

  await prefs.setBool(
      "loggedIn",
      true
  );

  await prefs.setBool(
      "guestMode",
      false
  );

  if (context.mounted) {

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder:
            (_) =>
        const HomeScreen(),

      ),

    );

  }

}
      

      /// SIGN IN

      else {
        if (doc.exists) {
          final prefs = await SharedPreferences.getInstance();

          await prefs.setBool("loggedIn", true);

          await prefs.setBool("guestMode", false);

          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("No account found. Please Sign Up first."),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  /// CONTINUE AS GUEST

  Future<void> continueAsGuest() async {
    final prefs = await SharedPreferences.getInstance();

    /// SAVE GUEST MODE

    await prefs.setBool("guestMode", true);

    await prefs.setBool("loggedIn", false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    }
  }
@override
Widget build(BuildContext context) {

  return Scaffold(

    body: Stack(

      children: [

        Positioned.fill(

          child: Image.asset(

            "assets/images/login_bg.png",

            fit: BoxFit.cover,

          ),

        ),

        Positioned.fill(

          child: Container(

            decoration: BoxDecoration(

              gradient: LinearGradient(

                begin: Alignment.topCenter,

                end: Alignment.bottomCenter,

                colors: [

                  Colors.black.withOpacity(0.25),

                  Colors.black.withOpacity(0.70),

                ],

              ),

            ),

          ),

        ),

        SafeArea(

          child: Center(

            child: SingleChildScrollView(

              child: Padding(

                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),

                child: Column(

                  children: [

                    const SizedBox(height: 60),

                    Image.asset(

                      "assets/icon/icon.png",

                      width: 100,

                    ),

                    const SizedBox(height: 25),

                  Text(

  "GaMento",

  style: GoogleFonts.playfairDisplay(

    fontSize: 52,

    fontWeight: FontWeight.w700,

    color: Colors.white,

    height: 0.9,

  ),

),

                    const SizedBox(height: 8),

                    const Text(

                      "Game     Memory     Momento",

                      textAlign: TextAlign.center,

                      style: TextStyle(

                        color: Colors.white70,

                        fontSize: 17,

                        letterSpacing: 2,

                        fontWeight: FontWeight.w300,

                      ),

                    ),

                    const SizedBox(height: 90),

                    if(showStartButton)

                      SizedBox(

                        width: 220,

                        height: 52,

                        child: ElevatedButton(

                          onPressed: startApp,

                          style: ElevatedButton.styleFrom(

                            backgroundColor:
                            const Color(0xFF2563EB),

                            elevation: 12,

                            shape:

                            RoundedRectangleBorder(

                              borderRadius:
                              BorderRadius.circular(30),

                            ),

                          ),

                          child: const Text(

                            "START",

                            style: TextStyle(

                              fontSize: 18,

                              fontWeight:
                              FontWeight.bold,

                              letterSpacing: 1,

                            ),

                          ),

                        ),

                      )

                    else

                      Column(

                        children: [

                          SizedBox(

                            width: 220,

                            height: 52,

                            child: ElevatedButton(

                              onPressed:

                              loading
                                  ? null
                                  : () {

                                authenticateUser(true);

                              },

                              style:
                              ElevatedButton.styleFrom(

                                backgroundColor:
                                const Color(0xFF2563EB),

                                elevation: 12,

                                shape:

                                RoundedRectangleBorder(

                                  borderRadius:
                                  BorderRadius.circular(30),

                                ),

                              ),

                              child:

                              const Text(

                                "Sign Up",

                                style: TextStyle(

                                  fontSize: 18,

                                  fontWeight:
                                  FontWeight.bold,

                                ),

                              ),

                            ),

                          ),

                          const SizedBox(height: 18),

                          SizedBox(

                            width: 220,

                            height: 52,

                            child: OutlinedButton(

                              onPressed:

                              loading
                                  ? null
                                  : () {

                                authenticateUser(false);

                              },

                              style:
                              OutlinedButton.styleFrom(

                                side:
                                const BorderSide(

                                  color:
                                  Colors.white70,

                                  width: 1.5,

                                ),

                                shape:

                                RoundedRectangleBorder(

                                  borderRadius:
                                  BorderRadius.circular(30),

                                ),

                              ),

                              child:

                              const Text(

                                "Sign In",

                                style: TextStyle(

                                  color:
                                  Colors.white,

                                  fontSize: 18,

                                  fontWeight:
                                  FontWeight.bold,

                                ),

                              ),

                            ),

                          ),

                          const SizedBox(height: 18),

                          TextButton(

                            onPressed:
                            continueAsGuest,

                            child:

                            const Text(

                              "Continue as Guest",

                              style: TextStyle(

                                color:
                                Colors.white70,

                                fontSize: 15,

                                fontWeight:
                                FontWeight.w500,

                              ),

                            ),

                          ),

                        ],

                      ),

                    const SizedBox(height: 90),

                    const Text(

                      "Sharpen your brain one level at a time ⚡",

                      textAlign: TextAlign.center,

                      style: TextStyle(

                        color: Colors.white60,

                        fontSize: 13,

                        letterSpacing: 1,

                      ),

                    ),

                    const SizedBox(height: 20),

                  ],

                ),

              ),

            ),

          ),

        ),

      ],

    ),

  );

}
}