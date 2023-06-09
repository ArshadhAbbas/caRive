import 'package:carive/screens/host/host_history.dart';
import 'package:carive/screens/host/host_notifications.dart';
import 'package:carive/screens/host/host_your_cars.dart';
import 'package:carive/screens/host/new_post/new_post_screen.dart';
import 'package:carive/shared/constants.dart';
import 'package:carive/shared/custom_scaffold.dart';
import 'package:flutter/material.dart';

class HostScreen extends StatelessWidget {
  const HostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: themeColorGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tabs: const [
                      Tab(
                        text: "Your Cars",
                      ),
                      Tab(
                        text: "Notifications",
                      ),
                      Tab(
                        text: "History",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
               Expanded(
                child: TabBarView(
                  children: <Widget>[
                    HostYourCars(),
                    HostNotifications(),
                    HostHistory(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: themeColorGreen,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewPostScreen()),
            );
          },
          label: Row(
            children: const [
              Icon(Icons.add_circle_rounded),
              Text("Post New"),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
