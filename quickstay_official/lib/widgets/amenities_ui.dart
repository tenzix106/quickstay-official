import 'package:flutter/material.dart';

class AmenitiesUI extends StatefulWidget {
  final String type;
  final int startValue;
  final Function decreaseValue;
  final Function increaseValue;
  final bool isEditable; // New parameter to control editability

  AmenitiesUI({
    super.key,
    required this.type,
    required this.startValue,
    required this.decreaseValue,
    required this.increaseValue,
    this.isEditable = true, // Default to editable
  });

  @override
  State<AmenitiesUI> createState() => _AmenitiesUIState();
}

class _AmenitiesUIState extends State<AmenitiesUI> {
  int? _valueDigit;

  @override
  void initState() {
    super.initState();
    _valueDigit = widget.startValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.type,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
        Row(
          children: <Widget>[
            if (widget.isEditable) // Only show buttons if editable
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  widget.decreaseValue();
                  _valueDigit = _valueDigit! - 1;
                  if (_valueDigit! < 0) {
                    _valueDigit = 0;
                  }
                  setState(() {});
                },
              ),
            Text(
              _valueDigit.toString(),
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            if (widget.isEditable) // Only show buttons if editable
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  widget.increaseValue();
                  _valueDigit = _valueDigit! + 1;
                  setState(() {});
                },
              ),
          ],
        ),
      ],
    );
  }
}