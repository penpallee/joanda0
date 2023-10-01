import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joanda0/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isTime;
  final String label;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  const CustomTextField(
      {required this.textEditingController,
      required this.isTime,
      required this.label,
      required this.onSaved,
      required this.validator,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 12, color: PRIMARY_COLOR, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 3.0),
        Expanded(
            flex: isTime ? 0 : 1,
            child: TextFormField(
                style: TextStyle(fontSize: 24, color: Colors.blue[900]),
                onSaved: onSaved,
                validator: validator,
                controller: textEditingController,
                cursorColor: Colors.grey,
                maxLines: isTime ? 1 : null,
                expands: !isTime,
                keyboardType:
                    isTime ? TextInputType.number : TextInputType.multiline,
                inputFormatters:
                    isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white30,
                  suffixText: isTime ? '시' : null,
                )))
      ],
    );
  }
}
