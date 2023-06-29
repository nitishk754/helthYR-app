import 'package:flutter/material.dart';

class MyRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String leading;
  final ValueChanged<T?> onChanged;

  const MyRadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Container(
          // height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16),
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
    return Expanded(
      child: SizedBox(
        height: 50,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white,
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
                color: isSelected ? Colors.black : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
