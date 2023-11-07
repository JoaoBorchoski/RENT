// ignore_for_file: use_build_context_synchronously, unused_field

import 'package:carousel_slider/carousel_slider.dart';
import 'package:locacao/domain/models/clientes/ativo_imagens.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class AtivoDetalheImagemPage extends StatefulWidget {
  const AtivoDetalheImagemPage({super.key, required this.ativoImagens, required this.funcaoVoltar});
  final Function()? funcaoVoltar;
  final List<AtivoImagens> ativoImagens;

  @override
  State<AtivoDetalheImagemPage> createState() => _AtivoDetalheImagemPageState();
}

class _AtivoDetalheImagemPageState extends State<AtivoDetalheImagemPage> {
  int _currentPage = 0;
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 30.0,
            left: 0.0,
            child: IconButton(
              color: AppColors.background,
              onPressed: widget.funcaoVoltar,
              icon: Icon(Icons.arrow_back),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(color: AppColors.white),
                  // child: Image.network(
                  //   fit: BoxFit.cover,
                  //   widget.ativoImagens[0].imagemNome!,
                  //   errorBuilder: (context, error, stackTrace) {
                  //     return FittedBox(
                  //       fit: BoxFit.fill,
                  //       child: Icon(
                  //         Icons.account_circle,
                  //         color: AppColors.background,
                  //       ),
                  //     );
                  //   },
                  // ),
                  child: CarouselSlider(
                    carouselController: carouselController,
                    items: widget.ativoImagens.map((img) {
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
                      height: MediaQuery.of(context).size.width,
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
                ),
              ),
            ],
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.width / 2) - 30,
            left: 0,
            right: 0,
            child: _buildPageIndicator,
          ),
        ],
      ),
    );
  }

  Widget get _buildPageIndicator {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: MediaQuery.of(context).size.width),
          child: AnimatedSmoothIndicator(
            count: widget.ativoImagens.length,
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
