import 'package:flutter/material.dart';

import 'package:carive/screens/host/host_notifications/host_notifications.dart';
import 'package:carive/screens/host/host_your_cars_screen/host_your_cars.dart';
import 'package:carive/screens/host/new_or_edit_cars_screen/new_or_edit_cars.dart';
import 'package:carive/shared/constants.dart';
import 'package:carive/shared/custom_scaffold.dart';

class HostScreen extends StatelessWidget {
  const HostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
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
                    labelColor: Colors.white,
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
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Expanded(
                child: TabBarView(
                  children: <Widget>[
                    HostYourCars(),
                    HostNotifications(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: themeColorGreen,
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => NewPostScreen()),
            // );
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewOrEditCarScreen(
                        actionType: ActionType.addNewCar,
                      )),
            );
          },
          label: const Row(
            children: [
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
