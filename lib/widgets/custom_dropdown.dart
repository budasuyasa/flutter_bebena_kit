import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/flutter_bebena.dart';

/// Create Dropdown Button wich extended [FormField]
/// to simplified form validation
/// 
/// see [FormField]
class CustomDropdown extends FormField<String> {
  CustomDropdown({
    BuildContext                context,
    String                      title,
    List<CustomDropDownItem>    dropdownItem,
    FormFieldSetter<String>     onSaved,
    FormFieldValidator<String>  validator,

    String                      value,
    /// Change callback to make value change on selected dropdown
    ValueChanged<String>        onValueChanged
  }): assert(dropdownItem.length > 1, "Dropdown must have minimum of one item"), 
  super(
    onSaved: onSaved,
    validator: validator,
    builder: (FormFieldState formState) {
      if (value == null) value = dropdownItem[0].value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: formState.hasError ? Colors.red : Colors.grey.shade500),
              borderRadius: CustomStyles.borderRadius(withBorderRadius: 4)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Label(title, type: LabelType.captionLower, color: Theme.of(context).accentColor, marginBottom: 4),
                DropdownButton<String>(
                  isExpanded: true,
                  value: value,
                  underline: Container(),
                  isDense: true,
                  items: dropdownItem.map((CustomDropDownItem item) => DropdownMenuItem<String>(
                    value: item.value,
                    child: Label(item.title)
                  )).toList(), 
                  onChanged: (value) {
                    formState.didChange(value);
                    onValueChanged(value);
                  }
                ),
              ],
            ),
          ),

            if (formState.hasError) 
              Label(formState.errorText, fontSize: 12, color: Colors.red, margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12
              ),)
        ],
      );
    }
  );
}

class CustomDropDownItem {
  CustomDropDownItem({
    @required this.title,
    @required this.value
  });

  final String title;
  final String value;
}