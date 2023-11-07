import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/locacoes_repository.dart';
import 'package:locacao/domain/models/clientes/locacoes.dart';
import 'package:locacao/domain/models/clientes/usuarios_locacao.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class LocarPage extends StatefulWidget {
  const LocarPage({super.key});

  @override
  State<LocarPage> createState() => _LocarPageState();
}

class _LocarPageState extends State<LocarPage> {
  final _formKey = GlobalKey<FormState>();
  bool _dataIsLoaded = false;
  late String clienteId;
  List<Offset> points = [];
  late String exampleImageUrl;
  String link = '';

  final _controllers = LocacoesController(
    id: TextEditingController(),
    valorTotal: TextEditingController(),
    meioPagamentoId: TextEditingController(),
    meioPagamentoNome: TextEditingController(),
    observacoes: TextEditingController(),
    status: TextEditingController(),
    dataInicio: TextEditingController(),
    dataFim: TextEditingController(),
    dataLimitePagamento: TextEditingController(),
  );

  final _controllersUsuario = UsuariosLocacaoController(
    usuarioId: TextEditingController(),
  );

  // Builder

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (args != null && !_dataIsLoaded) {
      _controllersUsuario.usuarioId!.text = args['usuarioId'] ?? '';
      clienteId = args['clienteId'] ?? '';
      _dataIsLoaded = true;
      exampleImageUrl = args['link'] ?? '';
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        await showDialog(
          context: context,
          builder: (context) {
            return AppPopAlertDialog(
              title: 'Sair sem salvar',
              message: 'Deseja mesmo sair sem salvar as alterações?',
              botoes: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      'Não',
                      style: TextStyle(color: AppColors.background),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      'Sim',
                      style: TextStyle(color: AppColors.background),
                    ),
                  ),
                ),
              ],
            );
          },
        ).then((value) => value ? Navigator.of(context).pushNamedAndRemoveUntil('/minhas-associacoes', (route) => false) : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Locacao Form'),
        showDrawer: false,
        body: formFields(context),
      ),
    );
  }

  Form formFields(context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTapUp: (TapUpDetails details) {},
              child: InteractiveViewer(
                minScale: 0.1,
                maxScale: 10,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      exampleImageUrl,
                    ),
                    CustomPaint(
                      painter: PolygonPainter(points),
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

  // ignore: unused_element
  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    try {
      _formKey.currentState?.save();

      final Map<String, dynamic> payload = {
        'id': _controllers.id!.text,
        'preco': double.parse(_controllers.valorTotal!.text),
        'meioPagamentoId': _controllers.meioPagamentoId!.text,
        'observacoes': _controllers.observacoes!.text,
        'descricao': _controllers.status!.text,
        'dateInicio': _controllers.dataInicio!.text,
        'dataFim': _controllers.dataFim!.text,
        'dataLimitePagamento': _controllers.dataLimitePagamento!.text,
      };

      await Provider.of<LocacoesRepository>(context, listen: false).save(payload).then((id) {
        if (id != '') {
          return showDialog(
            context: context,
            builder: (context) {
              return AppPopSuccessDialog(message: _controllers.id!.text == '' ? 'Registro criado com sucesso!' : 'Registro atualizado com sucesso!');
            },
          ).then((value) => Navigator.of(context).pushReplacementNamed('/minhas-associacoes'));
        }
      });
    } on AuthException catch (error) {
      return showDialog(
        context: context,
        builder: (context) {
          return AppPopErrorDialog(message: error.toString());
        },
      );
    } catch (error) {
      return showDialog(
        context: context,
        builder: (context) {
          return AppPopErrorDialog(message: 'Ocorreu um erro inesperado!');
        },
      );
    }
  }

  // ignore: unused_element
  Future<void> _cancel() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AppPopAlertDialog(
          title: 'Sair sem salvar',
          message: 'Tem certeza que deseja sair?',
          botoes: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Não',
                  style: TextStyle(color: AppColors.background),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Sim',
                  style: TextStyle(color: AppColors.background),
                ),
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (value) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }
}

class PolygonPainter extends CustomPainter {
  final List<Offset> points;
  PolygonPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()..color = Colors.blue.withOpacity(0.5);

    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path()..addPolygon(points, true);

    canvas.drawPath(path, borderPaint);
    if (points.length >= 3) {
      canvas.drawPath(path, fillPaint);
      return;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
