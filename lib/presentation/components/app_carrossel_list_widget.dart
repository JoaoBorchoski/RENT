// ignore_for_file: unused_local_variable, library_private_types_in_public_api

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/favoritos_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/domain/models/clientes/ativo.dart';
import 'package:locacao/domain/models/clientes/ativo_usuarios_locacao.dart';
import 'package:locacao/presentation/ui/usuarios/locar_list/list/recibo_modal.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppCarrosselListWidget extends StatefulWidget {
  final Ativo ativo;
  final double heightCard;
  final double marginHorizontalCard;
  final double marginVerticalCard;
  final double borderRadius;
  final bool isInList;
  final bool isHistoricoPage;
  final bool isFavorite;
  final bool showFavorito;
  final Function(TapUpDetails) onTapUpFuncion;

  final AtivoUsuariosLocacao? locacao;

  const AppCarrosselListWidget({
    required this.ativo,
    required this.heightCard,
    required this.marginHorizontalCard,
    required this.marginVerticalCard,
    required this.borderRadius,
    required this.isInList,
    required this.onTapUpFuncion,
    required this.isFavorite,
    this.showFavorito = true,
    this.isHistoricoPage = false,
    this.locacao,
    Key? key,
  }) : super(key: key);

  @override
  _AppCarrosselListWidgetState createState() => _AppCarrosselListWidgetState();
}

class _AppCarrosselListWidgetState extends State<AppCarrosselListWidget> {
  int _currentPage = 0;
  bool _isFavorite = false;
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _verificaFavorito();
  }

  Future<void> _verificaFavorito() async {
    await Provider.of<FavoritoRepository>(context, listen: false).getByAtivo(widget.ativo.id!).then((value) {
      if (value.id != null) setState(() => _isFavorite = true);
    });
  }

  Future<void> _saveFavorito() async {
    await Provider.of<FavoritoRepository>(context, listen: false).save({
      'ativoId': widget.ativo.id,
    }).then((value) {
      if (value != '') {
        setState(() {
          _isFavorite = true;
        });
      }
    });
  }

  Future<void> _deleteFavorito() async {
    await Provider.of<FavoritoRepository>(context, listen: false).delete(widget.ativo.id!).then((value) {
      if (value != '') {
        setState(() {
          _isFavorite = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    void showModalRecibo() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ReciboModal(
            locacao: widget.locacao!,
          );
        },
      );
    }

    return GestureDetector(
      onTapUp: widget.onTapUpFuncion,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: widget.marginHorizontalCard,
          vertical: widget.marginVerticalCard,
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: widget.heightCard, // Defina a altura desejada para o carrossel
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Stack(
                  children: [
                    CarouselSlider(
                      carouselController: carouselController,
                      items: widget.ativo.ativoImagens!.map((img) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                '${img.imagemNome}',
                              ),
                              fit: BoxFit.cover, // Preenche todo o espaço disponível
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: widget.heightCard,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        enlargeCenterPage: false,
                        reverse: false,
                        autoPlay: false,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        scrollDirection: Axis.horizontal,
                        scrollPhysics: ScrollPhysics(),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Row(
                        children: [
                          widget.isHistoricoPage
                              ? Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 23,
                                      height: 23,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          size: 23,
                                          Icons.wysiwyg,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          showModalRecibo();
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          widget.showFavorito
                              ? Container(
                                  margin: EdgeInsets.only(left: 6),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          _isFavorite ? Icons.star : Icons.star_border,
                                          color: _isFavorite ? Colors.amber : Colors.white,
                                          size: 25,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (!_isFavorite) {
                                              _saveFavorito();
                                            } else {
                                              _deleteFavorito();
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: const [
                              Colors.black,
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.ativo.nome ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.isInList ? 18 : 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  widget.ativo.clienteNome.toString(),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: widget.isInList ? 14 : 18,
                                  ),
                                ),
                                widget.isInList ? SizedBox(height: 6) : SizedBox.shrink(),
                              ],
                            ),
                            widget.isInList
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.attach_money,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '${widget.ativo.valor!.toStringAsFixed(2).replaceAll('.', ',')}/${widget.ativo.pagamentoDiaHoraValue ?? ''} ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: _buildPageIndicator,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget get _buildPageIndicator {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: widget.heightCard - 30),
          child: AnimatedSmoothIndicator(
            count: widget.ativo.ativoImagens!.length,
            effect: ScrollingDotsEffect(
              activeDotColor: AppColors.secondary,
              dotColor: AppColors.background,
              dotHeight: 8,
              dotWidth: 8,
              spacing: 6,
              activeDotScale: 1.5,
            ),
            onDotClicked: (index) {
              setState(() {
                _currentPage = index;
                carouselController.animateToPage(index);
              });
            },
            activeIndex: _currentPage,
          ),
        ),
      ],
    );
  }
}
