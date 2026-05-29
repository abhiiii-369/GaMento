import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {

  static Future<void> saveScore(
      int level
      ) async {

    try {

      final user =
      FirebaseAuth.instance.currentUser;

      String username = "Guest";

      String? photo;

      /// GOOGLE USER

      if(user != null){

        final userDoc =

        await FirebaseFirestore
            .instance
            .collection("users")
            .doc(user.uid)
            .get();

        final data =
        userDoc.data();

        username =

            data?["username"]
                ??
                user.displayName
                ??
                "Player";

        photo =
            user.photoURL;

      }

      /// GUEST USER

      else{

        final prefs =
        await SharedPreferences
            .getInstance();

        username =

            prefs.getString(
                "guestUsername"
            )
                ??
                "Guest";

      }

      final leaderboardRef =

      FirebaseFirestore
          .instance
          .collection(
          "leaderboard"
      )
          .doc(username);

      final existing =

      await leaderboardRef
          .get();

      /// UPDATE ONLY IF NEW SCORE IS HIGHER

      if(existing.exists){

        int oldLevel =

            existing.data()?["level"]
                ??
                0;

        if(level > oldLevel){

          await leaderboardRef
              .update({

            "username":
            username,

            "level":
            level,

            "photo":
            photo,

            "updatedAt":
            FieldValue.serverTimestamp(),

          });

        }

      }

      /// NEW PLAYER

      else{

        await leaderboardRef
            .set({

          "username":
          username,

          "level":
          level,

          "photo":
          photo,

          "updatedAt":
          FieldValue.serverTimestamp(),

        });

      }

    }

    catch(e){

      print(
          "Leaderboard Error: $e"
      );

    }

  }

}