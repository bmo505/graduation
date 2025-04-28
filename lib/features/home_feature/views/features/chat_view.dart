import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';
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

  const ChatPage({super.key, this.initialMessage});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
    firstName: 'أَنْتَ',
  );
  final _bot = const types.User(
    id: 'bot-001',
    firstName: 'رَاوٍ',
  );

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
      backgroundColor: Colors.blueGrey[800]!.withOpacity(0.9),
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
                  'إِضَافَةُ مُرْفَقٍ',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.amber[200],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFeatures: const [FontFeature.enable('ccmp')],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.photo, color: Colors.amber[200]),
                title: Text(
                  'صُورَةٌ',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.amber[200],
                    fontFeatures: const [FontFeature.enable('ccmp')],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file, color: Colors.amber[200]),
                title: Text(
                  'مَلَفٌّ',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.amber[200],
                    fontFeatures: const [FontFeature.enable('ccmp')],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: Colors.red[300]),
                title: Text(
                  'إِلْغَاءٌ',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.red[300],
                    fontFeatures: const [FontFeature.enable('ccmp')],
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

  void _handleFileSelection() async {
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
  }

  void _handleImageSelection() async {
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

    // Simulated bot response
    final botMessage = types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: 'مُمْتَاز! سَأَبْدَأُ بِكِتَابَةِ قِصَّةٍ بِأُسْلُوبِ "${message.text.split(':')[0].split(' ').last}": "${message.text.split(':').last.trim()}". هَلْ تُرِيدُنِي أَنْ أُكْمِلَ أَمْ تُرِيدُ إِضَافَةَ تَفَاصِيلَ؟',
    );
    await Future.delayed(const Duration(milliseconds: 500));
    _addMessage(botMessage);
  }

  void _editMessage(types.Message message) {
    if (message is types.TextMessage) {
      final controller = TextEditingController(text: message.text);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.blueGrey[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              'تَعْدِيلُ الرِّسَالَةِ',
              style: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                fontFamilyFallback: const ['Noto Naskh Arabic'],
                color: Colors.amber[200],
                fontWeight: FontWeight.bold,
                fontFeatures: const [FontFeature.enable('ccmp')],
              ),
            ),
            content: TextField(
              controller: controller,
              maxLines: null,
              style: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                fontFamilyFallback: const ['Noto Naskh Arabic'],
                color: Colors.white,
                fontFeatures: const [FontFeature.enable('ccmp')],
              ),
              decoration: InputDecoration(
                hintText: 'عَدِّلْ رِسَالَتَكَ هُنَا',
                hintStyle: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                  fontFamilyFallback: const ['Noto Naskh Arabic'],
                  color: Colors.blueGrey[300],
                  fontFeatures: const [FontFeature.enable('ccmp')],
                ),
                filled: true,
                fillColor: Colors.blueGrey[900]!.withOpacity(0.5),
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
                  'حِفْظٌ',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.amber[200],
                    fontWeight: FontWeight.bold,
                    fontFeatures: const [FontFeature.enable('ccmp')],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'إِلْغَاءٌ',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.red[300],
                    fontWeight: FontWeight.bold,
                    fontFeatures: const [FontFeature.enable('ccmp')],
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
          'تَمَّ حَذْفُ الرِّسَالَةِ',
          style: TextStyle(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            fontFamilyFallback: const ['Noto Naskh Arabic'],
            color: Colors.white,
            fontFeatures: const [FontFeature.enable('ccmp')],
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _loadMessages() async {
    // Simulated initial message
    final welcomeMessage = types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: 'مَرْحَبًا! أَنَا رَاوٍ، مُسَاعِدُكَ لِخَلْقِ قِصَصٍ مُذْهِلَةٍ. أَخْبِرْنِي، مَا الْفِكْرَةُ الَّتِي تُرِيدُنَا نَبْدَأُ بِهَا؟',
    );
    setState(() {
      _messages = [welcomeMessage];
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
              'حِكَايَاتُ رَاوٍ',
              style: TextStyle(
                fontFamily: GoogleFonts.tajawal().fontFamily,
                fontFamilyFallback: const ['Noto Naskh Arabic'],
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber[200],
                fontFeatures: const [FontFeature.enable('ccmp')],
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.history, color: Colors.amber[200]),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'سَجِلُّ الْمُحَادَثَاتِ قَادِمٌ قَرِيبًا!',
                  style: TextStyle(
                    fontFamily: GoogleFonts.tajawal().fontFamily,
                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                    color: Colors.white,
                    fontFeatures: const [FontFeature.enable('ccmp')],
                  ),
                ),
                backgroundColor: Colors.blueGrey[900],
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          tooltip: 'سَجِلُّ الْمُحَادَثَاتِ',
        ),
      ],
    ),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blueGrey[900]!, Colors.blue[200]!],
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
                color: Colors.amber[200]!.withOpacity(0.5),
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
                color: Colors.amber[200]!.withOpacity(0.4),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ZoomIn(
                    child: Text(
                      'الْيَوْمَ ${DateFormat.yMMMd('ar').format(DateTime.now())}',
                      style: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontFamilyFallback: const ['Noto Naskh Arabic'],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber[200],
                        fontFeatures: const [FontFeature.enable('ccmp')],
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
                        backgroundColor: Colors.blueGrey[800]!.withOpacity(0.9),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.edit, color: Colors.amber[200]),
                                title: Text(
                                  'تَعْدِيلُ الرِّسَالَةِ',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.tajawal().fontFamily,
                                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                                    color: Colors.amber[200],
                                    fontFeatures: const [FontFeature.enable('ccmp')],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  _editMessage(message);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.delete, color: Colors.red[300]),
                                title: Text(
                                  'حَذْفُ الرِّسَالَةِ',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.tajawal().fontFamily,
                                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                                    color: Colors.red[300],
                                    fontFeatures: const [FontFeature.enable('ccmp')],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  _deleteMessage(message);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.share, color: Colors.amber[200]),
                                title: Text(
                                  'مُشَارَكَةُ الرِّسَالَةِ',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.tajawal().fontFamily,
                                    fontFamilyFallback: const ['Noto Naskh Arabic'],
                                    color: Colors.amber[200],
                                    fontFeatures: const [FontFeature.enable('ccmp')],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'مِيزَةُ الْمُشَارَكَةِ قَادِمَةٌ قَرِيبًا!',
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.tajawal().fontFamily,
                                          fontFamilyFallback: const ['Noto Naskh Arabic'],
                                          color: Colors.white,
                                          fontFeatures: const [FontFeature.enable('ccmp')],
                                        ),
                                      ),
                                      backgroundColor: Colors.blueGrey[900],
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
                      inputBackgroundColor: Colors.blueGrey[800]!.withOpacity(0.7),
                      inputTextColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      primaryColor: Colors.blueGrey[700]!,
                      secondaryColor: Colors.blueGrey[900]!.withOpacity(0.8),
                      inputTextStyle: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontFamilyFallback: const ['Noto Naskh Arabic'],
                        color: Colors.white,
                        fontSize: 16,
                        fontFeatures: const [FontFeature.enable('ccmp')],
                      ),
                      sentMessageBodyTextStyle: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontFamilyFallback: const ['Noto Naskh Arabic'],
                        color: Colors.white,
                        fontSize: 16,
                        fontFeatures: const [FontFeature.enable('ccmp')],
                      ),
                      receivedMessageBodyTextStyle: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontFamilyFallback: const ['Noto Naskh Arabic'],
                        color: Colors.white,
                        fontSize: 16,
                        fontFeatures: const [FontFeature.enable('ccmp')],
                      ),
                      dateDividerTextStyle: TextStyle(
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                        fontFamilyFallback: const ['Noto Naskh Arabic'],
                        color: Colors.amber[200],
                        fontSize: 12,
                        fontFeatures: const [FontFeature.enable('ccmp')],
                      ),
                      inputBorderRadius: BorderRadius.circular(20),
                      messageBorderRadius: 20,
                    ),
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