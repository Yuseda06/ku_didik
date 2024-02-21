import 'package:flutter/material.dart';
import 'package:ku_didik/utils/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: TAppTheme.darkTheme,
      theme: TAppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AppHome(),
    );
  }
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: Text('KuDiDiK'),
        leading: const Icon(Icons.book_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            ElevatedButton(onPressed: () {}, child: Text('Elevated Button')),
            OutlinedButton(onPressed: () {}, child: Text('Outlined Button')),
            TextButton(onPressed: () {}, child: Text('Text Button')),
            IconButton(onPressed: () {}, icon: Icon(Icons.add)),
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add),
                label: Text(
                  'Elevated Button',
                  style: Theme.of(context).textTheme.headlineSmall,
                )),
            OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add),
                label: Text('Outlined Button')),
            TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add),
                label: Text(
                  'Text Button',
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {},
                    child: Image(
                        image: AssetImage('assets/images/kudidiklogo.png'),
                        height: 100,
                        width: 50))),
          ],
        ),
      ),
    );
  }
}
