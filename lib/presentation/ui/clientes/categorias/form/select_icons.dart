// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:locacao/shared/themes/app_colors.dart';

// ignore: must_be_immutable
class SelectIcons extends StatefulWidget {
  SelectIcons({
    Key? key,
    required this.label,
    this.hintText,
    required this.controllerValue,
    required this.controllerLabel,
    required this.items,
    this.onSaved,
    this.clear,
    this.isVisible,
    this.isRequired,
    this.isDisabled,
    this.validator,
  }) : super(key: key);

  final String label;
  final String? hintText;
  final TextEditingController controllerValue;
  final TextEditingController controllerLabel;
  final List<Map<String, String>> items;
  final Function(Map<String, String> suggestion)? onSaved;
  final bool? clear;
  final bool? isVisible;
  final bool? isRequired;
  final bool? isDisabled;
  final Function(String val)? validator;

  @override
  State<SelectIcons> createState() => _SelectIconsState();
}

class _SelectIconsState extends State<SelectIcons> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible ?? true,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 14.0,
        ),
        child: TypeAheadFormField<Map<String, String>>(
          textFieldConfiguration: TextFieldConfiguration(
            decoration: InputDecoration(
              labelText: widget.isRequired == true
                  ? '${widget.label} *'
                  : widget.label,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: AppColors.primary,
                ),
              ),
              hintText: widget.hintText,
              border: OutlineInputBorder(),
              isDense: true,
              suffixIcon:
                  widget.clear != false && widget.controllerValue.text != ''
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              widget.controllerValue.text = '';
                              widget.controllerLabel.text = '';
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: AppColors.grey,
                            size: 24,
                          ),
                        )
                      : null,
            ),
            controller: widget.controllerLabel,
            enabled: widget.isDisabled != null ? !widget.isDisabled! : true,
          ),
          suggestionsCallback: (pattern) async {
            return widget.items
                .where((item) => item['label']!
                    .toLowerCase()
                    .contains(pattern.toLowerCase()))
                .toList();
          },
          hideOnEmpty: true,
          errorBuilder: (context, error) {
            return ListTile(
              title: Text('Erro!'),
            );
          },
          itemBuilder: (context, Map<String, String> suggestion) {
            return ListTile(
              title: Text(suggestion['label']!),
            );
          },
          onSuggestionSelected: widget.onSaved != null
              ? (Map<String, String> suggestion) => widget.onSaved!(suggestion)
              : (Map<String, String> suggestion) {
                  setState(() {
                    widget.controllerValue.text = suggestion['value'] ?? '';
                    widget.controllerLabel.text = suggestion['label'] ?? '';
                  });
                },
          validator: (value) {
            if (widget.isRequired == true) {
              if (widget.validator == null) {
                if (value == '') {
                  return 'Campo obrigatório';
                }
              } else {
                return widget.validator!(value ?? '');
              }
            }
            return null;
          },
        ),
      ),
    );
  }
}
