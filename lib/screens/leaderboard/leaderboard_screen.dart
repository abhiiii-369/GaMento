import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';

class LeaderBoardScreen
    extends StatelessWidget {

  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:
      const Color(0xff0D1117),

      appBar:
      AppBar(

        backgroundColor:
        Colors.black.withOpacity(0.25),
        elevation: 0, 
        centerTitle:true,

        title:
        const Text(

          "Global Leaderboard",

          style:
          TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),

      ),

    
      body: Stack(

  children: [

    Positioned.fill(

      child: Image.asset(

        "assets/images/leaderboard_bg.png",

        fit: BoxFit.cover,

      ),

    ),
    Positioned.fill(

      child: BackdropFilter(

        filter: ImageFilter.blur(

          sigmaX: 1,
          sigmaY: 1,

        ),

        child: Container(

          color: Colors.transparent,

        ),

      ),

    ),

      Positioned.fill(

        child: Container(

          color: Colors.black.withOpacity(0.55),

        ),

      ),

    Positioned.fill(

      child: Container(

        color: Colors.black.withOpacity(0.55),

      ),

    ),

    
      StreamBuilder<QuerySnapshot>(

        stream:
        FirebaseFirestore.instance

            .collection(
            "leaderboard"
        )

            .orderBy(
            "level",
            descending:true
        )

            .limit(50)

            .snapshots(),

        builder:(context,snapshot){

          if(snapshot.connectionState
              ==
              ConnectionState.waiting){

            return
              const Center(

                child:
                CircularProgressIndicator(),

              );

          }

          if(snapshot.hasError){

            return
              Center(

                child:
                Text(

                  snapshot.error.toString(),

                  style:
                  const TextStyle(
                    color:
                    Colors.red,
                  ),

                ),

              );

          }

          if(!snapshot.hasData ||
              snapshot.data!.docs.isEmpty){

            return
              const Center(

                child:
                Text(

                  "No Players Yet",

                  style:
                  TextStyle(
                    color:
                    Colors.white70,
                  ),

                ),

              );

          }

          final players =
          snapshot.data!.docs;

          return ListView.builder(

            padding:
            const EdgeInsets.all(16),

            itemCount:
            players.length,

            itemBuilder:(context,index){

              final player =
              players[index];

              final data =
              player.data()
              as Map<String,dynamic>;

              final username =

              data.containsKey(
                  "username"
              )

                  ?

              data["username"]

                  :

              "Unknown";

              final level =

              data.containsKey(
                  "level"
              )

                  ?

              data["level"]

                  :

              0;

              final photo =

              data.containsKey(
                  "photo"
              )

                  ?

              data["photo"]

                  :

              null;

              return Container(

                margin:
                const EdgeInsets.only(
                    bottom:16
                ),

                padding:
                const EdgeInsets.all(16),

                decoration:

                BoxDecoration(

                  color:
                
Colors.white.withOpacity(0.08),
                  

                  borderRadius:
                  BorderRadius.circular(
                      20
                  ),

                  boxShadow:[

                    BoxShadow(

                      color:
                      const Color.fromARGB(255, 37, 99, 214)
                          .withOpacity(
                          0.15
                      ),

                      blurRadius:10,

                    )

                  ],

                ),

                child:
                Row(

                  children:[

                    Container(

                      width:45,

                      alignment:
                      Alignment.center,

                      child:

                      Text(

                        "#${index+1}",

                        style:
                        const TextStyle(

                          color:
                          Colors.deepPurple,

                          fontSize:22,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),

                    ),

                    const SizedBox(
                        width:10
                    ),

                    CircleAvatar(

                      radius:28,

                      backgroundColor:
                      Colors.deepPurple,

                      backgroundImage:

                      photo != null

                          ?

                      NetworkImage(
                          photo
                      )

                          :

                      null,

                    ),

                    const SizedBox(
                        width:18
                    ),

                    Expanded(

                      child:
                      Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children:[

                          Text(

                            username,

                            style:
                            const TextStyle(

                              color:
                              Colors.white,

                              fontSize:20,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),

                          const SizedBox(
                              height:6
                          ),

                          Text(

                            "Level $level",

                            style:
                            const TextStyle(

                              color:
                              Colors.white70,

                              fontSize:15,

                            ),

                          )

                        ],

                      ),

                    )

                  ],

                ),

              );

            },

          );

        },

      ),

  ],
      )
      
    
    );

  }

}