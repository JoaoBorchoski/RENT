import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/shared/config/app_menu_options.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';

class MainMenuMeioPagamento extends StatelessWidget {
  const MainMenuMeioPagamento({super.key});

  @override
  Widget build(BuildContext context) {
    List<MenuData> menu = [
      MenuData(Icons.attach_money, 'Aceitos', '/meio-pagamento-aceito', false, ''),
      MenuData(Icons.money_off, 'Exceção', '/meio-pagamento-excecao', false, ''),
    ];

    return Scrollbar(
      thickness: 3,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: menu.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1, crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
                itemBuilder: (BuildContext context, int index) {
                  return (Card(
                    color: AppColors.primary,
                    elevation: 0.4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(menu[index].route);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            menu[index].icon,
                            size: 70,
                            color: AppColors.cardTextColor,
                          ),
                          SizedBox(height: 10),
                          Text(
                            menu[index].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, color: AppColors.background),
                          ),
                        ],
                      ),
                    ),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuMeioPagamentoPage extends StatelessWidget {
  const MenuMeioPagamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;

        Navigator.of(context).pushReplacementNamed('/');

        return retorno;
      },
      child: AppScaffold(
        title: const Text('Meios de pagamento'),
        showDrawer: true,
        body: MainMenuMeioPagamento(),
      ),
    );
  }
}
