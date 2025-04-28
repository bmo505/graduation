import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:graduation/features/home_feature/views/settings/account_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../../auth/manager/user.dart';

// Simulated user model
final User _currentUser = User(
  name: 'كاتب القصص',
  email: 'example@email.com',
  birthDate: '2000-01-01',
  userType: 'كَاتِبٌ', id: '',
);


// Simulated post model
class StoryPost {
  final String id;
  final User author;
  final String title;
  final String content;
  final DateTime createdAt;
  int likes;
  int loves;
  List<Comment> comments;

  StoryPost({
    required this.id,
    required this.author,
    required this.title,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.loves = 0,
    this.comments = const [],
  });
}


// Simulated comment model
class Comment {
  final String id;
  final User author;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
  });
}

class StoryCommunityScreen extends StatefulWidget {
  const StoryCommunityScreen({super.key});

  @override
  _StoryCommunityScreenState createState() => _StoryCommunityScreenState();
}

class _StoryCommunityScreenState extends State<StoryCommunityScreen> {
  final List<StoryPost> _posts = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  // Simulated current user
  final User _currentUser =  User( name: 'كاتب القصص', email: '', birthDate: '', userType: '', id: '');

  @override
  void initState() {
    super.initState();
    // Simulated initial posts
    _posts.addAll([
      StoryPost(
        id: const Uuid().v4(),
        author:  User( name: 'راوي الحكايات', email: '', birthDate: '', userType: '', id: ''),
        title: 'مغامرة في الغابة السحرية',
        content: 'في غابة بعيدة، وجدت ليلى كتابًا سحريًا ينقلها إلى عوالم مجهولة...',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likes: 15,
        loves: 8,
        comments: [
          Comment(
            id: const Uuid().v4(),
            author:  User( name: 'محب القصص', email: '', birthDate: '', userType: '', id: ''),
            content: 'قصة رائعة! أحببت فكرة الكتاب السحري.',
            createdAt: DateTime.now().subtract(const Duration(hours: 12)),
          ),
        ],
      ),
    ]);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _createPost() {
    if (_currentUser.userType == 'قَارِئٌ') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'يَجِبُ أَنْ تَكُونَ كَاتِبًا لِنَشْرِ الْقِصَصِ!',
            style: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontFamilyFallback: const ['Noto Naskh Arabic'],
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blueGrey[900],
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'تَغْيِيرُ نَوْعِ الْمُسْتَخْدِمِ',
            textColor: Colors.amber[200],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAccountScreen(user: _currentUser)),
              );
            },
          ),
        ),
      );
      return;
    }
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'يرجى إدخال عنوان ومحتوى القصة!',
            style: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontFamilyFallback: const ['Noto Naskh Arabic'],
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blueGrey[900],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _posts.insert(
        0,
        StoryPost(
          id: const Uuid().v4(),
          author: _currentUser,
          title: _titleController.text,
          content: _contentController.text,
          createdAt: DateTime.now(),
        ),
      );
    });

    _titleController.clear();
    _contentController.clear();
    Navigator.pop(context);

    // Placeholder for API call to save post
    // await http.post(
    //   Uri.parse('https://api.x.ai/community/posts'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({
    //     'title': _titleController.text,
    //     'content': _contentController.text,
    //     'authorId': _currentUser.id,
    //   }),
    // );
  }

  void _addComment(String postId) {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'يرجى إدخال تعليق!',
            style: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontFamilyFallback: const ['Noto Naskh Arabic'],
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blueGrey[900],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        _posts[postIndex].comments.add(
          Comment(
            id: const Uuid().v4(),
            author: _currentUser,
            content: _commentController.text,
            createdAt: DateTime.now(),
          ),
        );
      }
    });

    _commentController.clear();
    Navigator.pop(context);

    // Placeholder for API call to save comment
    // await http.post(
    //   Uri.parse('https://api.x.ai/community/posts/$postId/comments'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({
    //     'content': _commentController.text,
    //     'authorId': _currentUser.id,
    //   }),
    // );
  }

  void _toggleLike(String postId) {
    setState(() {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        _posts[postIndex].likes++;
      }
    });

    // Placeholder for API call to update likes
    // await http.post(
    //   Uri.parse('https://api.x.ai/community/posts/$postId/like'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({'userId': _currentUser.id}),
    // );
  }

  void _toggleLove(String postId) {
    setState(() {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        _posts[postIndex].loves++;
      }
    });

    // Placeholder for API call to update loves
    // await http.post(
    //   Uri.parse('https://api.x.ai/community/posts/$postId/love'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({'userId': _currentUser.id}),
    // );
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'نشر قصة جديدة',
          style: TextStyle(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            fontFamilyFallback: const ['Noto Naskh Arabic'],
            color: Colors.amber[200],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'عنوان القصة',
                  hintStyle: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.blueGrey[300],
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[900]!.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                maxLines: 5,
                style: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'اكتب قصتك هنا...',
                  hintStyle: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.blueGrey[300],
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey[900]!.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                fontFamilyFallback: const ['Noto Naskh Arabic'],
                color: Colors.red[300],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: _createPost,
            child: Text(
              'نشر',
              style: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                fontFamilyFallback: const ['Noto Naskh Arabic'],
                color: Colors.amber[200],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentsDialog(String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.blueGrey[800]!.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        final post = _posts.firstWhere((post) => post.id == postId);
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'التعليقات',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.amber[200],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: post.comments.length,
                  itemBuilder: (context, index) {
                    final comment = post.comments[index];
                    return ZoomIn(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueGrey[700],
                          child: Text(
                            comment.author.name[0],
                            style: TextStyle(
                              fontFamily: GoogleFonts.tajawal().fontFamily,
                              fontFamilyFallback: const ['Noto Naskh Arabic'],
                              color: Colors.amber[200],
                            ),
                          ),
                        ),
                        title: Text(
                          comment.author.name,
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            color: Colors.amber[200],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          comment.content,
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            color: Colors.white,
                          ),
                        ),
                        trailing: Text(
                          DateFormat('HH:mm').format(comment.createdAt),
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            color: Colors.blueGrey[300],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: TextStyle(
                          fontFamily: GoogleFonts.tajawal().fontFamily,
                          fontFamilyFallback: const ['Noto Naskh Arabic'],
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'اكتب تعليقك...',
                          hintStyle: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            color: Colors.blueGrey[300],
                          ),
                          filled: true,
                          fillColor: Colors.blueGrey[900]!.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.amber[200]),
                      onPressed: () => _addComment(postId),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
              Icon(Icons.group, color: Colors.amber[200], size: 24),
              const SizedBox(width: 8),
              Text(
                'مُجْتَمَعُ الْقِصَصِ',
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
          child: _posts.isEmpty
              ? Center(
            child: FadeInUp(
              child: Text(
                'لم يتم نشر قصص بعد! كن أول من يشارك.',
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
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              final post = _posts[index];
              return ZoomIn(
                delay: Duration(milliseconds: 100 * index),
                child: Card(
                  color: Colors.blueGrey[800]!.withOpacity(0.8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blueGrey[700],
                              child: Text(
                                post.author.name[0],
                                style: TextStyle(
                                  fontFamily: GoogleFonts.tajawal().fontFamily,
                                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                                  color: Colors.amber[200],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.author.name,
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.tajawal().fontFamily,
                                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                                      color: Colors.amber[200],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat.yMMMd('ar').format(post.createdAt),
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.tajawal().fontFamily,
                                      fontFamilyFallback: const ['Noto Naskh Arabic'],
                                      color: Colors.blueGrey[300],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          post.title,
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            color: Colors.amber[200],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.content,
                          style: TextStyle(
                            fontFamily: GoogleFonts.tajawal().fontFamily,
                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.thumb_up, color: Colors.amber[200]),
                                  onPressed: () => _toggleLike(post.id),
                                ),
                                Text(
                                  '${post.likes}',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.tajawal().fontFamily,
                                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                                    color: Colors.amber[200],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: Icon(Icons.favorite, color: Colors.red[300]),
                                  onPressed: () => _toggleLove(post.id),
                                ),
                                Text(
                                  '${post.loves}',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.tajawal().fontFamily,
                                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                                    color: Colors.red[300],
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () => _showCommentsDialog(post.id),
                              child: Text(
                                'تعليقات (${post.comments.length})',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.tajawal().fontFamily,
                                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                                  color: Colors.amber[200],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[200],
        foregroundColor: Colors.blueGrey[900],
        onPressed: _showCreatePostDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}