import 'package:bibledictionary/presantion/providers/bible_provider.dart';
import 'package:bibledictionary/presantion/screens/detail_screen.dart';
import 'package:bibledictionary/presantion/widgets/appbar.dart';
import 'package:bibledictionary/presantion/widgets/drawer.dart';
import 'package:bibledictionary/presantion/widgets/searchbar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(), 
      backgroundColor: const Color(0xFFF8F5F0), // Light parchment background
      body: SafeArea(
        child: Column(
          children: [
           const CustomSearchBar(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildContent() {
    return Consumer<BibleProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && !_isRefreshing) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFFFFD700)), // Gold
            ),
          );
        }

        if (provider.words.isEmpty && provider.searchQuery.isNotEmpty) {
          return _buildEmptySearchState();
        }

        if (provider.words.isEmpty && !provider.isLoading) {
          return _buildEmptyDictionaryState();
        }

        return RefreshIndicator(
          color: const Color(0xFFFFD700), // Gold
          backgroundColor: const Color(0xFF0A1D37), // Royal blue
          onRefresh: () async {
            setState(() {
              _isRefreshing = true;
            });
            try {
              await provider.refreshWords();
            } finally {
              setState(() {
                _isRefreshing = false;
              });
            }
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: provider.words.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final word = provider.words[index];
              return _buildWordCard(context, word);
            },
          ),
        );
      },
    );
  }

  Widget _buildWordCard(BuildContext context, BibleWord word) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: const Color(0xFFFFD700).withOpacity(0.2), // Gold border
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0A1D37), // Royal blue
                const Color(0xFF102B4E), // Lighter royal blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0A1D37).withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              word.word[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700), // Gold
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
        title: Text(
          word.word,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: Color(0xFF0A1D37), // Royal blue text
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            word.definition.length > 80
                ? '${word.definition.substring(0, 80)}...'
                : word.definition,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                word.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                color: word.isBookmarked 
                    ? const Color(0xFFFFD700) // Gold
                    : Colors.grey[500],
                size: 22,
              ),
              onPressed: () {
                Provider.of<BibleProvider>(context, listen: false)
                    .toggleBookmark(word);
              },
              splashRadius: 20,
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFF0A1D37).withOpacity(0.5), // Royal blue
              size: 20,
            ),
          ],
        ),
        onTap: () => _navigateToDetail(context, word),
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF0A1D37).withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 60,
                color: const Color(0xFF0A1D37).withOpacity(0.5), // Royal blue
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0A1D37), // Royal blue
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Try searching with different keywords or check the spelling.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: const Color(0xFF0A1D37).withOpacity(0.7), // Royal blue
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                Provider.of<BibleProvider>(context, listen: false).clearSearch();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A1D37), // Royal blue
                foregroundColor: const Color(0xFFFFD700), // Gold
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text('Clear Search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyDictionaryState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF0A1D37).withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.book_outlined,
                size: 60,
                color: const Color(0xFF0A1D37).withOpacity(0.5), // Royal blue
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No words loaded',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0A1D37), // Royal blue
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Unable to load the Bible dictionary. Please check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: const Color(0xFF0A1D37).withOpacity(0.7), // Royal blue
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Provider.of<BibleProvider>(context, listen: false).refreshWords();
              },
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A1D37), // Royal blue
                foregroundColor: const Color(0xFFFFD700), // Gold
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Consumer<BibleProvider>(
      builder: (context, provider, child) {
        if (provider.bookmarkedWords.isEmpty) return const SizedBox.shrink();
        
        return FloatingActionButton(
          onPressed: () => _showBookmarks(context),
          backgroundColor: const Color(0xFF0A1D37), // Royal blue
          foregroundColor: const Color(0xFFFFD700), // Gold
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Stack(
            children: [
              const Icon(Icons.bookmark, size: 24),
              if (provider.bookmarkedWords.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700), // Gold badge
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      provider.bookmarkedWords.length > 9 
                          ? '9+' 
                          : provider.bookmarkedWords.length.toString(),
                      style: const TextStyle(
                        color: Color(0xFF0A1D37), // Royal blue text
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showBookmarks(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0A1D37).withOpacity(0.2), // Royal blue shadow
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Consumer<BibleProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bookmarks',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0A1D37), // Royal blue
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${provider.bookmarkedWords.length} saved ${provider.bookmarkedWords.length == 1 ? 'word' : 'words'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF0A1D37).withOpacity(0.7), // Royal blue
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A1D37).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: const Color(0xFF0A1D37), // Royal blue
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (provider.bookmarkedWords.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A1D37).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Icon(
                              Icons.bookmark_border_rounded,
                              size: 50,
                              color: const Color(0xFF0A1D37).withOpacity(0.5), // Royal blue
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No bookmarks yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color(0xFF0A1D37), // Royal blue
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Tap the bookmark icon on any word to save it here',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF0A1D37).withOpacity(0.7), // Royal blue
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        itemCount: provider.bookmarkedWords.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final word = provider.bookmarkedWords[index];
                          return Card(
                            margin: EdgeInsets.zero,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: const Color(0xFFFFD700).withOpacity(0.2), // Gold border
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD700), // Gold
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.bookmark,
                                  color: Color(0xFF0A1D37), // Royal blue
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                word.word,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0A1D37), // Royal blue
                                ),
                              ),
                              subtitle: Text(
                                word.definition.length > 60
                                    ? '${word.definition.substring(0, 60)}...'
                                    : word.definition,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFF0A1D37).withOpacity(0.7), // Royal blue
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: const Color(0xFF0A1D37).withOpacity(0.5), // Royal blue
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                _navigateToDetail(context, word);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToDetail(BuildContext context, BibleWord word) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => DetailScreen(word: word),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

}