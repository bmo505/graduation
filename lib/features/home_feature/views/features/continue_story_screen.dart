import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:graduation/features/home_feature/views/features/chat_view.dart';

// Simulated Story model
class Story {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final DateTime lastUpdated;

  Story({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.lastUpdated,
  });
}

class ContinueStoryScreen extends StatefulWidget {
  const ContinueStoryScreen({super.key});

  @override
  _ContinueStoryScreenState createState() => _ContinueStoryScreenState();
}

class _ContinueStoryScreenState extends State<ContinueStoryScreen> {
  // Simulated list of stories
  final List<Story> _stories = [
    Story(
      id: const Uuid().v4(),
      title: 'مغامرة في الغابة السحرية',
      excerpt: 'في غابة بعيدة، وجدت ليلى كتابًا سحريًا ينقلها إلى عوالم مجهولة...',
      content: 'كانت ليلى تسير في الغابة عندما لمحت ضوءًا خافتًا ينبعث من بين الأشجار. اقتربت بحذر فوجدت كتابًا قديمًا مغطى بالغبار. عندما فتحته، شعرت بدوامة قوية تسحبها إلى عالم آخر...',
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Story(
      id: const Uuid().v4(),
      title: 'سر القصر المهجور',
      excerpt: 'يقرر أحمد استكشاف القصر المهجور في قريته، لكنه يكتشف أسرارًا مخيفة...',
      content: 'كان القصر يقف شامخًا على تلة القرية، مهجورًا منذ عقود. سمع أحمد قصصًا عن أشباح تسكنه، لكنه لم يصدقها. في ليلة بلا قمر، تسلل إلى القصر وفتح الباب الثقيل...',
      lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Story(
      id: const Uuid().v4(),
      title: 'رحلة إلى المستقبل',
      excerpt: 'اخترع سامي آلة زمنية تنقله إلى عام 2100، لكنه واجه تحديات غير متوقعة...',
      content: 'بعد سنوات من العمل الشاق، أكمل سامي آلة الزمن الخاصة به. قرر تجربتها لأول مرة، واختار السفر إلى عام 2100. عندما وصل، وجد مدينة مليئة بالروبوتات، لكن شيئًا غريبًا كان يحدث...',
      lastUpdated: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Placeholder for fetching stories from API
    // Future<void> fetchStories() async {
    //   final response = await http.get(Uri.parse('https://api.x.ai/stories'));
    //   if (response.statusCode == 200) {
    //     final stories = jsonDecode(response.body) as List;
    //     setState(() {
    //       _stories = stories.map((e) => Story.fromJson(e)).toList();
    //     });
    //   }
    // }
    // fetchStories();
  }

  void _continueStory(Story story) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ChatPage(
          initialMessage: 'اسْتَكْمِلْ هَذِهِ الْقِصَّةَ: "${story.title}"\n${story.content}',
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.book, color: Colors.amber[200], size: 24),
              const SizedBox(width: 8),
              Text(
                'اسْتِكْمَالُ الْقِصَصِ',
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[200],
                ),
              ),
            ],
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
          child: _stories.isEmpty
              ? Center(
            child: FadeInUp(
              child: Text(
                'لا تُوجَدُ قِصَصٌ لِلاسْتِكْمَالِ حَالِيًّا!',
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  fontSize: 20,
                  color: Colors.amber[200],
                ),
              ),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _stories.length,
            itemBuilder: (context, index) {
              final story = _stories[index];
              return ZoomIn(
                delay: Duration(milliseconds: 100 * index),
                child: Card(
                  color: Colors.blueGrey[800]!.withOpacity(0.8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          story.excerpt,
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'آخِرُ تَحْدِيثٍ: ${DateFormat.yMMMd('ar').format(story.lastUpdated)}',
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            color: Colors.blueGrey[300],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.amber[200],
                      size: 20,
                    ),
                    onTap: () => _continueStory(story),
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