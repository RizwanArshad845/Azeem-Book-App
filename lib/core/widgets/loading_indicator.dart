import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: context.colors.primary),
    );
  }
}
