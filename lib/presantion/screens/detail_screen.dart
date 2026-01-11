import 'package:bibledictionary/presantion/providers/bible_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  final BibleWord word;

  const DetailScreen({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Consumer<BibleProvider>(
                builder: (context, provider, child) {
                  return IconButton(
                    icon: Icon(
                      word.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: word.isBookmarked ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      provider.toggleBookmark(word);
                    },
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue[50]!,
                      Colors.white,
                    ],
                  ),
                ),
              ),
              title: Text(
                word.word,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefinitionSection() {
    return Card(
      elevation: 0,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue[800],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Definition',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              word.definition,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      elevation: 0,
      color: Colors.purple[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.description,
                  color: Colors.purple[800],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              word.description!,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOriginalLanguagesSection() {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.language,
                  color: Colors.blue[800],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Original Languages',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (word.hebrew != null) 
              _buildLanguageItem('Hebrew', word.hebrew!),
            if (word.greek != null) 
              _buildLanguageItem('Greek', word.greek!),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem(String language, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersesSection() {
    return Card(
      elevation: 0,
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.book,
                  color: Colors.green[800],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Related Bible Verses',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: word.verses!.map((verse) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            verse,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap to view in Bible app',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}