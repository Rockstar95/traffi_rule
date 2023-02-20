import 'package:flutter/material.dart';
import 'package:traffi_rule/screens/game/game_page.dart';

import '../../utils/styles.dart';
import '../common/components/app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      body: Column(
        children: [
          getAppBar(),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, GamePage.routeName);
                },
                child: const Text("Start Game"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getAppBar() {
    return MyAppBar(
      title: "Home",
      color: Colors.white,
      backbtnVisible: false,
    );
  }
}
