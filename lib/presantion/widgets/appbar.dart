import 'package:bibledictionary/presantion/screens/about_page.dart';
import 'package:bibledictionary/presantion/screens/setting_page.dart';
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

     actions: [

PopupMenuButton<String>(

  itemBuilder: (context) => [

    PopupMenuItem(
      value: 'settings',
      child: Row(
        children: const [
          Icon(Icons.settings),
          SizedBox(width: 10),
          Text("Settings"),
        ],
      ),
    ),

    PopupMenuItem(
      value: 'about',
      child: Row(
        children: const [
          Icon(Icons.info),
          SizedBox(width: 10),
          Text("About Us"),
        ],
      ),
    ),

    PopupMenuItem(
      value: 'clear', 
      child: Row(
        children: const [
          Icon(Icons.delete),
          SizedBox(width: 10),
          Text("Clear"),
        ],
      ),
    ),

  ],

  onSelected: (value) {

    if(value == 'settings'){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> const SettingsPage()),
      );
    }

    else if(value == 'about'){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> const AboutPage()),
      );
    }

    else if (value == 'clear') {

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Confirm"),
            content: const Text("Are you sure you want to clear data?"),

            actions: [

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),

              ElevatedButton(
                onPressed: () {
                  // clear logic here
                  Navigator.pop(context);
                },
                child: const Text("Yes"),
              ),
            ],
          );
        },
      );
    }

   
  },
),
],

    );
  }


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
}