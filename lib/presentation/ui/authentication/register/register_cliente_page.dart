import 'package:flutter/material.dart';
import 'package:locacao/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/shared/themes/app_images.dart';

class RegisterPageCliente extends StatelessWidget {
  const RegisterPageCliente({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Future<void> registerAccount() async {
      Map<String, dynamic> data = {
        "name": nameController.text,
        "login": emailController.text,
        "password": passwordController.text,
        "tipo": "cliente"
      };
      Navigator.of(context).pushReplacementNamed('/aceitar', arguments: data);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 60,
                  child: Image.asset(AppImages.signInLogo),
                ),
                Column(
                  children: [
                    FormTextInput(
                      label: "Nome",
                      controller: nameController,
                      validator: (name) {
                        if (name.isEmpty) {
                          return 'Informe um nome válido';
                        }
                        return null;
                      },
                    ),
                    FormTextInput(
                      label: "Email",
                      controller: emailController,
                      validator: (email) {
                        if (email.isEmpty) {
                          return 'Informe um email válido';
                        }
                        return null;
                      },
                    ),
                    FormTextInput(
                      isRequired: true,
                      isObscureText: true,
                      label: "Senha",
                      controller: passwordController,
                      validator: (password) {
                        if (password.isEmpty) {
                          return 'Informe uma senha válida';
                        }
                        return null;
                      },
                    ),
                    FormTextInput(
                      isObscureText: true,
                      isRequired: true,
                      controller: confirmPasswordController,
                      label: "Confirme a senha",
                      validator: (confirmPassword) {
                        if (passwordController.text != confirmPassword) {
                          return 'Senhas diferentes!';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.primary),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(20)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(AppColors.background),
                  ),
                  onPressed: () => registerAccount(),
                  child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Cadastrar',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.all(20),
                      side: BorderSide(color: AppColors.primary),
                    ),
                    onPressed: () =>
                        {Navigator.of(context).pushReplacementNamed('/')},
                    child: const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Já tenho conta',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Opacity(
                    opacity: 0.2,
                    child: SizedBox(
                      width: 110,
                      child: Image.asset(AppImages.companyLogo),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
