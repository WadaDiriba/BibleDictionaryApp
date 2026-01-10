import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BibleProvider extends ChangeNotifier {
  List<BibleWord> _words = [];
  List<BibleWord> _filteredWords = [];
  List<BibleWord> _bookmarkedWords = [];
  String _searchQuery = '';
  bool _isLoading = true;

  List<BibleWord> get words => _filteredWords;
  List<BibleWord> get bookmarkedWords => _bookmarkedWords;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  BibleProvider() {
    loadWords();
  }

  Future<void> loadWords() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final String response = await rootBundle.loadString('db/assets/bibledictionary.json');
      final Map<String, dynamic> data = json.decode(response);
      
      // Convert map to list - your JSON has nested objects
      _words = data.entries.map((entry) {
        final wordData = entry.value as Map<String, dynamic>;
        return BibleWord.fromJson(wordData);
      }).toList();
      
      // Sort alphabetically by word
      _words.sort((a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase()));
      
      _filteredWords = List.from(_words);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error loading words: $e');
      rethrow;
    }
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    
    if (query.isEmpty) {
      _filteredWords = List.from(_words);
    } else {
      _filteredWords = _words.where((word) {
        return word.word.toLowerCase().contains(_searchQuery) ||
               word.definition.toLowerCase().contains(_searchQuery) ||
               (word.hebrew != null && word.hebrew!.toLowerCase().contains(_searchQuery)) ||
               (word.greek != null && word.greek!.toLowerCase().contains(_searchQuery)) ||
               (word.description != null && word.description!.toLowerCase().contains(_searchQuery));
      }).toList();
    }
    notifyListeners();
  }

  void toggleBookmark(BibleWord word) {
    final index = _words.indexWhere((w) => w.word == word.word);
    if (index != -1) {
      _words[index] = _words[index].copyWith(isBookmarked: !_words[index].isBookmarked);
      
      if (_words[index].isBookmarked) {
        _bookmarkedWords.add(_words[index]);
      } else {
        _bookmarkedWords.removeWhere((w) => w.word == word.word);
      }
      
      // Update filtered list if needed
      final filteredIndex = _filteredWords.indexWhere((w) => w.word == word.word);
      if (filteredIndex != -1) {
        _filteredWords[filteredIndex] = _words[index];
      }
      
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredWords = List.from(_words);
    notifyListeners();
  }

  Future<void> refreshWords() async {
    await loadWords();
  }
}

class BibleWord {
  final String word;
  final String definition;
  final String? hebrew;
  final String? greek;
  final String? description;
  final List<String>? verses;
  bool isBookmarked;

  BibleWord({
    required this.word,
    required this.definition,
    this.hebrew,
    this.greek,
    this.description,
    this.verses,
    this.isBookmarked = false,
  });

  factory BibleWord.fromJson(Map<String, dynamic> json) {
    return BibleWord(
      word: json['word']?.toString() ?? '',
      definition: json['definition']?.toString() ?? '',
      hebrew: json['hebrew']?.toString(),
      greek: json['greek']?.toString(),
      description: json['description']?.toString(),
      verses: json['verses'] != null 
          ? List<String>.from(json['verses'].map((v) => v.toString()))
          : null,
    );
  }

  BibleWord copyWith({
    String? word,
    String? definition,
    String? hebrew,
    String? greek,
    String? description,
    List<String>? verses,
    bool? isBookmarked,
  }) {
    return BibleWord(
      word: word ?? this.word,
      definition: definition ?? this.definition,
      hebrew: hebrew ?? this.hebrew,
      greek: greek ?? this.greek,
      description: description ?? this.description,
      verses: verses ?? this.verses,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}