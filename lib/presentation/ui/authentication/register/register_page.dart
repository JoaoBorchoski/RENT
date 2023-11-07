import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/shared/themes/app_images.dart';
import 'package:flutter/material.dart';

class RegistroPage extends StatelessWidget {
  const RegistroPage({super.key});

  // Logo
  Widget get buildFormLogo {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(
        width: 250,
        height: 60,
        child: Image.asset(AppImages.signInLogo),
      ),
    );
  }

  // Logo Vamilly
  Widget get buildFormLogoVamilly {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Opacity(
        opacity: 0.2,
        child: SizedBox(
          width: 110,
          child: Image.asset(AppImages.companyLogo),
        ),
      ),
    );
  }

  Padding buildOutlineButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.white,
            padding: EdgeInsets.all(20),
            side: BorderSide(color: AppColors.primary),
          ),
          onPressed: () =>
              {Navigator.of(context).pushReplacementNamed('/registro-cliente')},
          child: const SizedBox(
            width: double.infinity,
            child: Text(
              'Sou Cliente',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );

  Padding buildOutlineButton2(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 15),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: EdgeInsets.all(20),
            side: BorderSide(color: AppColors.primary),
          ),
          onPressed: () =>
              {Navigator.of(context).pushReplacementNamed('/registro-user')},
          child: const SizedBox(
            width: double.infinity,
            child: Text(
              'Sou Usuário',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );

  Widget buildPage(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildFormLogo,
                  buildOutlineButton(context),
                  buildOutlineButton2(context),
                  buildFormLogoVamilly
                ],
              ),
            ))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildPage(context);
  }
}
