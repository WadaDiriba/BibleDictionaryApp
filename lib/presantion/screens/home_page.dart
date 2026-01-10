import 'package:bibledictionary/presantion/providers/bible_provider.dart';
import 'package:bibledictionary/presantion/screens/detail_screen.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            _buildSearchBar(context),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bible Dictionary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 4),
              Consumer<BibleProvider>(
                builder: (context, provider, child) {
                  return Text(
                    '${provider.words.length} ${provider.words.length == 1 ? 'word' : 'words'} available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ],
          ),
          IconButton(
            onPressed: () => _showBookmarks(context),
            icon: const Icon(Icons.bookmark, size: 28),
            tooltip: 'Bookmarks',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Consumer<BibleProvider>(
        builder: (context, provider, child) {
          return TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: 'Search words, definitions, Hebrew, Greek...',
              prefixIcon: Icon(Icons.search, color: Colors.blue[700]),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[600]),
                      onPressed: () {
                        _searchController.clear();
                        provider.clearSearch();
                        _searchFocusNode.unfocus();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 0,
              ),
            ),
            onChanged: provider.search,
            onTap: () {
              if (_searchController.text.isNotEmpty) {
                _searchFocusNode.requestFocus();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<BibleProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && !_isRefreshing) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (provider.words.isEmpty && provider.searchQuery.isNotEmpty) {
          return _buildEmptySearchState();
        }

        if (provider.words.isEmpty && !provider.isLoading) {
          return _buildEmptyDictionaryState();
        }

        return RefreshIndicator(
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
            color: _getWordColor(word.word),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              word.word[0].toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
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
            color: Colors.black87,
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
                color: word.isBookmarked ? Colors.amber[700] : Colors.grey[500],
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
              color: Colors.grey[400],
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
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
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
                  color: Colors.grey[600],
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
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
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
            Icon(
              Icons.book_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'No words loaded',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
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
                  color: Colors.grey[600],
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
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
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
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
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
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
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
                        color: Colors.white,
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
                color: Colors.black.withOpacity(0.2),
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
                                color: Colors.blue[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${provider.bookmarkedWords.length} saved ${provider.bookmarkedWords.length == 1 ? 'word' : 'words'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
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
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.close, size: 20),
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
                          Icon(
                            Icons.bookmark_border_rounded,
                            size: 70,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No bookmarks yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
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
                                color: Colors.grey[500],
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
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              leading: Icon(
                                Icons.bookmark,
                                color: Colors.amber[700],
                              ),
                              title: Text(
                                word.word,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                word.definition.length > 60
                                    ? '${word.definition.substring(0, 60)}...'
                                    : word.definition,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Colors.grey[400],
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

  Color _getWordColor(String word) {
    // Generate a consistent color based on the first letter
    final colors = [
      Colors.blue[700]!,
      Colors.green[700]!,
      Colors.purple[700]!,
      Colors.orange[700]!,
      Colors.red[700]!,
      Colors.teal[700]!,
      Colors.indigo[700]!,
      Colors.pink[700]!,
      Colors.deepOrange[700]!,
      Colors.cyan[700]!,
    ];
    
    final charCode = word.toLowerCase().codeUnitAt(0);
    return colors[charCode % colors.length];
  }
}