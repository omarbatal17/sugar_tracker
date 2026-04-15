import 'package:flutter/material.dart';

/// A wrapper that handles keyboard insets for scrollable content.
/// Equivalent to KeyboardAwareScrollView in React Native.
class KeyboardAwareScrollViewCompat extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const KeyboardAwareScrollViewCompat({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;

    return SafeArea(
      child: SingleChildScrollView(
        padding: (padding ?? EdgeInsets.zero).copyWith(
          bottom: (padding?.bottom ?? 0) + viewInsets.bottom,
        ),
        child: child,
      ),
    );
  }
}
