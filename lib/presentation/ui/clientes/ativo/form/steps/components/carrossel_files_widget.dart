import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarrosselFilesWidget extends StatefulWidget {
  const CarrosselFilesWidget({
    required this.isViewPage,
    required this.isEditPage,
    required this.ativoImagensBd,
    required this.ativoImagens,
    required this.ativoNome,
    required this.ativoValor,
    super.key,
  });

  final List<File> ativoImagens;
  final List<AtivoImagens> ativoImagensBd;
  final String ativoNome;
  final String ativoValor;
  final bool isViewPage;
  final bool isEditPage;

  @override
  State<CarrosselFilesWidget> createState() => _CarrosselFilesWidgetState();
}

class _CarrosselFilesWidgetState extends State<CarrosselFilesWidget> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 0,
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              width: constraints.maxWidth,
              height: 250,
              child: Stack(
                children: [
                  CarouselSlider(
                    items: _listImagesFileBd,
                    options: CarouselOptions(
                      height: 250,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.ativoNome,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "R\$ ${double.parse(widget.ativoValor).toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: _buildCombinedPageIndicators(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Container> get _listImageFile {
    return widget.ativoImagens.map((img) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(img),
            fit: BoxFit.cover, // Preenche todo o espaço disponível
          ),
        ),
      );
    }).toList();
  }

  List<Container> get _listImageBd {
    return widget.ativoImagensBd.map((img) {
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
    }).toList();
  }

  List<Container> get _listImagesFileBd {
    List<Container> list = [];

    list.addAll(_listImageFile);
    list.addAll(_listImageBd);

    return list;
  }

  Widget _buildCombinedPageIndicators() {
    List<int> combinedImageIndices = [
      ...widget.ativoImagensBd.asMap().keys.toList(),
    ];

    combinedImageIndices.addAll(widget.ativoImagens.asMap().keys.map((index) => index + widget.ativoImagensBd.length));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 220),
          child: AnimatedSmoothIndicator(
            count: combinedImageIndices.length,
            effect: ScrollingDotsEffect(
              activeDotColor: AppColors.secondary,
              dotColor: AppColors.background,
              dotHeight: 8,
              dotWidth: 8,
              spacing: 6,
              activeDotScale: 1.5,
            ),
            activeIndex: _currentPage,
          ),
        ),
      ],
    );
  }

  // List<Widget> _buildPageIndicator() {
  //   return widget.ativoImagens.asMap().entries.map((entry) {
  //     int index = widget.ativoImagensBd.length + entry.key;
  //     return Container(
  //       width: 8.0,
  //       height: 8.0,
  //       margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 220),
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: _currentPage == index ? AppColors.secondary : AppColors.background,
  //       ),
  //     );
  //   }).toList();
  // }

  // List<Widget> _buildPageIndicatorBd() {
  //   return widget.ativoImagensBd.asMap().entries.map((entry) {
  //     int index = entry.key;
  //     return Container(
  //       width: 8.0,
  //       height: 8.0,
  //       margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 220),
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: _currentPage == index ? AppColors.secondary : AppColors.background,
  //       ),
  //     );
  //   }).toList();
  // }

  // List<Widget> _buildPageIndicatorBdFile() {
  //   List<Widget> list = [];

  //   list.addAll(_buildPageIndicatorBd());
  //   list.addAll(_buildPageIndicator());

  //   return list;
  // }
}
