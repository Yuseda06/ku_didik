import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DidikButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? usernameController;
  final TextEditingController? profileUrlController;
  final String hintText;
  final Color buttonColor;
  final bool isSignIn;
  final BuildContext? context;

  DidikButton({
    required this.emailController,
    required this.passwordController,
    required this.hintText,
    required this.buttonColor,
    required this.isSignIn,
    this.usernameController,
    this.profileUrlController,
    this.context,
  });

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1.0,
            blurRadius: 10.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: ElevatedButton(
        onPressed: () {
          if (isSignIn) {
            _signInWithEmailAndPassword();
          } else {
            _signUp();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        ),
        child: Text(
          hintText,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  Future<void> _signUp() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String userId = userCredential.user!.uid;

      if (usernameController != null && profileUrlController != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'username': usernameController!.text.trim(),
          'profileUrl':
              'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJQAAACUCAMAAABC4vDmAAAAY1BMVEX///8AAAD8/PylpaXDw8OAgIBSUlIZGRno6OiwsLDs7OxNTU339/fPz8/x8fGdnZ3g4OBjY2NdXV0iIiLZ2dk2NjaVlZUODg6Li4u5ubl2dnYqKipGRkZoaGgvLy9wcHA+Pj6i4+r5AAAEg0lEQVR4nO2cCZaiQAxAp6DYV5FVcLn/Kadpm1FbxCRFov2m/wGm/5OQSiVh/vwxI84TXTtu5TVKNV7lOrVO8tjwHzWjbIuDuuNQtOWrjPLs3udClr9AKW37JSel+jYVVrKCZaMznazTEeKk1E7QyR9gTkoNvpRT/CSarjkIpYc4gjsp5cpYAeNpQiSuNM5JKc3vFIKDfGII2aVqrJNSNbdTjHdSymKWWjzvHpHxOqUuRcrlPQUTipNSCauUQ5NqWaW2NKktp1NOc1KK81wGVVFzBIxSxJBiDap4T5U68uVP/Lk3wXj+5Q1VquG725RUJ6X4LoLoUuoCX1FFzgicOYFUIpyx2aTIaUoph02KnKY+EhWbVEGXKtikSBXeGZdNCnUL/QFSEZsU+ej776TeMqYM3j6+lLChS+3ZpAyOGb562KZL8R3Ib1lPvWXl6VdUpxPfbZR+xdoztqhaqhRnM6+jSnE2Yy2qFKMT+aDhO2RGiJmKt5VOSwoV89iI9P7xdheJvTz2+RqhfOErWybwTeuGt2H9Cbqo4ruxX0ixUiJTSGSpx1feXROjYp2zPrgmxEjxTyC/QBw2ArPaCXCfkXPScAdwaMs+qL0F1P5knojeA0gMMsnghqfRLhjjF/zFfLURW725xVp4hLZQzpwhbmdW8pQ6tK9dFcztu72l3n7FOt53r3o/fA28t8O+fgOjM2GZ6K7TSSl20v1Cx/KTwImeJCI/coLEF8oMaeAUpzGql3tO+ee19VQ4AfMOalwGzvVsO3j4O9wspzZOUHIlrrJ1v6+6bB68//n3E6h3GXacrSTzZo+Tvb57Oqmeb/h5WbJmhMWBO680Mux0+u+PWanePZ7geG63llb44Ee6xj06bescn7evPHuN/GrZp6d/CcXJvIBIDCZXj4jMmgsWYasTQmbwY6UG4/VlCnJGLRke3URErHB8xNo5np70FoYGc1AILsWKLZ4mCM11g4EjFPRlNX+exY3xsMHO/vBGkA/QYAaKAVXOQD/WMQW1/kneEcaCiSryBBQLZmoj8Oqd8eBOxP18CvAqhqlgmQPcFcV1783YQO9e/mzTiYcDtOEnGFLwoDJYEcYDbf8LpfMz0FVZ4ncoNHqgFHk/n0IDc/IlnaCjeNGXD/r6ib580C+oDfbzKcAqdcGTbwR2+hlsc1IArS1YO1mpHaQklqrPJ0B1eixyu7oAKl5Sxl7LHKCvXMOV24nPOEEaHZIl3kgFkhItEpTaQg6/95QSrVw+rn4QKbEr+xfNO0qB+glCXaA3l4I0qd5SSrgahtXDv1I/Wor+rTgN2BfmArOGa4BzB9GbA3Td2RJrDivVwjvpYlc/1CKoFimqtsgJty8QWA5+wVEz32oi0h5ofL8DuB4Hm7onZNlMv1ZktMURdwyN/mNnvE0VZgsrQWg8N1tnw9FK7JXWAVx73RUq7RTkL0ZHqqLVDDtwVq7tPamE8I6Bzjn3GK28q3ebqAKk/G0VbXZ1x6pzTernSaKDetwuG6rea5rxv2NtGq+vhnHrrA50kuQ+cffnL/N4ScTEtNX2AAAAAElFTkSuQmCC',
        });
      }

      if (context != null) {
        Navigator.pushReplacementNamed(context!, '/home');
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        // Handle Firebase Authentication errors
        switch (e.code) {
          case 'invalid-email':
            showToast('Please enter a valid email');
            break;
          case 'user-disabled':
            showToast('User with this email has been disabled');
            break;
          case 'user-not-found':
            showToast('User with this email not found');
            break;
          case 'wrong-password':
            showToast('Wrong password provided for this user');
            break;
          case 'email-already-in-use':
            showToast('Email address is already in use');
            break;
          case 'account-exists-with-different-credential':
            showToast('Email address already exists with a different sign-in');
            break;
          case 'requires-recent-login':
            showToast('Please sign in again to continue');
          case 'weak-password':
            showToast('Password provided is too weak');
            break;
          default:
            showToast('Error during registration: ${e.message}');
        }
      } else {
        // Handle other non-Firebase errors
        showToast('Error during registration: $e');
      }
    }
  }
}
