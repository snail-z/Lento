import 'package:flutter/material.dart';
import 'message.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo haha',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter haha'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _index = 0;

  final List<Widget> _homeWidgets = [
    Message(),
    Home(),
    Home(),
    Home(),
  ];

  void _onBottomNagigationBarTapped(index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: IndexedStack(
          index: _index,
          children: _homeWidgets,
        ),
        decoration: BoxDecoration(color: Colors.grey[100]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: _onBottomNagigationBarTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        items: [
          _getBottomNavItem(
              '动态', 'images/biji.png', 'images/biji.png'),
          _getBottomNavItem(
              ' 消息', 'images/shezhi.png', 'images/shezhi.png'),
          _getBottomNavItem(
              '分类浏览', 'images/shezhi.png', 'images/shezhi.png'),
          _getBottomNavItem('个人中心', 'images/biji.png', 'images/biji.png'),
        ],
      ),
    );
  }

  BottomNavigationBarItem _getBottomNavItem(
      String title, String normalIcon, String activeIcon) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        normalIcon,
        width: 32,
        height: 28,
      ),
      activeIcon: Image.asset(
        activeIcon,
        width: 32,
        height: 28,
      ),
      label: title,
    );
  }


}
