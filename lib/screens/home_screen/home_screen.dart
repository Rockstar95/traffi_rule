import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffi_rule/providers/user_provider.dart';
import 'package:traffi_rule/screens/game/game_page.dart';

import '../../utils/styles.dart';
import '../common/components/app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String bgImage = "";

  @override
  void initState() {
    super.initState();
    bgImage = Provider.of<UserProvider>(context, listen: false).backgroundImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      body: Container(
        decoration: BoxDecoration(
          image: (bgImage.isNotEmpty) ? DecorationImage(
            image: CachedNetworkImageProvider(bgImage),
            fit: BoxFit.fill,
          ) : null,
        ),
        child: Column(
          children: [
            getAppBar(),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, GamePage.routeName);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white, width: 2),
                      color: Styles.primaryColor,
                    ),
                    child: const Text(
                      "Start Game",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
