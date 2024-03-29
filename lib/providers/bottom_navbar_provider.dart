import 'package:flutter/material.dart';

import 'package:carive/screens/chat/screen/chat_screen.dart';
import 'package:carive/screens/home/home.dart';
import 'package:carive/screens/notification/screen/notification_screen.dart';
import 'package:carive/screens/profile/profile_screen.dart';
import 'package:carive/screens/settings/screen/settings_screen.dart';

class BottomNavBarProvider extends ChangeNotifier {
  bool isHost = false;
  int selectedIndex = 2;
  List<Widget> widgetOptions = [
    const ChatScreen(),
    SettingsScreen(),
    const Home(),
    const NotificationScreen(),
    ProfileScreen()
  ];

  void toggleIsHost(bool value) {
    isHost = value;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}