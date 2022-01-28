import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PinCodeWidget extends StatefulWidget {
  const PinCodeWidget({
    Key? key,
    required this.onFullPin,
    required this.initialPinLength,
    required this.onChangedPin,
    this.onChangedPinLength,
    this.leftBottomWidget = const SizedBox(),
    this.numbersStyle = const TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600, color: Colors.grey),
    this.borderSide = const BorderSide(width: 1, color: Colors.grey),
    this.buttonColor = Colors.black12,
    this.emptyIndicatorColor = Colors.white,
    this.filledIndicatorColor = Colors.blueAccent,
    this.deleteIconColor = Colors.white,
    this.onPressColorAnimation = Colors.yellow,
  }) : super(key: key);

  final void Function(String pin, PinCodeState state) onFullPin;
  final void Function(String pin) onChangedPin;
  final void Function(int length)? onChangedPinLength;
  final int initialPinLength;
  final Widget leftBottomWidget;
  final TextStyle numbersStyle;
  final BorderSide borderSide;
  final Color buttonColor;
  final Color emptyIndicatorColor;
  final Color filledIndicatorColor;
  final Color deleteIconColor;
  final Color onPressColorAnimation;

  @override
  State<StatefulWidget> createState() => PinCodeState();
}

class PinCodeState<T extends PinCodeWidget> extends State<T> {
  static const defaultPinLength = fourPinLength;
  static const sixPinLength = 6;
  static const fourPinLength = 4;
  final _gridViewKey = GlobalKey();
  final _key = GlobalKey<ScaffoldState>();

  late int pinLength;
  late String pin;
  late double _aspectRatio;

  int currentPinLength() => pin.length;

  @override
  void initState() {
    super.initState();
    pinLength = widget.initialPinLength;
    pin = '';
    _aspectRatio = 0;
    WidgetsBinding.instance!.addPostFrameCallback(_afterLayout);
  }

  void clear() => setState(() => pin = '');

  void reset() => setState(() {
        pin = '';
        pinLength = widget.initialPinLength;
      });

  void changePinLength(int length) {
    setState(() {
      pinLength = length;
      pin = '';
    });

    widget.onChangedPinLength?.call(length);
  }

  void setDefaultPinLength() => changePinLength(widget.initialPinLength);

  void calculateAspectRatio() {
    final renderBox = _gridViewKey.currentContext!.findRenderObject() as RenderBox;
    final cellWidth = renderBox.size.width / 3;
    final cellHeight = renderBox.size.height / 4;

    if (cellWidth > 0 && cellHeight > 0) {
      _aspectRatio = cellWidth / cellHeight;
    }

    setState(() {});
  }

  void changeProcessText(String text) {}

  void close() {
    Navigator.of(_key.currentContext!).pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(key: _key, body: body(context), resizeToAvoidBottomInset: false);

  Widget body(BuildContext context) {
    final deleteIconImage = Icon(
      CupertinoIcons.delete_left,
      color: widget.deleteIconColor,
    );

    return Container(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 40.0),
      child: Column(children: <Widget>[
        SizedBox(
          width: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(pinLength, (index) {
              const size = 10.0;
              final isFilled = pin.length > index ? true : false;

              return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? widget.filledIndicatorColor : widget.emptyIndicatorColor,
                  ));
            }),
          ),
        ),
        const Spacer(flex: 2),
        Flexible(
            flex: 24,
            child: Container(
                key: _gridViewKey,
                child: _aspectRatio > 0
                    ? GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        childAspectRatio: _aspectRatio,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(12, (index) {
                          const double marginRight = 15;
                          const double marginLeft = 15;

                          if (index == 9) {
                            return widget.leftBottomWidget;
                          } else if (index == 10) {
                            index = 0;
                          } else if (index == 11) {
                            return Container(
                              margin: const EdgeInsets.only(left: marginLeft, right: marginRight),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: widget.buttonColor,
                                  side: widget.borderSide,
                                  onPrimary: widget.onPressColorAnimation,
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () => _pop(),
                                child: deleteIconImage,
                              ),
                            );
                          } else {
                            index++;
                          }

                          return Container(
                            margin: const EdgeInsets.only(left: marginLeft, right: marginRight),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: widget.buttonColor,
                                onPrimary: widget.onPressColorAnimation,
                                side: widget.borderSide,
                                shape: const CircleBorder(),
                              ),
                              onPressed: () => _push(index),
                              child: Text(
                                '$index',
                                style: widget.numbersStyle,
                              ),
                            ),
                          );
                        }),
                      )
                    : null))
      ]),
    );
  }

  void _push(int num) {
    setState(() {
      if (currentPinLength() >= pinLength) {
        return;
      }

      pin += num.toString();

      widget.onChangedPin(pin);

      if (pin.length == pinLength) {
        widget.onFullPin(pin, this);
      }
    });
  }

  void _pop() {
    if (currentPinLength() == 0) {
      return;
    }
    setState(() => pin = pin.substring(0, pin.length - 1));
  }

  void _afterLayout(dynamic _) {
    setDefaultPinLength();
    calculateAspectRatio();
  }
}
