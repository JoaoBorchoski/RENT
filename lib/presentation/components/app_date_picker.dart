import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:locacao/domain/models/shared/text_input_types.dart';
import 'package:locacao/presentation/components/utils/app_text_input_types.dart';
import 'package:locacao/presentation/components/utils/app_text_input_validators.dart';
import 'package:locacao/shared/themes/app_colors.dart';

class DatePickerInput extends StatefulWidget {
  const DatePickerInput({
    super.key,
    required this.label,
    required this.controller,
    required this.onSelected,
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
    this.maxDate,
  });

  final String label;
  final TextEditingController controller;
  final Function(String value)? onChanged;
  final Function(String? value)? onSaved;
  final Function(DateTime? value) onSelected;
  final bool? clear;
  final bool? isVisible;
  final bool? isDisabled;
  final bool? isRequired;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String val)? validator;
  final TextInputType? keyboardType;
  final TextInputTypes? type;
  final DateTime? maxDate;

  @override
  State<DatePickerInput> createState() => _DatePickerInputState();
}

class _DatePickerInputState extends State<DatePickerInput> {
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
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 22),
                  suffixIconConstraints: BoxConstraints(maxHeight: 30),
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
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: widget.maxDate ?? DateTime(2100),
                  );
                  if (pickedDate != null) {
                    String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                    setState(() {
                      widget.controller.text = formattedDate;
                    });
                    widget.onSelected(pickedDate);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
