import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithBottomNavigation extends StatefulWidget {
  final Widget child;

  const ScaffoldWithBottomNavigation({super.key, required this.child});

  @override
  State<ScaffoldWithBottomNavigation> createState() => _ScaffoldWithBottomNavigationState();
}

class _ScaffoldWithBottomNavigationState extends State<ScaffoldWithBottomNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) return;

          setState(() => _currentIndex = index);

          if (index == 0) {
            context.go('/exercise');
          } else if (index == 1) {
            context.go('/');
          } else if (index == 2) {
            context.go('/settings');
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(PlatformIcons(context).volumeUp),
            label: AppLocalizations.of(context)!.exercise,
          ),
          BottomNavigationBarItem(
            icon: Icon(PlatformIcons(context).search),
            label: AppLocalizations.of(context)!.dictionary,
          ),
          BottomNavigationBarItem(
            icon: Icon(isMaterial(context)
                ? Icons.settings_outlined
                : CupertinoIcons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
    );
  }
}
