import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo', style: TextStyle(color: Colors.brown)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File', style: TextStyle(color: Colors.brown)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
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
    final result = await ImagePicker().pickImage(imageQuality: 70, maxWidth: 1440, source: ImageSource.gallery);
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

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;
      if (message.uri.startsWith('http')) {
        try {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(isLoading: true);
          setState(() {
            _messages[index] = updatedMessage;
          });
          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';
          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(isLoading: null);
          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }
      await OpenFilex.open(localPath);
    } else if (message is types.TextMessage) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.brown[50], // لون خلفية شبيه بالبيج
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.brown), // لون أيقونة التعديل
                title: Text(
                  'تعديل الرسالة',
                  style: TextStyle(
                    color: Colors.brown[800], // لون النص بني غامق
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal', // خط يطابق التصميم
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _editMessage(message);
                },
              ),
              const Divider(color: Colors.brown), // خط فاصل بلون بني فاتح
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red), // لون أيقونة الحذف بالأحمر
                title: Text(
                  'حذف',
                  style: TextStyle(
                    color: Colors.red[700], // لون النص أحمر غامق
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteMessage(message);
                },
              ),
            ],
          );
        },
      );

    }
  }


  void _handlePreviewDataFetched(types.TextMessage message, types.PreviewData previewData) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(previewData: previewData);
    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _addMessage(textMessage);
  }

  void _editMessage(types.Message message) {
    if (message is types.TextMessage) {
      final controller = TextEditingController(text: message.text);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.brown[50], // لون الخلفية الفاتح ليتناسب مع التصميم
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: Text(
              'تعديل الرسالة',
              style: TextStyle(
                color: Colors.brown[800], // لون النص بني غامق
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            content: TextField(
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'عدل رسالتك هنا',
                hintStyle: TextStyle(color: Colors.brown[300]), // لون النص الإرشادي
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown[800]!),
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
                    color: Colors.brown[800], // لون النص للأزرار
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    color: Colors.red[700], // لون النص الأحمر لزر الإلغاء
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
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
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();
    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('حكاوي'),
      backgroundColor: Colors.brown[800],
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            // يمكن إضافة نافذة لعرض المحادثات القديمة
          },
        ),
      ],
    ),
    // drawer: Drawer(
    //   child: ListView(
    //     padding: EdgeInsets.zero,
    //     children: [
    //       const DrawerHeader(
    //         decoration: BoxDecoration(color: Colors.brown),
    //         child: Text(
    //           'الدردشات القديمة',
    //           style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //       ListTile(
    //         title: Text('دردشة بتاريخ 2024-10-10'),
    //         onTap: () {},
    //       ),
    //       ListTile(
    //         title: Text('دردشة بتاريخ 2024-10-11'),
    //         onTap: () {},
    //       ),
    //     ],
    //   ),
    // ),
    backgroundColor: const Color(0xFFF1E6D2),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            ' ${DateFormat.yMMMd().format(DateTime.now())}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
          ),
        ),
        Expanded(
          child: Chat(
            messages: _messages,
            onAttachmentPressed: _handleAttachmentPressed,
            // onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            showUserAvatars: true,
            showUserNames: true,
            user: _user,
            onMessageLongPress: (context, message) {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.edit, color: Colors.brown),
                        title: Text(
                          'تعديل الرسالة',
                          style: TextStyle(color: Colors.brown[800], fontFamily: 'Tajawal'),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _editMessage(message);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete, color: Colors.red),
                        title: Text(
                          'حذف',
                          style: TextStyle(color: Colors.red[700], fontFamily: 'Tajawal'),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _deleteMessage(message);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            theme: DefaultChatTheme(
              inputBackgroundColor: Colors.brown[700]!,
              inputTextColor: Colors.white,
              backgroundColor: const Color(0xFFF1E6D2),
              primaryColor: Colors.brown[800]!,
              secondaryColor: Colors.grey[600]!,
              inputTextStyle: GoogleFonts.tajawal(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              sentMessageBodyTextStyle: GoogleFonts.tajawal(
                color: Colors.white,
                fontSize: 16,
                // fontWeight: FontWeight.bold,
              ),
              receivedMessageBodyTextStyle: GoogleFonts.tajawal(
                color: Colors.white,
                fontSize: 16,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
