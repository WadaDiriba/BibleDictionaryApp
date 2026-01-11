import 'package:bibledictionary/presantion/theme/theme_colors.dart';

import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      backgroundColor: ThemeColors.royalBlueDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 🔥 Header with Royal Insignia
          Container(
            decoration: BoxDecoration(
              gradient: ThemeColors.royalGradient,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
              boxShadow: ThemeColors.cardShadow,
            ),
            padding: const EdgeInsets.only(
              top: 60,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Logo/Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ThemeColors.royalBlueDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ThemeColors.goldPrimary,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 40,
                    color: ThemeColors.goldPrimary,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // App Title
                Text(
                  "ELROI LEXICON",
                  style: TextStyle(
                    color: ThemeColors.goldPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  "A Treasury of Biblical Wisdom",
                  style: TextStyle(
                    color: ThemeColors.goldLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.5,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // User info or verse of the day
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ThemeColors.royalBlueMedium.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ThemeColors.goldPrimary.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    '"Thy word is a lamp unto my feet, and a light unto my path."',
                    style: TextStyle(
                      color: ThemeColors.ivoryWhite,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // 📜 Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildDrawerSection("EXPLORE", [
                  _buildDrawerTile(Icons.home_filled, "Home", 0),
                  _buildDrawerTile(Icons.search_rounded, "Search Dictionary", 1),
                  _buildDrawerTile(Icons.auto_stories, "Browse by Book", 2),
                  _buildDrawerTile(Icons.history, "Recent Words", 3),
                ]),
                
                const SizedBox(height: 8),
                
                _buildDrawerSection("STUDY", [
                  _buildDrawerTile(Icons.bookmark, "Saved Words", 4),
                  _buildDrawerTile(Icons.favorite, "Favorites", 5),
                  _buildDrawerTile(Icons.note, "Study Notes", 6),
                  _buildDrawerTile(Icons.lightbulb, "Word of the Day", 7),
                ]),
                
                const SizedBox(height: 8),
                
                _buildDrawerSection("SETTINGS", [
                  _buildDrawerTile(Icons.translate, "Languages", 8),
                  _buildDrawerTile(Icons.text_fields, "Font Settings", 9),
                  _buildDrawerTile(Icons.nightlight, "Theme", 10),
                  _buildDrawerTile(Icons.volume_up, "Pronunciation", 11),
                ]),
                
                const SizedBox(height: 20),
                
                // About section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(
                    color: ThemeColors.goldPrimary.withOpacity(0.3),
                    thickness: 0.5,
                  ),
                ),
                
                _buildDrawerTile(Icons.info, "About Lexicon", 12),
                _buildDrawerTile(Icons.share, "Share App", 13),
                _buildDrawerTile(Icons.star, "Rate App", 14),
                _buildDrawerTile(Icons.help, "Help & Support", 15),
              ],
            ),
          ),

          // 👤 Footer with version
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: ThemeColors.goldPrimary.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Version 1.0.0",
                  style: TextStyle(
                    color: ThemeColors.goldLight.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.logout,
                    color: ThemeColors.goldPrimary,
                    size: 16,
                  ),
                  label: Text(
                    "Exit",
                    style: TextStyle(
                      color: ThemeColors.goldPrimary,
                      fontSize: 13,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: ThemeColors.goldPrimary.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              color: ThemeColors.goldPrimary.withOpacity(0.6),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, int index) {
    final isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? ThemeColors.goldPrimary.withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(
                color: ThemeColors.goldPrimary.withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? ThemeColors.goldPrimary
              : ThemeColors.ivoryWhite.withOpacity(0.8),
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? ThemeColors.goldPrimary
                : ThemeColors.ivoryWhite,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.chevron_right,
                color: ThemeColors.goldPrimary,
                size: 18,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        minLeadingWidth: 24,
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}