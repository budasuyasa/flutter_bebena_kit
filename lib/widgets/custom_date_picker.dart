import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/libraries/extensions.dart';

/// Custom date picker using TextFormField Widget
class CustomDatePicker extends StatefulWidget {
  CustomDatePicker({
    this.initialValue,
    this.decoration,
    this.validator,
    this.onSaved,
    this.firstDate,
    this.lastDate
  });

  final String initialValue;

  final InputDecoration decoration;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;

  final DateTime firstDate;
  final DateTime lastDate;

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState(
    initialValue: initialValue
  );
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  _CustomDatePickerState({ this.initialValue });

  final String initialValue;

  final _textController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    _textController.text = initialValue ?? _selectedDate.toDate(format: "yyyy-MM-dd");
    super.initState();
  }

  void _onDateSelected() async {
    DateTime firstDate = widget.firstDate ?? DateTime(1900);
    DateTime lastDate = widget.lastDate ?? DateTime(DateTime.now().year, 12, 31);

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: (_selectedDate != null) ? _selectedDate :  DateTime.now(),
        firstDate: firstDate,
        lastDate: lastDate
    );
    setState(() {
      _selectedDate = picked != null ? picked :  _selectedDate;
      _textController.text = _selectedDate.toDate(format: 'yyyy-MM-dd');
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onDateSelected(),
      child: IgnorePointer(
        child: TextFormField(
          // initialValue: widget.initialValue,
          controller: _textController,
          decoration: widget.decoration,
          validator: widget.validator,
          onSaved: widget.onSaved,
        ),
      ),
    );
  }
}