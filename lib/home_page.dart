import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ku_didik/common_widgets/didik_drawer.dart';
import 'package:ku_didik/features/authentication/models/users.dart';
import 'package:provider/provider.dart';
import 'package:ku_didik/utils/provider/profile_provider.dart';
import 'package:ku_didik/utils/provider/username_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<Users?> _userStream;
  final CollectionReference _items =
      FirebaseFirestore.instance.collection("users");
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _stream = FirebaseFirestore.instance.collection('users').snapshots();

    _userStream = readUser(user?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final usernameProvider = Provider.of<UsernameProvider>(context);

    String getGreeting() {
      var hour = DateTime.now().hour;

      if (hour < 12) {
        return 'Good Morning';
      } else if (hour < 18) {
        return 'Good Afternoon';
      } else {
        return 'Good Evening';
      }
    }

    return Scaffold(
      // appBar: RoundedAppBar(
      //   title: 'Home Page',
      // ),
      drawer: DidikDrawer(),
      body: Stack(
        children: [
          StreamBuilder<Users?>(
            stream: _userStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                profileProvider.setProfileUrl(snapshot.data!.profileUrl);
                usernameProvider.setUsername(snapshot.data!.username);
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                final String base64Image = snapshot.data!.profileUrl;
                Uint8List bytes = base64Decode(base64Image.split(',').last);
                profileProvider.setProfileUrl(snapshot.data!.profileUrl);
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0),
                          ),
                          color: Colors.amber, // Set your desired app bar color
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Set the shadow color
                              blurRadius: 10.0, // Set the blur radius
                              spreadRadius: 5.0, // Set the spread radius
                              offset: const Offset(0, 2), // Set the offset
                            ),
                          ],
                        ),
                        height: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.sort_rounded,
                                  color: Colors.white,
                                  size: 42,
                                ),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                            ),
                            SizedBox(width: 70),
                            Container(
                              padding: const EdgeInsets.only(top: 35),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${getGreeting()} !',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${snapshot.data!.username}',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 64,
                      right: 15,
                      height: 65,
                      width: 65,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/pick_image');
                        },
                        child: ClipOval(
                          child: Image.memory(
                            bytes,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text('User data not found'),
                );
              }
            },
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Some error occured${snapshot.error}"),
                  );
                }
                // Now , Cheeck if datea arrived?
                if (snapshot.hasData) {
                  QuerySnapshot querySnapshot = snapshot.data;
                  List<QueryDocumentSnapshot> document = querySnapshot.docs;

                  List<Map> items =
                      document.map((e) => e.data() as Map).toList();
                  items.sort((a, b) =>
                      (b['wordCount'] as int).compareTo(a['wordCount'] as int));
                  return Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 20),
                          child: Text('Leaderboard',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45)),
                        ),
                        Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final String base64Image =
                                    items[index]['profileUrl'];
                                Uint8List bytes =
                                    base64Decode(base64Image.split(',').last);
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 10, 30, 0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15.0), // Adjust the radius as needed
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.black26,
                                    child: ListTile(
                                      hoverColor: Colors.amber,
                                      leading: SizedBox(
                                        child: Text(
                                          (index + 1).toString(),
                                          style: TextStyle(
                                            fontSize: 45,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45,
                                          ),
                                        ),
                                        height: 50,
                                      ),
                                      title: Text(
                                        items[index]['username'],
                                        style: TextStyle(
                                            color: Colors.teal,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.monetization_on,
                                            color: Colors.amber,
                                            size: 25,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                                items[index]['wordCount']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.amber,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                          ),
                                        ],
                                      ),
                                      trailing: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 0, 4, 0),
                                        child: Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.amber[100],
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 4, 4, 4),
                                            child: ClipOval(
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              child: Image.memory(
                                                width: 50,
                                                height: 50,
                                                bytes,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  ;
                } else {
                  return const Center(
                    child: Text('User data not found'),
                  );
                }
              }),
        ],
      ),
    );
  }

  Stream<Users?> readUser(String userId) => FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots()
          .map(
        (snapshot) {
          if (snapshot.exists) {
            return Users.fromJson(snapshot.data() as Map<String, dynamic>);
          } else {
            return null;
          }
        },
      );
}

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}
