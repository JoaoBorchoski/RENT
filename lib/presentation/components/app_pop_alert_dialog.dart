import 'package:flutter/material.dart';

import '../../shared/themes/app_colors.dart';

class AppPopAlertDialog extends StatefulWidget {
  const AppPopAlertDialog({
    Key? key,
    required this.message,
    required this.botoes,
    required this.title,
  }) : super(key: key);

  final String message;
  final String title;
  final List<Widget> botoes;

  @override
  State<AppPopAlertDialog> createState() => _AppPopAlertDialogState();
}

class _AppPopAlertDialogState extends State<AppPopAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.fromLTRB(10, 60, 10, 45),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                child: Icon(
                  Icons.error,
                  color: AppColors.alert,
                  size: MediaQuery.of(context).size.height / 10,
                ),
              ),
            ),
            Center(
              child: Text(widget.title, style: TextStyle(fontSize: 30)),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                child: Text(widget.message, style: TextStyle(fontSize: 15)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: widget.botoes,
              ),
            )
          ],
        ),
      ),
    );
  }
}
