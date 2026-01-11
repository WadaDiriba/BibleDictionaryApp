import 'package:bibledictionary/presantion/providers/bible_provider.dart';
import 'package:bibledictionary/presantion/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  final BibleWord word;

  const DetailScreen({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.parchment,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: ThemeColors.royalBlueDark,
            foregroundColor: ThemeColors.goldPrimary,
            elevation: 4,
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
                  Icons.arrow_back_rounded,
                  color: ThemeColors.goldPrimary,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.royalBlueMedium,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ThemeColors.goldPrimary,
                    width: 1.5,
                  ),
                ),
                child: Consumer<BibleProvider>(
                  builder: (context, provider, child) {
                    return IconButton(
                      icon: Icon(
                        word.isBookmarked 
                            ? Icons.bookmark_rounded 
                            : Icons.bookmark_outline_rounded,
                        color: ThemeColors.goldPrimary,
                      ),
                      onPressed: () {
                        provider.toggleBookmark(word);
                      },
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ThemeColors.royalBlueDark,
                      ThemeColors.royalBlueMedium,
                    ],
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        ThemeColors.royalBlueDark.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: ThemeColors.royalBlueMedium.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ThemeColors.goldPrimary,
                    width: 1,
                  ),
                ),
                child: Text(
                  word.word,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.goldPrimary,
                    fontSize: 18,
                    fontFamily: 'Times New Roman',
                    letterSpacing: 1,
                  ),
                ),
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWordHeader(),
                  const SizedBox(height: 24),
                  _buildDefinitionSection(),
                  const SizedBox(height: 24),
                  if (word.description != null && word.description!.isNotEmpty)
                    _buildDescriptionSection(),
                  const SizedBox(height: 24),
                  if (word.hebrew != null || word.greek != null)
                    _buildOriginalLanguagesSection(),
                  const SizedBox(height: 24),
                  if (word.verses != null && word.verses!.isNotEmpty)
                    _buildVersesSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.royalBlueDark.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: ThemeColors.goldPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeColors.royalBlueDark,
                  ThemeColors.royalBlueMedium,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.royalBlueDark.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                word.word[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.goldPrimary,
                  fontFamily: 'Times New Roman',
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.word,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.royalBlueDark,
                    fontFamily: 'Times New Roman',
                    letterSpacing: 0.5,
                  ),
                ),
                // Removed the language property since it doesn't exist in BibleWord
                // You can add this back if you add a language property to your model
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefinitionSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: ThemeColors.goldPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ThemeColors.royalBlueDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: ThemeColors.goldPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'DEFINITION',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ThemeColors.royalBlueDark,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeColors.ivoryWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ThemeColors.royalBlueDark.withOpacity(0.1),
                ),
              ),
              child: Text(
                word.definition,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: ThemeColors.charcoal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: ThemeColors.goldPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ThemeColors.royalBlueDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.description_rounded,
                    color: ThemeColors.goldPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'DETAILED EXPLANATION',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ThemeColors.royalBlueDark,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeColors.ivoryWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ThemeColors.royalBlueDark.withOpacity(0.1),
                ),
              ),
              child: Text(
                word.description!,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: ThemeColors.charcoal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOriginalLanguagesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: ThemeColors.goldPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ThemeColors.royalBlueDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.language_rounded,
                    color: ThemeColors.goldPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'ORIGINAL LANGUAGES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ThemeColors.royalBlueDark,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (word.hebrew != null) 
              _buildLanguageItem('HEBREW ORIGIN', word.hebrew!),
            if (word.greek != null) 
              _buildLanguageItem('GREEK ORIGIN', word.greek!),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(String language, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ThemeColors.royalBlueDark.withOpacity(0.7),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ThemeColors.goldPrimary.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.royalBlueDark.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Times New Roman',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: ThemeColors.goldPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ThemeColors.royalBlueDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.book_rounded,
                    color: ThemeColors.goldPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'RELATED BIBLE VERSES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ThemeColors.royalBlueDark,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: word.verses!.map((verse) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    // Handle verse tap
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ThemeColors.royalBlueDark.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeColors.royalBlueDark.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: ThemeColors.goldPrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                verse,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: ThemeColors.charcoal,
                                ),
                              ),
                              // const SizedBox(height: 8),
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Icons.open_in_new_rounded,
                              //       size: 14,
                              //       color: ThemeColors.royalBlueDark,
                              //     ),
                              //     const SizedBox(width: 4),
                              //     Text(
                              //       'Tap to view full context',
                              //       style: TextStyle(
                              //         fontSize: 12,
                              //         color: ThemeColors.royalBlueDark,
                              //         fontStyle: FontStyle.italic,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}