import 'package:flutter/material.dart';

class Cartao {
  String? numeroCartao;
  String? dataValidade;
  String? cvv;

  Cartao({
    this.numeroCartao,
    this.dataValidade,
    this.cvv,
  });
}

class CartaoController {
  TextEditingController? numeroCartao;
  TextEditingController? dataValidade;
  TextEditingController? cvv;

  CartaoController({
    this.numeroCartao,
    this.dataValidade,
    this.cvv,
  });
}
