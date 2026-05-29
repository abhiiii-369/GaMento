import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/game_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../timer/timer_screen.dart';
import '../login/login_screen.dart';
import '../profile/profile_screen.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import '../../services/music_service.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  Widget menuCard({

    required IconData icon,
    required String title,
    required VoidCallback onTap,

  }){

    return GestureDetector(

      onTap:onTap,

      child:Container(

        width:double.infinity,
        height:85,

        margin:
        const EdgeInsets.only(
            bottom:20
        ),

        decoration:

        BoxDecoration(

          color:
          Colors.transparent,

          border: Border.all(

  color:
  Colors.white.withOpacity(0.18),

),

          boxShadow:[

            BoxShadow(

              color:
              const Color(0xFF60A5FA),
                  
              

            )

          ],

        ),

        child:Row(

          children:[

            const SizedBox(
                width:22
            ),

            Icon(

              icon,

              size:32,

              color:
              Colors.deepPurple,

            ),

            const SizedBox(
                width:18
            ),

            Expanded(

              child:Text(

                title,

                style:
                const TextStyle(

                  color:
                  Colors.white,

                  fontSize:19,

                  fontWeight:
                  FontWeight.w600,

                ),

              ),

            ),

            const Padding(

              padding:
              EdgeInsets.only(
                  right:18
              ),

              child:Icon(

                Icons.arrow_forward_ios_rounded,

                color:
                Colors.white54,

                size:18,

              ),

            )

          ],

        ),

      ),

    );

  }
  Widget _actionButton(

  BuildContext context,
  IconData icon,
  String text,
  VoidCallback onTap,

){

  return GestureDetector(

    onTap: onTap,

    child: Column(

      children: [

        Container(

          width: 90,

          height: 90,

          decoration: BoxDecoration(

            shape: BoxShape.circle,

            color:
            Colors.white.withOpacity(0.12),

            border: Border.all(

              color:
              Colors.white.withOpacity(0.25),

              width: 1.5,

            ),

            boxShadow: [

              BoxShadow(

                color:
                const Color(0xFF60A5FA)
                    .withOpacity(0.35),

                blurRadius: 25,

                spreadRadius: 2,

              ),

            ],

          ),

          child: Icon(

            icon,

            color: Colors.white,

            size: 42,

          ),

        ),

        const SizedBox(height: 10),

        Text(

          text,

          style: const TextStyle(

            color: Colors.white,

            fontSize: 16,

            fontWeight: FontWeight.w600,

          ),

        ),

      ],

    ),

  );

}

  /// CHECK GLOBAL COOLDOWN

  Future<bool> checkCooldown(
      BuildContext context
      ) async {

    final prefs =
    await SharedPreferences
        .getInstance();

    String? cooldown =

    prefs.getString(
        "cooldownEnd"
    );

    if(cooldown != null){

      DateTime end =

      DateTime.parse(
          cooldown
      );

      if(DateTime.now().isBefore(end)){

        Duration remain =

        end.difference(
            DateTime.now()
        );

        showDialog(

          context:context,

          builder:(_){

            return AlertDialog(

              backgroundColor:
              Colors.grey[900],

              title:
              const Text(

                "Cooldown Active",

                style:
                TextStyle(
                    color:
                    Colors.white
                ),

              ),

              content:
              Text(

                "Mind exhausted ⚡\n\nTry again in ${remain.inHours}h ${remain.inMinutes % 60}m",

                style:
                const TextStyle(
                    color:
                    Colors.white70
                ),

              ),

              actions:[

                ElevatedButton(

                  onPressed:(){

                    Navigator.pop(
                        context
                    );

                  },

                  child:
                  const Text(
                      "OK"
                  ),

                )

              ],

            );

          },

        );

        return true;

      }

    }

    return false;

  }

  /// CHECK TIMER FOR GAME

  Future<void> checkTimer(
      BuildContext context
      ) async {

    bool locked =

    await checkCooldown(
        context
    );

    if(locked)return;

    final prefs =
    await SharedPreferences
        .getInstance();

    String? timerEnd =

    prefs.getString(
        "focusEnd"
    );

   if(timerEnd == null){

  await MusicService.pauseMusic();

  await Navigator.push(

    context,

    MaterialPageRoute(

      builder:
          (_)=>
      const GameScreen(),

    ),

  );

  await MusicService.resumeMusic();

  return;

}

    DateTime endTime =

    DateTime.parse(
        timerEnd
    );

    if(

    DateTime.now()
        .isAfter(endTime)

    ){

      final cooldownEnd =

      DateTime.now().add(

        const Duration(
            hours:6
        ),

      );

      await prefs.setString(

        "cooldownEnd",

        cooldownEnd.toIso8601String(),

      );

      showDialog(

        context:context,

        builder:(_){

          return AlertDialog(

            backgroundColor:
            Colors.grey[900],

            title:
            const Text(

              "Focus Play Ended",

              style:
              TextStyle(
                  color:
                  Colors.white
              ),

            ),

            content:
            const Text(

              "Timer exceeded.\n\nA 6 hour cooldown has started.",

              style:
              TextStyle(
                  color:
                  Colors.white70
              ),

            ),

            actions:[

              ElevatedButton(

                onPressed:(){

                  Navigator.pop(
                      context
                  );

                },

                child:
                const Text(
                    "OK"
                ),

              )

            ],

          );

        },

      );

      return;

    }

    await MusicService.pauseMusic();

await Navigator.push(

  context,

  MaterialPageRoute(

    builder:
        (_)=>
    const GameScreen(),

  ),

);

await MusicService.resumeMusic();
      }

  /// OPEN PORTFOLIO

  Future<void> openPortfolio() async {

    final Uri url = Uri.parse(

      "https://abhinand-a-s.vercel.app/"

    );

    await launchUrl(

      url,

      mode:
      LaunchMode.externalApplication,

    );

  }

  @override
  Widget build(
      BuildContext context
      ){

    return Scaffold(

      backgroundColor:
      const Color(
          0xff0D1117
      ),

      drawer:

      SizedBox(

        width:230,

        child:

        Drawer(

          backgroundColor:
          const Color.fromARGB(216, 3, 19, 49),

          child:

          SafeArea(

            child:

            Column(

              children:[

                const SizedBox(
                    height:30
                ),

                 Text(

  "GaMento",

  textAlign: TextAlign.center,

  style: GoogleFonts.playfairDisplay(

    color: const Color.fromARGB(
      255,
      210,
      195,
      195,
    ),

    fontSize: 20,

    fontWeight: FontWeight.bold,

  ),

),  
      
    

                const SizedBox(
                    height:40
                ),

                ListTile(

                  leading:
                  const Icon(

                    Icons.person_outline,

                    color:
                    Colors.white,

                  ),

                  title:
                  const Text(

                    "Profile",

                    style:
                    TextStyle(
                        color:
                        Colors.white
                    ),

                  ),

                  onTap:(){

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder:
                            (_)=>
                        const ProfileScreen(),

                      ),

                    );

                  },

                ),

                ListTile(

                  leading:
                  const Icon(

                    Icons.language,

                    color:
                    Colors.white,

                  ),

                  title:
                  const Text(

                    "Contact",

                    style:
                    TextStyle(
                        color:
                        Colors.white
                    ),

                  ),

                  onTap:(){

                    openPortfolio();

                  },

                ),

                ListTile(

                  leading:
                  const Icon(

                    Icons.logout_rounded,

                    color:
                    Colors.red,

                  ),

                  title:
                  const Text(

                    "Logout",

                    style:
                    TextStyle(
                        color:
                        Colors.red
                    ),

                  ),

                  onTap:() async {

                    await auth.FirebaseAuth
                        .instance
                        .signOut();

                    final prefs =
                    await SharedPreferences
                        .getInstance();

                    await prefs.setBool(
                        "loggedIn",
                        false
                    );

                    if(context.mounted){

                      Navigator.pushAndRemoveUntil(

                        context,

                        MaterialPageRoute(

                          builder:
                              (_)=>
                          const LoginScreen(),

                        ),

                            (route)=>false,

                      );

                    }

                  },

                ),

              ],

            ),

          ),

        ),

      ),

      appBar:
      AppBar(
        actions: [
IconButton(

  icon: Icon(

    MusicService.isMuted

        ? Icons.music_off_rounded

        : Icons.music_note_rounded,

    

  ),

  onPressed: () async {

    await MusicService.toggleMusic();
    setState(() {});

    

  },

),

  IconButton(

    icon: const Icon(

      Icons.exit_to_app_rounded,


      size: 24,

    ),

    onPressed: () {

      showDialog(

        context: context,

        builder: (_) {

          return AlertDialog(

            backgroundColor:
            Colors.grey[900],

            title: const Text(

              "Exit GaMento",

              style: TextStyle(
                color: Colors.white,
              ),

            ),

            content: const Text(

              "Are you sure you want to close the app?",

              style: TextStyle(
                color: Colors.white70,
              ),

            ),

            actions: [

              TextButton(

                onPressed: () {

                  Navigator.pop(context);

                },

                child: const Text(
                  "Cancel",
                ),

              ),

              ElevatedButton(

                onPressed: () {

                  SystemNavigator.pop();

                },

                child: const Text(
                  "Exit",
                ),

              ),

            ],

          );

        },

      );

    },

  ),

],
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
       
        

        elevation:0,
        surfaceTintColor: Colors.transparent,

        centerTitle:true,

        leading:
        

        Builder(

          builder:(context){

            return IconButton(

              icon:
              const Icon(

                Icons.menu_rounded,

                color:
                Colors.white,

                size:28,

              ),

              onPressed:(){

                Scaffold.of(context)
                    .openDrawer();

              },

            );

          },

        ),

        title:
        const Text(

          "GaMento",

          style:TextStyle(

            fontWeight:
            FontWeight.bold,

            fontSize:28,
            color:
            Colors.transparent

          

          ),

        ),

      ),

      body: Stack(

  children: [

    Positioned.fill(

      child: Image.asset(

        "assets/images/home_bg.png",

        fit: BoxFit.cover,

      ),

    ),
    Positioned.fill(

  child: BackdropFilter(

    filter: ImageFilter.blur(

      sigmaX: 0,
      sigmaY: 0,

    ),

    child: Container(

      color: Colors.transparent,

    ),

  ),

),


    Positioned.fill(

      child: Container(

        color: Colors.black.withOpacity(0.45),

      ),

    ), 
          

        
    
    SafeArea(

      child: Center(

        child: ConstrainedBox(

          constraints:
          const BoxConstraints(
            maxWidth: 420,
          ),

          child: Padding(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 24,
            ),
child: Column(

  children: [

    const SizedBox(height: 30),

 

    const SizedBox(height: 8),

    Text(

      "Challenge Your Mind",

      textAlign: TextAlign.center,

      style: GoogleFonts.playfairDisplay(

        color: const Color.fromARGB(
          255,
          210,
          195,
          195,
        ),

        fontWeight: FontWeight.w900,

        fontSize: 34,

        height: 1.1,

      ),

    ),

    const SizedBox(height: 10),

    const Text(

      "Memory • Focus • Discipline",

      style: TextStyle(

        color: Colors.white70,

        fontSize: 16,

      ),

    ),

    const SizedBox(height: 50),
    Column(

      children: [

        _actionButton(
          context,
          Icons.play_arrow_rounded,
          "Play",
          () {
            checkTimer(context);
          },
        ),

        const SizedBox(height: 25),

        _actionButton(
          context,
          Icons.leaderboard_rounded,
          "Ranks",
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                const LeaderBoardScreen(),
              ),
            );
          },
        ),

        const SizedBox(height: 25),

        _actionButton(
          context,
          Icons.timer_outlined,
          "Focus",
          () async {

            bool locked =
            await checkCooldown(context);

            if (locked) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                const TimerScreen(),
              ),
            );

          },
        ),

      ],

    ),

    const SizedBox(height: 80),

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