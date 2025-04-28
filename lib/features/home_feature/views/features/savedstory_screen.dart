import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:graduation/features/auth/manager/user.dart';
import 'package:graduation/features/auth/presentation/login/login.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

// Simulated Story model
class Story {
  final String id;
  final String title;
  final String subtitle;

  Story({required this.id, required this.title, required this.subtitle});
}

class SavedStoriesScreen extends StatefulWidget {
  final bool isGuest;
  final User? user;

  const SavedStoriesScreen({super.key, this.isGuest = false, this.user});

  @override
  State<SavedStoriesScreen> createState() => _SavedStoriesScreenState();
}

class _SavedStoriesScreenState extends State<SavedStoriesScreen> {
  List<Story> _savedStories = [];
  int _guestStoryCount = 0;
  static const int _maxGuestStories = 3;

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    if (widget.isGuest) {
      final prefs = await SharedPreferences.getInstance();
      final savedStories = prefs.getStringList('guest_saved_stories') ?? [];
      setState(() {
        _savedStories = savedStories
            .map((story) => Story(
          id: story.split('|')[0],
          title: story.split('|')[1],
          subtitle: story.split('|')[2],
        ))
            .toList();
        _guestStoryCount = _savedStories.length;
      });
    } else {
      // Simulated fetching from backend (you can replace this with real API calls)
      setState(() {
        _savedStories = [
          Story(id: '1', title: 'قصة محفوظة 1', subtitle: 'وصف قصير للقصة الأولى...'),
          Story(id: '2', title: 'قصة محفوظة 2', subtitle: 'وصف قصير للقصة الثانية...'),
        ];
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
        _savedStories.add(story);
        _guestStoryCount++;
      });
    } else {
      setState(() {
        _savedStories.add(story);
      });
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

  Future<void> _deleteStory(Story story) async {
    if (widget.isGuest) {
      final prefs = await SharedPreferences.getInstance();
      final savedStories = prefs.getStringList('guest_saved_stories') ?? [];
      savedStories.removeWhere((s) => s.startsWith('${story.id}|'));
      await prefs.setStringList('guest_saved_stories', savedStories);
    }

    setState(() {
      _savedStories.remove(story);
      if (widget.isGuest) _guestStoryCount--;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تَمَّ حَذْفُ الْقِصَّةِ بِنَجَاحٍ!',
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
            'الْقِصَصُ الْمَحْفُوظَةُ',
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
          child: _savedStories.isEmpty
              ? Center(
            child: FadeInUp(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لَا تُوْجَدُ قِصَصٌ مَحْفُوظَةٌ بَعْدُ!',
                    style: TextStyle(
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                      color: Colors.amber[200],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.isGuest
                        ? 'سَجِّلْ دُخُولَكَ لِحِفْظِ قِصَصٍ غَيْرِ مَحْدُودَةٍ!'
                        : 'ابْدَأْ بِحِفْظِ قِصَصِكَ الْمُفَضَّلَةِ!',
                    style: TextStyle(
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                      color: Colors.blueGrey[100],
                      fontSize: 16,
                    ),
                  ),
                  if (widget.isGuest) ...[
                    const SizedBox(height: 20),
                    ElasticIn(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[200],
                          foregroundColor: Colors.blueGrey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'تَسْجِيلُ الدُّخُولِ',
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
                ],
              ),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _savedStories.length,
            itemBuilder: (context, index) {
              final story = _savedStories[index];
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
                    subtitle: Text(
                      story.subtitle,
                      style: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontFamilyFallback: const ['Noto Naskh Arabic'],
                        color: Colors.blueGrey[100],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.amber[200]),
                      onPressed: () => _deleteStory(story),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
