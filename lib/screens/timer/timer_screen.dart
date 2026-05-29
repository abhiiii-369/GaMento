import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_screen.dart';
import 'dart:ui';

class TimerScreen extends StatefulWidget {

  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() =>
      _TimerScreenState();

}

class _TimerScreenState
    extends State<TimerScreen> {

  int selectedMinutes = 6;

  Future<void> saveTimer() async {

    final prefs =
    await SharedPreferences
        .getInstance();

    DateTime endTime =

    DateTime.now().add(

      Duration(
          minutes:
          selectedMinutes
      ),

    );

    await prefs.setString(

      "focusEnd",

      endTime.toIso8601String(),

    );

    await prefs.remove(
        "cooldownEnd"
    );

    if(mounted){

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder:(_)=>
          const HomeScreen(),

        ),

      );

    }

  }

  @override
  Widget build(
      BuildContext context){

    return Scaffold(

  backgroundColor: Colors.black,

  body: Stack(

    children: [

      Positioned.fill(

  child: Image.asset(

    "assets/images/timer_bg.png",

    fit: BoxFit.cover,

  ),

),

Positioned.fill(

  child: BackdropFilter(

    filter: ImageFilter.blur(

      sigmaX: 2,
      sigmaY: 2,

    ),

    child: Container(

      color: Colors.transparent,

    ),

  ),

),

      Positioned.fill(

        child: Container(

          decoration: BoxDecoration(

            gradient: LinearGradient(

              begin: Alignment.topCenter,

              end: Alignment.bottomCenter,

              colors: [

                Colors.black.withOpacity(0.45),

                Colors.black.withOpacity(0.70),

              ],

            ),

          ),

        ),

      ),

      SafeArea(

        child: Padding(

          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),

          child: Column(

            children: [

              const SizedBox(height: 20),

              Row(

                children: [

                  IconButton(

                    onPressed: () {

                      Navigator.pop(context);

                    },

                    icon: const Icon(

                      Icons.arrow_back_ios_new_rounded,

                      color: Colors.white,

                    ),

                  ),

                ],

              ),

              const SizedBox(height: 10),

              Container(

                width: double.infinity,

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(

                  color: Colors.black.withOpacity(0.35),

                  borderRadius:
                  BorderRadius.circular(20),

                  border: Border.all(

                    color: Colors.orange
                        .withOpacity(0.4),

                  ),

                ),

                child: const Row(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Icon(

                      Icons.warning_amber_rounded,

                      color: Colors.orange,

                      size: 28,

                    ),

                    SizedBox(width: 12),

                    Expanded(

                      child: Text(

                        "If the timer exceeds, a 6 hour cooldown period will begin. During this time you cannot access the game or timer.",

                        style: TextStyle(

                          color: Colors.white70,

                          fontSize: 14,

                          height: 1.5,

                        ),

                      ),

                    )

                  ],

                ),

              ),

              Expanded(

                child: Center(

                  child: Container(

                    width: 320,

                    padding:
                    const EdgeInsets.symmetric(

                      horizontal: 25,
                      vertical: 40,

                    ),

                    decoration: BoxDecoration(

                      color:
                      Colors.white.withOpacity(0.08),

                      borderRadius:
                      BorderRadius.circular(30),

                      border: Border.all(

                        color: Colors.white
                            .withOpacity(0.15),

                      ),

                      boxShadow: [

                        BoxShadow(

                          color: const Color(
                              0xFF60A5FA)
                              .withOpacity(0.25),

                          blurRadius: 25,

                        ),

                      ],

                    ),

                    child: Column(

                      mainAxisSize:
                      MainAxisSize.min,

                      children: [

                        const Icon(

                          Icons.timer_outlined,

                          size: 60,

                          color: Color(
                              0xFF60A5FA),

                        ),

                        const SizedBox(
                            height: 25),

                        DropdownButton<int>(

                          dropdownColor:
                          Colors.black,

                          value:
                          selectedMinutes,

                          underline:
                          Container(),

                          iconEnabledColor:
                          Colors.white,

                          style:
                          const TextStyle(

                            color:
                            Colors.white,

                            fontSize: 34,

                            fontWeight:
                            FontWeight.bold,

                          ),

                          items:

                          List.generate(

                            25,

                            (index) {

                              int minutes =
                                  index + 6;

                              return DropdownMenuItem(

                                value: minutes,

                                child: Text(
                                  "$minutes min",
                                ),

                              );

                            },

                          ),

                          onChanged: (value) {

                            setState(() {

                              selectedMinutes =
                              value!;

                            });

                          },

                        ),

                        const SizedBox(
                            height: 18),

                        Text(

                          "Selected : $selectedMinutes min",

                          style:
                          const TextStyle(

                            color:
                            Colors.white70,

                            fontSize: 15,

                          ),

                        ),

                      ],

                    ),

                  ),

                ),

              ),

              Padding(

                padding:
                const EdgeInsets.only(
                    bottom: 55),

                child: SizedBox(

                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton(

                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      const Color(
                          0xFF2563EB),

                      shape:

                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(
                            20),

                      ),

                    ),

                    onPressed: () {

                      saveTimer();

                    },

                    child: const Text(

                      "Start Focus Play",

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    ],

  ),

);
      }
    }
