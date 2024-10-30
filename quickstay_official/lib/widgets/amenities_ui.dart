import 'package:flutter/material.dart';

class AmenitiesUI extends StatefulWidget {

  String type;
  int startValue;
  Function decreaseValue;
  Function increaseValue;
  AmenitiesUI({super.key ,required this.type, required this.startValue, required this.decreaseValue, required this.increaseValue});

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


            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: ()
              {
                widget.decreaseValue();

                _valueDigit = (_valueDigit?? 0) - 1;
                setState(() {
                  
                });
              },
            ),


            Text(
              _valueDigit.toString(),
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),  
            
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: ()
              {
                widget.decreaseValue();

                _valueDigit = (_valueDigit?? 0) + 1;
                setState(() {
                  
                });
              },
            ),


          ],
        )

      ],
    );
  }
}