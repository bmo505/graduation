import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation/features/auth/manager/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  final String? initialMessage;
  final User? user;

  const ChatPage({super.key, this.initialMessage, this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
    firstName: 'انت',
  );
  final _bot = const types.User(
    id: 'bot-001',
    firstName: 'راوي',
  );
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    if (widget.initialMessage != null) {
      _handleSendPressed(types.PartialText(text: widget.initialMessage!));
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF37474F).withOpacity(0.9), // Card Background
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'اضافة مرفق',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: const Color(0xFFFFE082), // Accent
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo, color: Color(0xFFFFE082)),
                title: Text(
                  'صورة',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: const Color(0xFFFFE082),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file, color: Color(0xFFFFE082)),
                title: Text(
                  'ملف',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: const Color(0xFFFFE082),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Color(0xFFC62828)),
                title: Text(
                  'الغاء',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: const Color(0xFFC62828),
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleFileSelection() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null && result.files.single.path != null) {
        final message = types.FileMessage(
          author: _user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          mimeType: lookupMimeType(result.files.single.path!),
          name: result.files.single.name,
          size: result.files.single.size,
          uri: result.files.single.path!,
        );
        _addMessage(message);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'خطأ اثناء تحميل الملف',
            style: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontFamilyFallback: const ['Noto Naskh Arabic'],
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF263238), // Primary Dark
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleImageSelection() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final result = await ImagePicker().pickImage(
        imageQuality: 70,
        maxWidth: 1440,
        source: ImageSource.gallery,
      );
      if (result != null) {
        final bytes = await result.readAsBytes();
        final image = await decodeImageFromList(bytes);
        final message = types.ImageMessage(
          author: _user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          height: image.height.toDouble(),
          id: const Uuid().v4(),
          name: result.name,
          size: bytes.length,
          uri: result.path,
          width: image.width.toDouble(),
        );
        _addMessage(message);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'خطأ اثناء تحميل الصورة',
            style: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
              fontFamilyFallback: const ['Noto Naskh Arabic'],
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF263238),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handlePreviewDataFetched(types.TextMessage message, types.PreviewData previewData) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    if (index != -1) {
      final updatedMessage = (_messages[index] as types.TextMessage).copyWith(previewData: previewData);
      setState(() {
        _messages[index] = updatedMessage;
      });
    }
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _addMessage(textMessage);

    // Send message to backend
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await http.post(
        Uri.parse('https://your-api.com/api/chat'),
        headers: {
          'Content-Type': 'application/json',
          if (widget.user?.token != null) 'Authorization': 'Bearer ${widget.user!.token}',
        },
        body: jsonEncode({
          'userId': _user.id,
          'message': message.text,
        }),
      );

      if (response.statusCode == 200) {
        final botResponse = jsonDecode(response.body);
        final botMessage = types.TextMessage(
          author: _bot,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: botResponse['response'] ?? 'ممتاز! سأبدأ بكتابة قصة بناءً على: "${message.text}". هل تريد مني ان اكمل ام تريد اضافة تفاصيل؟',
        );
        _addMessage(botMessage);
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'جلستك انتهت! الرجاء تسجيل الدخول مرة اخرى',
              style: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                fontFamilyFallback: const ['Noto Naskh Arabic'],
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFFC62828), // Error
            action: SnackBarAction(
              label: 'تسجيل الدخول',
              textColor: const Color(0xFFFFE082),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ),
        );
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      final botMessage = types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: 'عذرا، حدث خطأ. هل يمكنك المحاولة مرة اخرى؟',
      );
      _addMessage(botMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _editMessage(types.Message message) {
    if (message is types.TextMessage) {
      final controller = TextEditingController(text: message.text);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF37474F), // Card Background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              'تعديل الرسالة',
              style: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                fontFamilyFallback: const ['Noto Naskh Arabic'],
                color: const Color(0xFFFFE082),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: TextField(
              controller: controller,
              maxLines: null,
              style: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                fontFamilyFallback: const ['Noto Naskh Arabic'],
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'عدل رسالتك هنا',
                hintStyle: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  color: const Color(0xFF90A4AE), // Detail Text
                ),
                filled: true,
                fillColor: const Color(0xFF263238).withOpacity(0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  final updatedMessage = message.copyWith(
                    text: controller.text,
                    createdAt: DateTime.now().millisecondsSinceEpoch,
                  ) as types.TextMessage;
                  setState(() {
                    final index = _messages.indexWhere((msg) => msg.id == message.id);
                    if (index != -1) {
                      _messages[index] = updatedMessage;
                    }
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'حفظ',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: const Color(0xFFFFE082),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'الغاء',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: const Color(0xFFC62828),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void _deleteMessage(types.Message message) {
    setState(() {
      _messages.removeWhere((msg) => msg.id == message.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم حذف الرسالة',
          style: TextStyle(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            fontFamilyFallback: const ['Noto Naskh Arabic'],
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF263238),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _loadMessages() async {
    final welcomeMessage = types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: 'مرحبا! انا راوي، مساعدك لخلق قصص مذهلة. اخبرني، ما الفكرة التي تريدنا نبدأ بها؟',
    );
    setState(() {
      _messages = [welcomeMessage];
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: const Color(0xFF263238).withOpacity(0.5), // Primary Dark
          elevation: 0,
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFB0BEC5).withOpacity(0.3), // Border
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          title: ZoomIn(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.book, color: Color(0xFFFFE082), size: 24),
                const SizedBox(width: 8),
                Text(
                  'حكايات راوي',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFFE082),
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.history, color: Color(0xFFFFE082)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'سجل المحادثات قادم قريبا!',
                      style: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontFamilyFallback: const ['Noto Naskh Arabic'],
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: const Color(0xFF263238),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              tooltip: 'سجل المحادثات',
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF263238), // Primary Dark
                Color(0xFF90CAF9), // Primary Light
              ],
            ),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(seconds: 5),
                top: 50,
                left: 50,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFE082).withOpacity(0.5), // Sparkle Effect
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(seconds: 7),
                bottom: 100,
                right: 80,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFE082).withOpacity(0.4),
                  ),
                ),
              ),
              SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ZoomIn(
                            child: Text(
                              'اليوم ${DateFormat.yMMMd('ar').format(DateTime.now())}',
                              style: TextStyle(
                                fontFamily: GoogleFonts.tajawal().fontFamily,
                                fontFamilyFallback: const ['Noto Naskh Arabic'],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFFE082),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Chat(
                            messages: _messages,
                            onAttachmentPressed: _handleAttachmentPressed,
                            onPreviewDataFetched: _handlePreviewDataFetched,
                            onSendPressed: _handleSendPressed,
                            showUserAvatars: true,
                            showUserNames: true,
                            user: _user,
                            onMessageLongPress: (context, message) {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: const Color(0xFF37474F).withOpacity(0.9),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (BuildContext context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: const Icon(Icons.edit, color: Color(0xFFFFE082)),
                                        title: Text(
                                          'تعديل الرسالة',
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.tajawal().fontFamily,
                                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                                            color: const Color(0xFFFFE082),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _editMessage(message);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.delete, color: Color(0xFFC62828)),
                                        title: Text(
                                          'حذف الرسالة',
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.tajawal().fontFamily,
                                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                                            color: const Color(0xFFC62828),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _deleteMessage(message);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.share, color: Color(0xFFFFE082)),
                                        title: Text(
                                          'مشاركة الرسالة',
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.tajawal().fontFamily,
                                            fontFamilyFallback: const ['Noto Naskh Arabic'],
                                            color: const Color(0xFFFFE082),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'ميزة المشاركة قادمة قريبا!',
                                                style: TextStyle(
                                                  fontFamily: GoogleFonts.tajawal().fontFamily,
                                                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor: const Color(0xFF263238),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            theme: DefaultChatTheme(
                              inputBackgroundColor: const Color(0xFF37474F).withOpacity(0.7),
                              inputTextColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              primaryColor: const Color(0xFF455A64), // Colors.blueGrey[700]
                              secondaryColor: const Color(0xFF263238).withOpacity(0.8),
                              inputTextStyle: TextStyle(
                                fontFamily: GoogleFonts.tajawal().fontFamily,
                                fontFamilyFallback: const ['Noto Naskh Arabic'],
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              sentMessageBodyTextStyle: TextStyle(
                                fontFamily: GoogleFonts.tajawal().fontFamily,
                                fontFamilyFallback: const ['Noto Naskh Arabic'],
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              receivedMessageBodyTextStyle: TextStyle(
                                fontFamily: GoogleFonts.tajawal().fontFamily,
                                fontFamilyFallback: const ['Noto Naskh Arabic'],
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              dateDividerTextStyle: TextStyle(
                                fontFamily: GoogleFonts.tajawal().fontFamily,
                                fontFamilyFallback: const ['Noto Naskh Arabic'],
                                color: const Color(0xFFFFE082),
                                fontSize: 12,
                              ),
                              inputBorderRadius: BorderRadius.circular(20),
                              messageBorderRadius: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFE082),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}