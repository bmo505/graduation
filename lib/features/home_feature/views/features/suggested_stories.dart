import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:graduation/features/auth/manager/user.dart';
import 'package:graduation/features/auth/presentation/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';

class SuggestedStoriesScreen extends StatefulWidget {
  final bool isGuest;
  final User? user;

  const SuggestedStoriesScreen({super.key, this.isGuest = false, this.user});

  @override
  State<SuggestedStoriesScreen> createState() => _SuggestedStoriesScreenState();
}

class Story {
  final String id;
  final String title;
  final String subtitle;
  final String thumbnailUrl;
  final String category; // Added for filtering
  final DateTime suggestedDate; // Added for display

  Story({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.thumbnailUrl,
    required this.category,
    required this.suggestedDate,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? 'https://via.placeholder.com/150',
      category: json['category'] ?? 'عام',
      suggestedDate: DateTime.parse(json['suggestedDate'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class _SuggestedStoriesScreenState extends State<SuggestedStoriesScreen> {
  List<Story> _suggestedStories = [];
  int _guestStoryCount = 0;
  static const int _maxGuestStories = 3;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadGuestStoryCount();
    _loadSuggestedStories();
  }

  Future<void> _loadGuestStoryCount() async {
    if (widget.isGuest) {
      final prefs = await SharedPreferences.getInstance();
      final savedStories = prefs.getStringList('guest_saved_stories') ?? [];
      setState(() {
        _guestStoryCount = savedStories.length;
      });
      if (_guestStoryCount > 0) {
        _showGuestStoriesNotification();
      }
    }
  }

  Future<void> _loadSuggestedStories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (widget.isGuest) {
        // Simulated data for guests
        setState(() {
          _suggestedStories = List.generate(
            5,
                (index) => Story(
              id: '${index + 1}',
              title: 'قِصَّةُ مُقْتَرَحَةُ ${index + 1}',
              subtitle: 'وَصْفٌ قَصِيرٌ لِلْقِصَّةِ الْمُقْتَرَحَةِ...',
              thumbnailUrl: 'https://via.placeholder.com/150',
              category: index % 2 == 0 ? 'مُغَامَرَةٌ' : 'رُوْمَانْسِيَّةٌ',
              suggestedDate: DateTime.now(),
            ),
          );
        });
      } else {
        // Fetch from .NET backend
        final response = await http.get(
          Uri.parse('https://your-api.com/api/stories/suggested'),
          headers: {
            if (widget.user?.token != null) 'Authorization': 'Bearer ${widget.user!.token}',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _suggestedStories = (data['stories'] as List)
                .map((story) => Story.fromJson(story))
                .toList();
          });
        } else if (response.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'جَلْسَتُكَ انْتَهَتْ! الرَّجَاءُ تَسْجِيلُ الدُّخُولِ مَرَّةً أُخْرَى.',
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.red[800],
              action: SnackBarAction(
                label: 'تَسْجِيلُ الدُّخُولِ',
                textColor: Colors.amber[200],
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ),
          );
          return;
        } else {
          throw Exception('فَشَلَ جَلْبُ الْقِصَصِ الْمُقْتَرَحَةِ');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'حَدَثَ خَطَأٌ أَثْنَاءَ جَلْبِ الْقِصَصِ. الرَّجَاءُ الْمُحَاوَلَةُ لَاحِقًا.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveStory(Story story) async {
    if (widget.isGuest) {
      if (_guestStoryCount >= _maxGuestStories) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'لَقَدْ وَصَلْتَ إِلَى الْحَدِّ الْأَقْصَى لِلْقِصَصِ الْمَحْفُوظَةِ ($_maxGuestStories)!',
              style: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                fontFamilyFallback: const ['Noto Naskh Arabic'],
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red[800],
            action: SnackBarAction(
              label: 'تَسْجِيلُ الدُّخُولِ',
              textColor: Colors.amber[200],
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final savedStories = prefs.getStringList('guest_saved_stories') ?? [];
      savedStories.add('${story.id}|${story.title}|${story.subtitle}');
      await prefs.setStringList('guest_saved_stories', savedStories);
      setState(() {
        _guestStoryCount++;
      });
    } else {
      try {
        final response = await http.post(
          Uri.parse('https://your-api.com/api/stories/save'),
          headers: {
            'Authorization': 'Bearer ${widget.user!.token}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'storyId': story.id}),
        );

        if (response.statusCode != 200) {
          throw Exception('فَشَلَ حِفْظُ الْقِصَّةِ');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'حَدَثَ خَطَأٌ أَثْنَاءَ حِفْظِ الْقِصَّةِ!',
              style: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                fontFamilyFallback: const ['Noto Naskh Arabic'],
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red[800],
          ),
        );
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تَمَّ حِفْظُ الْقِصَّةِ بِنَجَاحٍ!',
          style: TextStyle(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            fontFamilyFallback: const ['Noto Naskh Arabic'],
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
    );
  }

  void _showGuestStoriesNotification() {
    final remainingStories = _maxGuestStories - _guestStoryCount;
    if (remainingStories < _maxGuestStories) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'مَتَبَقِّي لَكَ $remainingStories قِصَصٍ لِلْحِفْظِ كَضَيْفٍ!',
            style: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontFamilyFallback: const ['Noto Naskh Arabic'],
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blueGrey[900],
          action: SnackBarAction(
            label: 'تَسْجِيلُ الدُّخُولِ',
            textColor: Colors.amber[200],
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900]!.withOpacity(0.5),
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.blueGrey[200]!.withOpacity(0.3), width: 1),
                ),
              ),
            ),
          ),
        ),
        title: ZoomIn(
          child: Text(
            'الْقِصَصُ الْمُقْتَرَحَةُ',
            style: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontFamilyFallback: const ['Noto Naskh Arabic'],
              color: Colors.amber[200],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueGrey[900]!, Colors.blue[200]!],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<void>(
            future: Future.value(), // Already handled in initState
            builder: (context, snapshot) {
              if (_isLoading) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.amber[200]),
                );
              }
              if (_errorMessage != null) {
                return Center(
                  child: FadeInUp(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _errorMessage!,
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            color: Colors.amber[200],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElasticIn(
                          child: ElevatedButton(
                            onPressed: _loadSuggestedStories,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber[200],
                              foregroundColor: Colors.blueGrey[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              'إِعَادَةُ الْمُحَاوَلَةِ',
                              style: TextStyle(
                                fontFamily: GoogleFonts.tajawal().fontFamily,
                                fontFamilyFallback: const ['Noto Naskh Arabic'],
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (_suggestedStories.isEmpty) {
                return Center(
                  child: FadeInUp(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لَا تُوْجَدُ قِصَصٌ مُقْتَرَحَةٌ بَعْدُ!',
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            color: Colors.amber[200],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElasticIn(
                          child: ElevatedButton(
                            onPressed: _loadSuggestedStories,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber[200],
                              foregroundColor: Colors.blueGrey[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              'إِعَادَةُ التَّحْمِيلِ',
                              style: TextStyle(
                                fontFamily: GoogleFonts.tajawal().fontFamily,
                                fontFamilyFallback: const ['Noto Naskh Arabic'],
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _suggestedStories.length,
                itemBuilder: (context, index) {
                  final story = _suggestedStories[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 200 * index),
                    child: Card(
                      color: Colors.blueGrey[900]!.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            story.thumbnailUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.image,
                              color: Colors.amber[200],
                              size: 50,
                            ),
                          ),
                        ),
                        title: Text(
                          story.title,
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            fontSize: 20,
                            color: Colors.amber[200],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story.subtitle,
                              style: TextStyle(
                                fontFamily: GoogleFonts.tajawal().fontFamily,
                                fontFamilyFallback: const ['Noto Naskh Arabic'],
                                color: Colors.blueGrey[100],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'الصِّنْفُ: ${story.category} | مُقْتَرَحَةٌ فِي: ${story.suggestedDate.toString().substring(0, 10)}',
                              style: TextStyle(
                                fontFamily: GoogleFonts.tajawal().fontFamily,
                                fontFamilyFallback: const ['Noto Naskh Arabic'],
                                color: Colors.blueGrey[300],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.bookmark_add, color: Colors.amber[200]),
                          onPressed: () => _saveStory(story),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}