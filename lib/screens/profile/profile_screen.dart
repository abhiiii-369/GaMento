import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login_screen.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();

}

class _ProfileScreenState
    extends State<ProfileScreen> {

  String username = "Player";

  bool guestMode = false;

  List<int> recentScores = [];

  @override
  void initState() {

    super.initState();

    loadData();

  }

  Future<void> loadData() async {

    final prefs =
    await SharedPreferences
        .getInstance();

    guestMode =
        prefs.getBool(
            "guestMode"
        ) ?? false;

    /// USERNAME

    if(guestMode){

      username =

          prefs.getString(
              "guestUsername"
          ) ??
              "Guest";

    }

    else{

      final user =
      FirebaseAuth.instance
          .currentUser;

      if(user != null){

        final doc =

        await FirebaseFirestore
            .instance
            .collection("users")
            .doc(user.uid)
            .get();

        username =

            doc.data()?["username"]
                ??
                "Player";

      }

    }

    /// LAST FIVE SCORES

    recentScores =

        prefs.getStringList(
            "recentScores"
        )

            ?.map(
                (e)=>
                int.parse(e)
        )

            .toList()

            ??

            [];

    setState(() {});

  }

  Widget graphBar(
      int value
      ){

    double height =

    value == 0
        ?
    5
        :
    value * 5;

    return Column(

      mainAxisAlignment:
      MainAxisAlignment.end,

      children:[

        Container(

          width:25,

          height:height,

          decoration:

          BoxDecoration(

            color:
            Colors.deepPurple,

            borderRadius:
            BorderRadius.circular(
                10
            ),

          ),

        ),

        const SizedBox(
            height:8
        ),

        Text(

          value.toString(),

          style:
          const TextStyle(

            color:
            Colors.white70,

          ),

        )

      ],

    );

  }

  /// CONNECT ACCOUNT

  Future<void> connectAccount() async {

    final prefs =
    await SharedPreferences
        .getInstance();

    await prefs.setBool(
        "guestMode",
        false
    );

    await prefs.setBool(
        "loggedIn",
        false
    );

    if(mounted){

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

  }

  /// CHANGE USERNAME

  Future<void> changeUsername() async {

    final controller =
    TextEditingController();

    showDialog(

      context:context,

      builder:(context){

        return AlertDialog(

          backgroundColor:
          Colors.grey[900],

          title:
          const Text(

            "Change User ID",

            style:
            TextStyle(
                color:
                Colors.white
            ),

          ),

          content:

          TextField(

            controller:
            controller,

            style:
            const TextStyle(
                color:
                Colors.white
            ),

            decoration:

            InputDecoration(

              hintText:
              "Enter new ID",

              hintStyle:
              const TextStyle(
                  color:
                  Colors.white54
              ),

              filled:true,

              fillColor:
              const Color(
                  0xff161B22
              ),

              border:
              OutlineInputBorder(

                borderRadius:
                BorderRadius.circular(
                    15
                ),

                borderSide:
                BorderSide.none,

              ),

            ),

          ),

          actions:[

            TextButton(

              onPressed:(){

                Navigator.pop(
                    context
                );

              },

              child:
              const Text(
                  "Cancel"
              ),

            ),

            ElevatedButton(

              onPressed:() async {

                String newName =

                controller.text
                    .trim();

                if(newName.isEmpty)return;

                final existing =

                await FirebaseFirestore
                    .instance
                    .collection(
                    "usernames"
                )
                    .doc(newName)
                    .get();

                if(existing.exists){

                  if(context.mounted){

                    ScaffoldMessenger.of(
                        context
                    ).showSnackBar(

                      const SnackBar(

                        content:
                        Text(
                            "Username already taken"
                        ),

                      ),

                    );

                  }

                  return;

                }

                final prefs =
                await SharedPreferences
                    .getInstance();

                if(guestMode){

                  await prefs.setString(

                    "guestUsername",

                    newName,

                  );

                }

                else{

                  final user =
                  FirebaseAuth.instance
                      .currentUser;

                  if(user != null){

                    final oldDoc =

                    await FirebaseFirestore
                        .instance
                        .collection(
                        "users"
                    )
                        .doc(user.uid)
                        .get();

                    String oldName =

                        oldDoc.data()?["username"]
                            ??
                            "";

                    if(oldName.isNotEmpty){

                      await FirebaseFirestore
                          .instance
                          .collection(
                          "usernames"
                      )
                          .doc(oldName)
                          .delete();

                    }

                    await FirebaseFirestore
                        .instance
                        .collection(
                        "users"
                    )
                        .doc(user.uid)
                        .update({

                      "username":
                      newName

                    });

                    await FirebaseFirestore
                        .instance
                        .collection(
                        "usernames"
                    )
                        .doc(newName)
                        .set({

                      "uid":
                      user.uid

                    });

                  }

                }

                setState(() {

                  username =
                      newName;

                });

                if(context.mounted){

                  Navigator.pop(
                      context
                  );

                }

              },

              child:
              const Text(
                  "Save"
              ),

            )

          ],

        );

      },

    );

  }

  @override
  Widget build(
      BuildContext context
      ){

    final user =
    FirebaseAuth.instance
        .currentUser;

    return Scaffold(

      backgroundColor:
      const Color(
          0xff0D1117
      ),

      appBar:
      AppBar(

        backgroundColor:
        const Color(
            0xff0D1117
        ),

        elevation:0,

        centerTitle:true,

        title:
        const Text(
            "Profile"
        ),

      ),

      body:
      SingleChildScrollView(

        padding:
        const EdgeInsets.all(
            25
        ),

        child:
        Column(

          children:[

            /// PROFILE IMAGE

            CircleAvatar(

              radius:60,

              backgroundColor:
              Colors.deepPurple,

              backgroundImage:

              user?.photoURL != null

                  ?

              NetworkImage(
                  user!.photoURL!
              )

                  :

              null,

              child:

              user?.photoURL == null

                  ?

              const Icon(

                Icons.person,

                size:60,

                color:
                Colors.white,

              )

                  :

              null,

            ),

            const SizedBox(
                height:25
            ),

            /// USERNAME

            Text(

              username,

              style:
              const TextStyle(

                color:
                Colors.white,

                fontSize:30,

                fontWeight:
                FontWeight.bold,

              ),

            ),

            const SizedBox(
                height:12
            ),

            /// ONLY ONE @USERNAME

            Container(

              padding:
              const EdgeInsets.symmetric(

                horizontal:18,
                vertical:10,

              ),

              decoration:

              BoxDecoration(

                color:
                const Color(
                    0xff161B22
                ),

                borderRadius:
                BorderRadius.circular(
                    20
                ),

              ),

              child:

              Text(

                "@$username",

                style:
                const TextStyle(

                  color:
                  Colors.white,

                  fontSize:16,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),

            ),

            const SizedBox(
                height:18
            ),

            /// ACCOUNT DETAILS

            guestMode

                ?

            const Text(

              "Guest Account",

              style:
              TextStyle(

                color:
                Colors.orange,

                fontSize:16,

                fontWeight:
                FontWeight.w600,

              ),

            )

                :

            Column(

              children:[

                Text(

                  user?.email ?? "",

                  style:
                  const TextStyle(

                    color:
                    Colors.white70,

                    fontSize:16,

                  ),

                ),

                const SizedBox(
                    height:8
                ),

                const Text(

                  "Mail Connected",

                  style:
                  TextStyle(

                    color:
                    Colors.green,

                    fontSize:15,

                    fontWeight:
                    FontWeight.w600,

                  ),

                )

              ],

            ),

            const SizedBox(
                height:20
            ),

            /// CHANGE USERNAME

            SizedBox(

              width:
              double.infinity,

              height:55,

              child:
              ElevatedButton.icon(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  const Color(
                      0xff161B22
                  ),

                  shape:

                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(
                        18
                    ),

                  ),

                ),

                onPressed:
                changeUsername,

                icon:
                const Icon(
                    Icons.edit
                ),

                label:
                const Text(

                  "Change User ID",

                  style:
                  TextStyle(
                      fontSize:18
                  ),

                ),

              ),

            ),

            const SizedBox(
                height:20
            ),

            /// CONNECT TO MAIL

            if(guestMode)

              SizedBox(

                width:
                double.infinity,

                height:55,

                child:
                ElevatedButton.icon(

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    Colors.deepPurple,

                    shape:

                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(
                          18
                      ),

                    ),

                  ),

                  onPressed:
                  connectAccount,

                  icon:
                  const Icon(
                      Icons.link
                  ),

                  label:
                  const Text(

                    "Connect To Mail",

                    style:
                    TextStyle(
                        fontSize:18
                    ),

                  ),

                ),

              ),

            const SizedBox(
                height:40
            ),

            /// PERFORMANCE GRAPH

            Container(

              width:
              double.infinity,

              padding:
              const EdgeInsets.all(
                  20
              ),

              decoration:

              BoxDecoration(

                color:
                const Color(
                    0xff161B22
                ),

                borderRadius:
                BorderRadius.circular(
                    20
                ),

              ),

              child:
              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children:[

                  const Text(

                    "Performance Graph",

                    style:
                    TextStyle(

                      color:
                      Colors.white,

                      fontSize:20,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),

                  const SizedBox(
                      height:25
                  ),

                  SizedBox(

                    height:150,

                    child:
                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,

                      crossAxisAlignment:
                      CrossAxisAlignment.end,

                      children:

                      recentScores.isEmpty

                          ?

                      [

                        const Text(

                          "No Data",

                          style:
                          TextStyle(
                              color:
                              Colors.white54
                          ),

                        )

                      ]

                          :

                      recentScores
                          .map(
                              (e)=>
                              graphBar(e)
                      )
                          .toList(),

                    ),

                  )

                ],

              ),

            ),

            const SizedBox(
                height:35
            ),

            /// LAST FIVE RESULTS

            Container(

              width:
              double.infinity,

              padding:
              const EdgeInsets.all(
                  20
              ),

              decoration:

              BoxDecoration(

                color:
                const Color(
                    0xff161B22
                ),

                borderRadius:
                BorderRadius.circular(
                    20
                ),

              ),

              child:
              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children:[

                  const Text(

                    "Last Five Results",

                    style:
                    TextStyle(

                      color:
                      Colors.white,

                      fontSize:20,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),

                  const SizedBox(
                      height:20
                  ),

                  if(recentScores.isEmpty)

                    const Text(

                      "No games played yet",

                      style:
                      TextStyle(
                          color:
                          Colors.white54
                      ),

                    )

                  else

                    ...recentScores.map(

                          (score){

                        return Padding(

                          padding:
                          const EdgeInsets.only(
                              bottom:12
                          ),

                          child:
                          Row(

                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,

                            children:[

                              const Text(

                                "Level Reached",

                                style:
                                TextStyle(

                                  color:
                                  Colors.white70,

                                ),

                              ),

                              Text(

                                score.toString(),

                                style:
                                const TextStyle(

                                  color:
                                  Colors.deepPurple,

                                  fontWeight:
                                  FontWeight.bold,

                                  fontSize:18,

                                ),

                              )

                            ],

                          ),

                        );

                      },

                    )

                ],

              ),

            ),

            const SizedBox(
                height:30
            )

          ],

        ),

      ),

    );

  }

}