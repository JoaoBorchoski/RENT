import 'package:locacao/presentation/components/app_list_dismissible_card.dart';
import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/domain/models/usuarios/dependentes.dart';

class DependentesListWidget extends StatefulWidget {
  final Dependentes dependentes;

  const DependentesListWidget(
    this.dependentes, {
    Key? key,
  }) : super(key: key);

  @override
  State<DependentesListWidget> createState() => _DependentesListWidgetState();
}

class _DependentesListWidgetState extends State<DependentesListWidget> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppDismissible(
      direction: DismissDirection.none,
      endToStart: () {},
      startToEnd: () {},
      onDoubleTap: () {},
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: widget.dependentes.desabilitado! ? AppColors.delete : AppColors.success,
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
                elevation: 5,
                child: ExpansionTile(
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
                    (widget.dependentes.nome).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: AppColors.cardGreyText,
                    ),
                  ),
                  subtitle: Text(
                    'Cód. Sócio: ${(widget.dependentes.codigoSocio).toString()}',
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
                                widget.dependentes.email!,
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
                                widget.dependentes.telefone!,
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
                                'Idade:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.cardGreyText,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                widget.dependentes.idade.toString(),
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
                                widget.dependentes.cpf!,
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
