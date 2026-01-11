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
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.menu_book_rounded,
            color: ThemeColors.goldPrimary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ELROI LEXICON",
                style: TextStyle(
                  color: ThemeColors.goldPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  fontFamily: 'Times New Roman',
                ),
              ),
              Text(
                "Biblical Dictionary & Concordance",
                style: TextStyle(
                  color: ThemeColors.goldLight,
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),

      // Royal insignia icon
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ThemeColors.royalBlueMedium,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ThemeColors.goldPrimary,
            width: 1.5,
          ),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.library_books_rounded,
            color: ThemeColors.goldPrimary,
            size: 22,
          ),
          onPressed: () {},
        ),
      ),

      // Action icons
      actions: [
        _buildAppBarIcon(Icons.search, "Search"),
        _buildAppBarIcon(Icons.translate, "Languages"),
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
          iconSize: 22,
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