import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locacao/domain/models/shared/text_input_types.dart';
import 'package:locacao/presentation/components/utils/app_text_input_types.dart';
import 'package:locacao/presentation/components/utils/app_text_input_validators.dart';
import 'package:locacao/shared/themes/app_colors.dart';

// ignore: must_be_immutable
class FormTextInputLabel extends StatefulWidget {
  FormTextInputLabel({
    super.key,
    required this.label,
    required this.controller,
    this.onSaved,
    this.clear,
    this.isVisible,
    this.isDisabled,
    this.onChanged,
    this.isRequired,
    this.inputFormatters,
    this.validator,
    this.keyboardType,
    this.type,
    this.isObscureText,
  });

  final String label;
  final TextEditingController controller;
  final Function(String value)? onChanged;
  final Function(String? value)? onSaved;
  final bool? clear;
  final bool? isVisible;
  final bool? isDisabled;
  final bool? isObscureText;
  final bool? isRequired;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String val)? validator;
  final TextInputType? keyboardType;
  final TextInputTypes? type;

  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;

  @override
  State<FormTextInputLabel> createState() => _FormTextInputLabelState();
}

class _FormTextInputLabelState extends State<FormTextInputLabel> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible ?? true,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 4.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: RichText(
                text: TextSpan(
                  text: widget.label,
                  style: TextStyle(
                    color: AppColors.cardColor,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: widget.isRequired == true ? ' *' : '',
                      style: TextStyle(
                        color: AppColors.delete,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 75,
              child: TextFormField(
                obscureText: widget.isObscureText == true ? true : false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: widget.keyboardType ?? TextInputType.text,
                enabled: widget.isDisabled != null ? !widget.isDisabled! : true,
                onChanged: (value) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                },
                onSaved: widget.onSaved != null
                    ? (value) => widget.onSaved!(value)
                    : (value) => widget.controller.text = value ?? '',
                controller: widget.controller,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  isDense: true,
                  suffixIcon: widget.clear == true
                      ? IconButton(
                          iconSize: 15,
                          onPressed: () {
                            setState(() {
                              widget.controller.text = '';
                            });
                          },
                          icon: Icon(Icons.close),
                        )
                      : null,
                ),
                inputFormatters: widget.inputFormatters != null
                    ? widget.inputFormatters!
                    : filterTextInputFormatterByType(widget.type),
                validator: (value) {
                  if (widget.validator != null) {
                    return widget.validator!(value ?? '');
                  }
                  if (widget.isRequired != null && widget.isRequired!) {
                    String? validator = textInputTypesValidator(value ?? '', widget.type);
                    return validator;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
