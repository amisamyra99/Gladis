
import 'package:flutter/material.dart';

class SyncCalenderDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Synchronize Your Calendar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Please enter the synchronization details below:'),
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle synchronization logic here
            Navigator.of(context).pop();
          },
          child: Text('Sync'),
        ),
      ],
    );
  }
}
