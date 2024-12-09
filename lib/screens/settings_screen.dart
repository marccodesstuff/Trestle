import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _switchValue = false;
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Setting 1'),
            trailing: Switch(
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Setting 2'),
            subtitle: Text('Description of setting 2'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to another settings page or perform an action
            },
          ),
          ListTile(
            title: Text('Setting 3'),
            subtitle: Text('Description of setting 3'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to another settings page or perform an action
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Adjust Setting 4'),
                Slider(
                  value: _sliderValue,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                  min: 0,
                  max: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}