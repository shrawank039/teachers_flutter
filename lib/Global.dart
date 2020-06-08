import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Global {
  static SpinKitFadingCircle spinKitFadingCircle = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.blue : Colors.green,
        ),
      );
    },
  );

  static SpinKitCircle spinkitCircle = SpinKitCircle(
    color: Colors.green,
    size: 50.0,
  );
}
