import 'package:flutter/material.dart';

class MyRadioListTile2<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String leading;
  final ValueChanged<T?> onChanged;
  final FontWeight weight;
  final double fontSize;
  final double customHeight;
  final double customWidth;

  const MyRadioListTile2({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
    required this.weight,
    required this.fontSize,
    required this.customHeight,
     required this.customWidth
  });

  @override
  Widget build(BuildContext context) {
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
      height: customHeight,
      width: customWidth,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF46acff) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? Color(0xFF46acff) : Colors.white,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            leading,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
