import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/features/relapse_tracker/presentation/bloc/relapse_tracker_bloc.dart';

class PlegdeShowdialougeBox {
  void showPledgeDialog(
      BuildContext context, String heading, String subheading) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            heading,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )),
          content: Text(
            textAlign: TextAlign.center,
            subheading,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Pledge'),
              onPressed: () {
                // Add your pledge action here

                Navigator.pop(context);
                context
                    .read<RelapseTrackerBloc>()
                    .add(RelapseTrackerPledgeConfirmEvent());
              },
            ),
          ],
        );
      },
    );
  }
}
