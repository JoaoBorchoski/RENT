import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class AppPopSuccessDialog extends StatefulWidget {
  const AppPopSuccessDialog({
    Key? key,
    required this.message,
    this.btnPress,
  }) : super(key: key);

  final String message;
  final Function()? btnPress;

  @override
  State<AppPopSuccessDialog> createState() => _AppPopSuccessDialogState();
}

class _AppPopSuccessDialogState extends State<AppPopSuccessDialog> {
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
                  Icons.check_circle_outline_outlined,
                  color: AppColors.success,
                  size: MediaQuery.of(context).size.height / 10,
                ),
              ),
            ),
            Center(
              child: Text('Sucesso!', style: TextStyle(fontSize: 30)),
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
                children: [
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () {
                        if (widget.btnPress != null) {
                          widget.btnPress!();
                        }
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: AppColors.background),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
