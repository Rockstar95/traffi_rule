import 'package:flutter/material.dart';
import 'package:traffi_rule/screens/authentication/login_screen.dart';
import 'package:traffi_rule/screens/authentication/otp_screen.dart';
import 'package:traffi_rule/screens/home_screen/main_page.dart';
import 'package:traffi_rule/splash_screen.dart';
import 'package:traffi_rule/utils/my_print.dart';

import '../screens/game/game_page.dart';

class NavigationController {
  static final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();

  Route? onGeneratedRoutes(RouteSettings routeSettings) {
    MyPrint.printOnConsole("OnGeneratedRoutes Called for ${routeSettings.name} with arguments:${routeSettings.arguments}");

    Widget? widget;

    switch(routeSettings.name) {
      case "/" : {
        widget = const SplashScreen();
        break;
      }
      case SplashScreen.routeName : {
        widget = const SplashScreen();
        break;
      }
      case LoginScreen.routeName : {
        widget = const LoginScreen();
        break;
      }
      case OtpScreen.routeName : {
        String mobile = routeSettings.arguments?.toString() ?? "";
        if (mobile.isNotEmpty) {
          widget = OtpScreen(mobile: mobile,);
        }
        break;
      }
      case MainPage.routeName : {
        widget = const MainPage();
        break;
      }
      case GamePage.routeName : {
        widget = const GamePage();
        break;
      }
    }

    if(widget != null)return MaterialPageRoute(builder: (_) => widget!);
  }
}