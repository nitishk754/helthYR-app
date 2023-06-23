import 'package:flutter/material.dart';


class MyRadioListTile2<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String leading;
  final Widget? title;
  final ValueChanged<T?> onChanged;

  const MyRadioListTile2({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          // height: 50, 
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: [
              _customRadioButton,
             
            ],
          ),
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return SizedBox(
      height: 30,
      width: 50,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF46acff) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? Color(0xFF46acff): Colors.white,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            leading,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
  
 
}