import 'package:crypto_app/SettingsPage/Settings.dart';
import 'package:crypto_app/SettingsPage/SettingsNotifier.dart';
import 'package:crypto_app/TrackerPage/TrackerPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopUpMenu extends StatelessWidget {
  PopUpMenu();
  final List<String> options = ['Settings', 'Tracker'];

  showSettings(BuildContext context, List<int> secondslist) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          insetPadding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.18,
              right: MediaQuery.of(context).size.width * 0.18),
          backgroundColor: Colors.grey[300],
          child: ChangeNotifierProvider<SettingsNotifier>(
            create: (context) => SettingsNotifier(),
            child: Consumer<SettingsNotifier>(
              builder: (context, value, child) => Settings(value, secondslist),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.list,
        color: Colors.black,
      ),
      onSelected: (String option) async {
        if (option == options[1])
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TrackerPage.create(context),
            ),
          );
        else {
          List<int> secondsList = List<int>();
          for (int i = 0; i <= 60; i++) secondsList.add(i);
          await showSettings(context, secondsList);
        }
      },
      itemBuilder: (context) => options
          .map(
            (e) => PopupMenuItem(
              value: e,
              child: Row(
                children: [
                  Icon(
                    e == options[0] ? Icons.settings : Icons.monetization_on,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text(e),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
