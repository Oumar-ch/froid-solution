// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'navigation_config.dart';
import '../widgets/liquid_glass_navbar.dart'; // Utilisé pour GlossyNavBar
import '../themes/app_colors.dart'; // Importer le fichier de styles
import '../constants/app_dimensions.dart';

class MainNavigation extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;
  const MainNavigation({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  List<Widget> _navBarItemsWithLabels(BuildContext context) => List.generate(
    navigationItems(context).length,
    (i) => Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          navigationItems(context)[i].icon,
          size: AppDimensions.iconSizeMedium,
          color: Colors.white,
        ),
        SizedBox(height: AppDimensions.paddingSmall),
        SizedBox(
          width: 60,
          child: Text(
            navigationItems(context)[i].label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),
        ),
      ],
    ),
  );

  // DEBUG : Affiche dans la console l'index sélectionné et la page associée
  void _onNavTap(int index) {
    debugPrint(
      'Navigation tap index: $index, page: ${navigationItems(context)[index].label}',
    );
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: AppDimensions.paddingLarge,
                left: AppDimensions.paddingMedium,
                right: AppDimensions.paddingMedium,
                bottom: AppDimensions.paddingSmall,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusLarge,
                  ),
                  color: Colors.white.withOpacity(0.01),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                    width: 1.2,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingMedium,
                    horizontal: AppDimensions.paddingSmall,
                  ),
                  child: Text(
                    navigationItems(
                      context,
                    )[_selectedIndex].label.toUpperCase(),
                    style: AppTextStyles.title(widget.isDark),
                  ),
                ),
              ),
            ),
            Expanded(child: navigationItems(context)[_selectedIndex].page),
          ],
        ),
        bottomNavigationBar: GlossyNavBar(
          borderRadius: AppDimensions.navBarRadius,
          opacity: 0.18,
          margin: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingSmall,
            vertical: AppDimensions.paddingSmall,
          ),
          padding: null,
          height: AppDimensions.navBarHeight + 8,
          width: MediaQuery.of(context).size.width,
          child: CurvedNavigationBar(
            index: _selectedIndex,
            height: AppDimensions.navBarHeight,
            backgroundColor: Colors.transparent,
            color: Colors.transparent,
            buttonBackgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOutCubic,
            animationDuration: const Duration(milliseconds: 500),
            items: _navBarItemsWithLabels(context),
            onTap: _onNavTap,
          ),
        ),
      ),
    );
  }
}
