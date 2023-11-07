import 'package:locacao/data/repositories/clientes/funcionario_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:locacao/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/clientes/funcionario.dart';
import 'package:provider/provider.dart';

class FuncionarioListWidget extends StatefulWidget {
  final Funcionario funcionario;

  const FuncionarioListWidget(
    this.funcionario, {
    Key? key,
  }) : super(key: key);

  @override
  State<FuncionarioListWidget> createState() => _FuncionarioListWidgetState();
}

class _FuncionarioListWidgetState extends State<FuncionarioListWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/funcionarios'),
      endToStart: () async {
        await Provider.of<FuncionarioRepository>(context, listen: false).delete(widget.funcionario).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': widget.funcionario.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/funcionarios-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': widget.funcionario.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/funcionarios-form', arguments: data);
      },
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: widget.funcionario.desabilitado! ? AppColors.delete : AppColors.success,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                color: AppColors.lightGrey,
                child: ExpansionTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black87),
                      child: Image.network(
                        fit: BoxFit.cover,
                        height: 50,
                        width: 50,
                        widget.funcionario.avatar!,
                        errorBuilder: (context, error, stackTrace) {
                          return FittedBox(
                            fit: BoxFit.fill,
                            child: Icon(
                              Icons.account_circle,
                              size: 42,
                              color: AppColors.lightGrey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  iconColor: Colors.black87,
                  collapsedIconColor: Colors.black87,
                  backgroundColor: AppColors.lightGrey,
                  expandedAlignment: Alignment.centerLeft,
                  childrenPadding: EdgeInsets.only(bottom: 16),
                  initiallyExpanded: _isExpanded,
                  onExpansionChanged: (value) {
                    setState(() {
                      _isExpanded = value;
                    });
                  },
                  title: Text(
                    (widget.funcionario.nome).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.cardGreyText,
                    ),
                  ),
                  subtitle: Text(
                    'Matrícula: ${(widget.funcionario.matricula).toString()}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.cardGreyText,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Email:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.cardGreyText,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                widget.funcionario.email!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.cardGreyText,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Telefone:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.cardGreyText,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                widget.funcionario.telefone!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.cardGreyText,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'CPF:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.cardGreyText,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                widget.funcionario.cpf!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.cardGreyText,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
