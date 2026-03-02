import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/log_console.dart';
import '../utils/global_config.dart';
import '../widgets/app_breadcrumb.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key, this.breadcrumbItems});

  final List<String>? breadcrumbItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBreadcrumb(
          items: breadcrumbItems ??
              [
                context.l10n.get('home'),
                context.l10n.get('logs'),
              ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LogConsole(key: logConsoleKey),
      ),
    );
  }
}
