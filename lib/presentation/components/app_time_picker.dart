import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locacao/domain/models/shared/text_input_types.dart';
import 'package:locacao/presentation/components/utils/app_text_input_types.dart';
import 'package:locacao/presentation/components/utils/app_text_input_validators.dart';
import 'package:locacao/shared/themes/app_colors.dart';

// ignore: must_be_immutable
class TimePickerInput extends StatefulWidget {
  TimePickerInput({
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
  });

  final String label;
  final TextEditingController controller;
  final Function(String value)? onChanged;
  final Function(String? value)? onSaved;
  final Function(String? value) onSelected;
  final bool? clear;
  final bool? isVisible;
  final bool? isDisabled;
  final bool? isRequired;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String val)? validator;
  final TextInputType? keyboardType;
  final TextInputTypes? type;

  TimeOfDay? selectedTime;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;

  @override
  State<TimePickerInput> createState() => _TimePickerInputState();
}

class _TimePickerInputState extends State<TimePickerInput> {
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
                  contentPadding: EdgeInsets.all(20),
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
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: widget.selectedTime ?? TimeOfDay.now(),
                    initialEntryMode: widget.entryMode,
                    orientation: widget.orientation,
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          materialTapTargetSize: widget.tapTargetSize,
                          colorScheme: ColorScheme.light(
                            primary: AppColors.cardColor,
                            onPrimary: AppColors.cardColor,
                            surface: AppColors.background,
                            onSurface: AppColors.primary,
                          ),
                        ),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              alwaysUse24HourFormat: true,
                            ),
                            child: child!,
                          ),
                        ),
                      );
                    },
                  );
                  if (time.toString() != 'null') {
                    setState(() {
                      widget.controller.text =
                          '${time?.hour.toString().padLeft(2, '0')}:${time?.minute.toString().padLeft(2, '0')}';
                    });
                    widget.onSelected(widget.controller.text);
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
