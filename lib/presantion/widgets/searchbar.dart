import 'package:bibledictionary/presantion/theme/theme_colors.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bible_provider.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.royalBlueMedium,
        boxShadow: ThemeColors.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Consumer<BibleProvider>(
        builder: (context, provider, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.royalBlueDark.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: TextStyle(
                color: ThemeColors.charcoal,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: "Search  English words...",
                hintStyle: TextStyle(
                  color: ThemeColors.slateGray.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
                fillColor: ThemeColors.ivoryWhite,
                filled: true,
                
                // Prefix Icon (Magnifying Glass)
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: ThemeColors.goldGradient,
                    shape: BoxShape.circle,
                    boxShadow: ThemeColors.subtleShadow,
                  ),
                  child: const Icon(
                    Icons.search_rounded,
                    color: ThemeColors.royalBlueDark,
                    size: 20,
                  ),
                ),
                
                // Suffix Icons
                suffixIcon: _controller.text.isNotEmpty
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.filter_list_rounded),
                            color: ThemeColors.royalBlueMedium,
                            onPressed: () {
                              _showFilterOptions(context, provider);
                            },
                            tooltip: "Filter Options",
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            color: ThemeColors.slateGray,
                            onPressed: () {
                              _controller.clear();
                              provider.clearSearch();
                              _focusNode.unfocus();
                              setState(() {});
                            },
                            tooltip: "Clear Search",
                          ),
                        ],
                      )
                    : IconButton(
                        icon: const Icon(Icons.mic_none_rounded),
                        color: ThemeColors.royalBlueMedium.withOpacity(0.6),
                        onPressed: () {},
                        tooltip: "Voice Search",
                      ),
                
                // Border Styling
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: ThemeColors.goldPrimary.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: ThemeColors.goldPrimary,
                    width: 2,
                  ),
                ),
                
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
              
              onChanged: (value) {
                provider.search(value);
                setState(() {});
              },
              
              onSubmitted: (value) {
                _focusNode.unfocus();
              },
            ),
          );
        },
      ),
    );
  }

  void _showFilterOptions(BuildContext context, BibleProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: ThemeColors.ivoryWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Search Filters",
                    style: TextStyle(
                      color: ThemeColors.royalBlueDark,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: ThemeColors.slateGray,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              _buildFilterOption(
                "Show Only Bookmarked Words",
                Icons.bookmark,
                false,
                (value) {},
              ),
              
              _buildFilterOption(
                "Include Hebrew Words",
                Icons.language,
                true,
                (value) {},
              ),
              
              _buildFilterOption(
                "Include Greek Words",
                Icons.language,
                true,
                (value) {},
              ),
              
              _buildFilterOption(
                "Show Definitions Only",
                Icons.description,
                false,
                (value) {},
              ),
              
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.royalBlueDark,
                    foregroundColor: ThemeColors.goldPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Text("Apply Filters"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title, IconData icon, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: ThemeColors.royalBlueMedium,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: ThemeColors.charcoal,
                fontSize: 14,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: ThemeColors.goldPrimary,
            activeTrackColor: ThemeColors.goldPrimary.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}