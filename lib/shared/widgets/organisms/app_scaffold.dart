import 'package:flutter/material.dart';

/// Standard page shell: app bar, safe area and constrained, padded body so
/// content stays readable on tablets and the web.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.title,
    required this.body,
    this.actions,
    this.maxContentWidth = 560,
    super.key,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(padding: const EdgeInsets.all(24), child: body),
          ),
        ),
      ),
    );
  }
}
