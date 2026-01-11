import 'package:bibledictionary/presantion/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      centerTitle: true,
      backgroundColor: ThemeColors.royalBlueDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      
      // Golden title with scripture-inspired styling
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu_book_rounded,
              color: ThemeColors.goldPrimary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "ELROI LEXICON",
                      style: TextStyle(
                        color: ThemeColors.goldPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Bible Dictionary",
                      style: TextStyle(
                        color: ThemeColors.goldLight,
                        fontSize: 9,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.8,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ✅ FIXED: Make sure leading icon opens the drawer
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: ThemeColors.royalBlueMedium,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ThemeColors.goldPrimary,
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.menu, // Use menu icon for drawer
            color: ThemeColors.goldPrimary,
            size: 20,
          ),
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer(); // This opens the drawer
        },
      ),

      // Action icons
      actions: [
        _buildAppBarIcon(Icons.bookmark_outline, "Bookmarks"),
      ],
    );
  }

  Widget _buildAppBarIcon(IconData icon, String tooltip) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          icon: Icon(icon),
          color: ThemeColors.goldPrimary,
          iconSize: 20,
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: ThemeColors.royalBlueMedium.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: ThemeColors.goldPrimary.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
}