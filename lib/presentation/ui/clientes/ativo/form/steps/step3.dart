import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:locacao/presentation/components/app_confirm_action.dart';
import 'package:locacao/presentation/components/app_form_button.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_pop_alert_dialog.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class Step3 extends StatefulWidget {
  final GlobalKey<FormState> formKey2;
  final List<AtivoImagens> ativoImagens;
  final List<AtivoImagens> ativoImagensDeletar;
  final List<File> selectedImages;

  final bool isViewPage;
  final bool isEditPage;
  final Function() checkNextButtonIcon;
  const Step3({
    super.key,
    required this.isViewPage,
    required this.checkNextButtonIcon,
    required this.formKey2,
    required this.ativoImagens,
    required this.ativoImagensDeletar,
    required this.selectedImages,
    required this.isEditPage,
  });

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  bool isLastStep = false;
  bool _imageIsLoaded = true;
  int activeStep = 1;
  int upperBound = 9;
  String headerText = '';
  Icon nextButtonIcon = Icon(Icons.navigate_next_rounded, color: AppColors.background);
  List<Widget> actionsScaffold = [];

  // Builder

  Widget get _imageList {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: AppFormButton(submit: _selectImages, label: 'Adicionar imagens'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Número de colunas desejado
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: widget.selectedImages.length,
            itemBuilder: (context, index) {
              final image = widget.selectedImages[index];
              return GestureDetector(
                onTap: () {
                  _excluirImagem(index);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(image, fit: BoxFit.cover),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget get _imageListView {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6, // Altura máxima do Container
          ),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Número de colunas desejado
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: widget.ativoImagens.length,
            itemBuilder: (context, index) {
              final image = widget.ativoImagens[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        '${image.imagemNome}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget get _imageListEdit {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppFormButton(submit: _selectImages, label: 'Adicionar imagens'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Número de colunas desejado
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: widget.ativoImagens.length + widget.selectedImages.length,
            itemBuilder: (context, index) {
              if (index < widget.selectedImages.length) {
                final image = widget.selectedImages[index];
                return GestureDetector(
                  onTap: () {
                    _excluirImagem(index);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              } else {
                final image = widget.ativoImagens[index - widget.selectedImages.length];
                return GestureDetector(
                  onTap: () {
                    _deleteImagem(image);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            '${image.imagemNome}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _deleteImagem(AtivoImagens ativoImagens) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AppPopAlertDialog(
          title: 'Deletar imagem',
          message: 'Tem certeza que deseja remover?',
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
    ).then((value) async {
      if (value) {
        setState(() {
          widget.ativoImagensDeletar.add(ativoImagens);
          widget.ativoImagens.remove(ativoImagens);
          widget.checkNextButtonIcon();
        });
      }
    });
  }

  Future<void> _excluirImagem(int index) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmActionWidget(
          message: 'Tem certeza que deseja remover?',
          cancelButtonText: 'Não',
          confirmButtonText: 'Sim',
        );
      },
    ).then((value) {
      if (value) {
        _removeImage(index);
      }
    });
  }

  Future<void> _selectImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(imageQuality: 80);

    _imageIsLoaded = false;

    setState(() {
      widget.selectedImages.addAll(pickedImages.map((pickedImage) => File(pickedImage.path)));
      _imageIsLoaded = true;
      widget.checkNextButtonIcon();
    });
  }

  void _removeImage(int index) {
    _imageIsLoaded = false;
    setState(() {
      widget.selectedImages.removeAt(index);
      _imageIsLoaded = true;

      widget.checkNextButtonIcon();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey2,
      child: Column(
        children: [
          _imageIsLoaded
              ? widget.isViewPage
                  ? _imageListView
                  : widget.isEditPage
                      ? _imageListEdit
                      : _imageList
              : LoadWidget(),
        ],
      ),
    );
  }
}
