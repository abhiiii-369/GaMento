import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../services/firestore_service.dart';
import '../home/home_screen.dart';

class GameScreen extends StatefulWidget {

  const GameScreen({super.key});

  @override
  State<GameScreen> createState() =>
      _GameScreenState();

}

class _GameScreenState
    extends State<GameScreen> {

  List<int> gamePattern = [];
  List<int> userPattern = [];

  int level = 0;

  int activeTile = -1;

  bool canTap = false;

  bool isMuted = false;

  bool flashScreen = false;

  Timer? focusTimer;

  bool fiveMinShown = false;
  bool oneMinShown = false;

  final AudioPlayer
  audioPlayer =
  AudioPlayer();

  List<Color> colors = [

    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow

  ];

  @override
  void initState() {

    super.initState();

    loadSettings();

    loadProgress();

    monitorTimer();

  }

  /// LOAD SETTINGS

  Future<void> loadSettings() async {

    final prefs =
    await SharedPreferences
        .getInstance();

    isMuted =
        prefs.getBool(
            "isMuted"
        ) ?? false;

    setState(() {});

  }

  /// SAVE SETTINGS

  Future<void> saveSettings() async {

    final prefs =
    await SharedPreferences
        .getInstance();

    await prefs.setBool(
        "isMuted",
        isMuted
    );

  }

  /// PLAY TILE SOUND

  Future<void> playTileSound(
      int value
      ) async {

    if(isMuted)return;

    String sound = "";

    if(value == 0){

      sound = "red.mp3";

    }

    else if(value == 1){

      sound = "blue.mp3";

    }

    else if(value == 2){

      sound = "green.mp3";

    }

    else if(value == 3){

      sound = "yellow.mp3";

    }

    await audioPlayer.stop();

    await audioPlayer.play(

      AssetSource(
          "sounds/$sound"
      ),

    );

  }

  /// WRONG SOUND

  Future<void> playWrongSound() async {

    if(isMuted)return;

    await audioPlayer.stop();

    await audioPlayer.play(

      AssetSource(
          "sounds/wrong.mp3"
      ),

    );

  }

  Future<void> loadProgress() async {

    final prefs =
    await SharedPreferences
        .getInstance();

    level =
        prefs.getInt(
            "savedLevel"
        ) ?? 0;

    startGame();

  }

  Future<void> saveProgress() async {

    final prefs =
    await SharedPreferences
        .getInstance();

    await prefs.setInt(

      "savedLevel",

      level,

    );

  }

  /// TIMER MONITOR

  void monitorTimer() {

    focusTimer = Timer.periodic(

      const Duration(
          seconds:5
      ),

          (_) async {

        final prefs =

        await SharedPreferences
            .getInstance();

        String? timerEnd =

        prefs.getString(
            "focusEnd"
        );

        if(timerEnd == null)return;

        DateTime end =

        DateTime.parse(
            timerEnd
        );

        Duration remain =

        end.difference(
            DateTime.now()
        );

        /// 5 MIN WARNING

        if(

        remain.inMinutes <= 5
            &&
            !fiveMinShown
            &&
            !remain.isNegative

        ){

          fiveMinShown = true;

          showTopMessage(
              "⚠️ 5 minutes remaining"
          );

        }

        /// 1 MIN WARNING

        if(

        remain.inMinutes <= 1
            &&
            !oneMinShown
            &&
            !remain.isNegative

        ){

          oneMinShown = true;

          showTopMessage(
              "⏳ 1 minute remaining"
          );

        }

        /// TIMER EXCEEDED

        if(remain.isNegative){

          focusTimer?.cancel();

          /// START 6 HR COOLDOWN

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

          /// REMOVE TIMER

          await prefs.remove(
              "focusEnd"
          );

          /// SAVE PROGRESS

          await saveProgress();

          if(mounted){

            showDialog(

              context:context,

              barrierDismissible:false,

              builder:(_){

                return AlertDialog(

                  backgroundColor:
                  Colors.grey[900],

                  title:
                  const Text(

                    "Time Exceeded",

                    style:
                    TextStyle(
                        color:
                        Colors.white
                    ),

                  ),

                  content:
                  const Text(

                    "Your focus time ended.\n\n6 hour cooldown activated.",

                    style:
                    TextStyle(
                        color:
                        Colors.white70
                    ),

                  ),

                  actions:[

                    ElevatedButton(

                      onPressed:(){

                        Navigator.pushAndRemoveUntil(

                          context,

                          MaterialPageRoute(

                            builder:
                                (_)=>
                            const HomeScreen(),

                          ),

                              (route)=>false,

                        );

                      },

                      child:
                      const Text(
                          "Back Home"
                      ),

                    )

                  ],

                );

              },

            );

          }

        }

      },

    );

  }

  /// TOP MESSAGE

  void showTopMessage(
      String message
      ){

    OverlayEntry overlay =

    OverlayEntry(

      builder:(context){

        return Positioned(

          top:60,

          left:20,

          right:20,

          child:

          Material(

            color:
            Colors.transparent,

            child:

            Container(

              padding:
              const EdgeInsets.all(
                  15
              ),

              decoration:

              BoxDecoration(

                color:
                Colors.red,

                borderRadius:
                BorderRadius.circular(
                    15
                ),

              ),

              child:

              Row(

                children:[

                  const Icon(

                    Icons.notifications,

                    color:
                    Colors.white,

                  ),

                  const SizedBox(
                      width:10
                  ),

                  Expanded(

                    child:

                    Text(

                      message,

                      style:
                      const TextStyle(

                        color:
                        Colors.white,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),

                  )

                ],

              ),

            ),

          ),

        );

      },

    );

    Overlay.of(context)
        .insert(
        overlay
    );

    Future.delayed(

      const Duration(
          seconds:3
      ),

          (){

        overlay.remove();

      },

    );

  }

  void startGame(){

    gamePattern.clear();

    userPattern.clear();

    level = 0;

    nextLevel();

  }

  Future<void> nextLevel() async {

    canTap = false;

    userPattern.clear();

    level++;

    saveProgress();

    setState(() {});

    int randomTile =

    Random().nextInt(4);

    gamePattern.add(
        randomTile
    );

    setState(() {

      activeTile =
          randomTile;

    });

    await playTileSound(
        randomTile
    );

    await Future.delayed(

      const Duration(
          milliseconds:700
      ),

    );

    setState(() {

      activeTile = -1;

    });

    canTap = true;

  }

  void tapTile(
      int value
      ) async {

    if(!canTap)return;

    await playTileSound(
        value
    );

    userPattern.add(
        value
    );

    int current =
    userPattern.length - 1;

    if(

    userPattern[current]

        !=

        gamePattern[current]

    ){

      await playWrongSound();

      setState(() {

        flashScreen = true;

      });

      await Future.delayed(

        const Duration(
            milliseconds:250
        ),

      );

      setState(() {

        flashScreen = false;

      });

      gameOver();

      return;

    }

    if(

    userPattern.length

        ==

        gamePattern.length

    ){

      Future.delayed(

        const Duration(
            seconds:1
        ),

            (){

          nextLevel();

        },

      );

    }

  }

  String getQuote(){

    if(level <= 5){

      return
      "Every master once started small.";

    }

    if(level <= 10){

      return
      "Memory grows stronger.";

    }

    if(level <= 15){

      return
      "Patterns bend before discipline.";

    }

    return
    "Mind Titan ⚡";

  }

  void gameOver() async {

    canTap = false;

  await FirestoreService.saveScore(
        level
    );

    final prefs =
    await SharedPreferences
        .getInstance();

    List<String> scores =

    prefs.getStringList(
        "recentScores"
    ) ?? [];

    scores.insert(
        0,
        level.toString()
    );

    if(scores.length > 5){

      scores = scores.sublist(0,5);

    }

    await prefs.setStringList(

      "recentScores",

      scores,

    );

    showDialog(

      context:context,

      barrierDismissible:false,

      builder:(_){

        return AlertDialog(

          backgroundColor:
          Colors.grey[900],

          title:
          const Text(

            "Game Over",

            style:
            TextStyle(
                color:
                Colors.white
            ),

          ),

          content:
          Text(

            "Reached Level $level",

            style:
            const TextStyle(
                color:
                Colors.white70
            ),

          ),

          actions:[

            IconButton(

              onPressed:(){

                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(

                  context,

                  MaterialPageRoute(

                    builder:
                        (_)=>
                    const HomeScreen(),

                  ),

                      (route)=>false,

                );

              },

              icon:
              const Icon(

                Icons.home_rounded,

                size:35,

                color:
                Colors.blue,

              ),

            ),

            IconButton(

              onPressed:(){

                Navigator.pop(context);

                startGame();

              },

              icon:
              const Icon(

                Icons.restart_alt,

                size:35,

                color:
                Colors.green,

              ),

            )

          ],

        );

      },

    );

  }

  Widget tile(
      int value
      ){

    return GestureDetector(

      onTap:(){

        tapTile(
            value
        );

      },

      child:

      AnimatedContainer(

        duration:
        const Duration(
            milliseconds:200
        ),

        margin:
        const EdgeInsets.all(
            10
        ),

        width:140,

        height:140,

        decoration:

        BoxDecoration(

          color:

          activeTile == value

              ?

          colors[value]
              .withOpacity(
              0.4
          )

              :

          colors[value],

          borderRadius:
          BorderRadius.circular(
              25
          ),

          boxShadow:[

            BoxShadow(

              color:
              colors[value],

              blurRadius:

              activeTile == value

                  ?

              35

                  :

              8,

            )

          ],

        ),

      ),

    );

  }

  @override
  void dispose() {

    focusTimer?.cancel();

    audioPlayer.dispose();

    super.dispose();

  }

  @override
  Widget build(
      BuildContext context
      ){

    return Scaffold(

      backgroundColor:

      flashScreen

          ?

      Colors.red

          :

      Colors.black,
appBar:
AppBar(

  backgroundColor: Colors.black,

  centerTitle: true,

  title: Text(
    "LEVEL $level",
  ),

  leading: IconButton(

    onPressed: () async {

      setState(() {

        isMuted = !isMuted;

      });

      await saveSettings();

    },

    icon: Icon(

      isMuted
          ? Icons.volume_off
          : Icons.volume_up,

      color: Colors.white,

    ),

  ),

  actions: [

    IconButton(

      icon: const Icon(

        Icons.home_rounded,

        color: Colors.white,

        size: 28,

      ),

      onPressed: () {

        Navigator.pushAndRemoveUntil(

          context,

          MaterialPageRoute(

            builder: (_) =>
            const HomeScreen(),

          ),

          (route) => false,

        );

      },

    ),

    const SizedBox(width: 8),

  ],

),

      body:
      Center(

        child:
        Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children:[

            Padding(

              padding:
              const EdgeInsets.symmetric(
                  horizontal:30
              ),

              child:

              Text(

                getQuote(),

                textAlign:
                TextAlign.center,

                style:
                const TextStyle(

                  color:
                  Colors.white,

                  fontSize:18,

                  fontStyle:
                  FontStyle.italic,

                ),

              ),

            ),

            const SizedBox(
                height:40
            ),

            Row(

              mainAxisAlignment:
              MainAxisAlignment.center,

              children:[

                tile(0),
                tile(1)

              ],

            ),

            Row(

              mainAxisAlignment:
              MainAxisAlignment.center,

              children:[

                tile(2),
                tile(3)

              ],

            )

          ],

        ),

      ),

    );

  }

}