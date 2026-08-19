import 'package:flutter/material.dart';

class LoadingGate extends StatelessWidget {
  const LoadingGate({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
