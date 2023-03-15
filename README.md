- A Flutter package that helps create a PIN Code screens.
- Inspired by Android PIN code screen/
- Widget can use PIN with any length (video below)

Note, that the widget has `centerBottomWidget` property, for adding one more button on the bottom left.

## Usage

```dart
  PinCodeWidget(
    minPinLength: 4,
    maxPinLength: 25,
    onChangedPin: (pin) {
      // check the PIN length and check different PINs with 4,5.. length.
    },
    onEnter: (pin, _) {
      // callback user pressed enter
    },
    centerBottomWidget: IconButton(
      icon: const Icon(
        Icons.fingerprint,
        size: 40,
      ),
      onPressed: () {},
    ),
  ),
```

1. Full example is here https://github.com/AgoraDesk-LocalMonero/flutter-pin-code-widget/blob/main/example/lib/main.dart
2. How this package used in the real app https://github.com/AgoraDesk-LocalMonero/agoradesk-app-foss/blob/main/lib/features/auth/screens/pin_code_set_screen.dart

## Showcase

![Showcase|width=400px](https://github.com/AgoraDesk-LocalMonero/flutter-pin-code-widget/blob/main/example/lib/show-case.jpg)

App from the stores https://agoradesk.com/
![Showcase|width=400px](https://github.com/AgoraDesk-LocalMonero/flutter-pin-code-widget/blob/main/example/lib/show-case.gif)

## Credits

This is a project by [Agoradesk](https://agoradesk.com/), P2P cryptocurrency trading platform.
Created by the team behind LocalMonero, the biggest and most trusted Monero P2P trading platform.