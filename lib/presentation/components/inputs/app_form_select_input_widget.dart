import 'package:locacao/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// ignore: must_be_immutable
class FormSelectInput extends StatefulWidget {
  FormSelectInput({
    super.key,
    required this.label,
    this.hintText,
    required this.controllerValue,
    required this.controllerLabel,
    required this.itemsCallback,
    this.onSaved,
    this.clear,
    this.isVisible,
    this.isRequired,
    this.isDisabled,
    this.validator,
  });

  final String label;
  final String? hintText;
  final TextEditingController controllerValue;
  final TextEditingController controllerLabel;
  final Future<Iterable<Map<String, String>>> Function(String value) itemsCallback;
  final Function(Map<String, String> suggestion)? onSaved;
  bool? clear = false;
  final bool? isVisible;
  final bool? isRequired;
  final bool? isDisabled;
  final Function(String val)? validator;

  @override
  State<FormSelectInput> createState() => _FormSelectInputState();
}

class _FormSelectInputState extends State<FormSelectInput> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible ?? true,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 14.0,
            ),
              child: TypeAheadFormField(
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
                suggestionsCallback: (pattern) async => widget.itemsCallback(pattern),
                hideOnEmpty: true,
                  errorBuilder: ((context, error) {
            return ListTile(
              title: Text('Erro!'),
                    );
                  }),
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
