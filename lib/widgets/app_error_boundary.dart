import 'package:flutter/material.dart';

class AppErrorBoundary extends StatefulWidget {
  final Widget child;

  const AppErrorBoundary({super.key, required this.child});

  @override
  State<AppErrorBoundary> createState() => _AppErrorBoundaryState();
}

class _AppErrorBoundaryState extends State<AppErrorBoundary> {
  bool _hasError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hasError = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const AppErrorFallback();
    }
    return widget.child;
  }
}

class AppErrorFallback extends StatelessWidget {
  const AppErrorFallback({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again later.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
