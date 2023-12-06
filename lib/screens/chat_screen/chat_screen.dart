import 'dart:developer';
import 'dart:io';
import 'package:car_pooling/models/message_model.dart';
import 'package:car_pooling/screens/chat_screen/image_view.dart';
import 'package:car_pooling/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final bool isNewChat;
  final String fromUserName;
  final String fromUserImage;
  final String fromUserId;
  final String userPushToken;
  final bool isUserOnline;
  const ChatScreen({
    required this.isNewChat,
    required this.fromUserName,
    required this.fromUserImage,
    required this.fromUserId,
    required this.userPushToken,
    required this.isUserOnline,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void markUnreadMessagesAsRead() async {
    await ChatService().markAllUnreadMessagesAsRead(
      otherUserId: widget.fromUserId,
    );
  }

  @override
  void initState() {
    super.initState();

    markUnreadMessagesAsRead();
  }

  TextEditingController messageController = TextEditingController();

  final ChatService chatService = ChatService();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(
        receiverID: widget.fromUserId,
        receiverPushToken: widget.userPushToken,
        message: messageController.text,
      );

      messageController.clear();
    } else {
      Fluttertoast.showToast(msg: "Message cannot be empty!");
    }
  }

  void sendImage() async {
    await chatService.uploadAndSendImageOrFile(
      file: File(selectedImage!.path),
      receiverID: widget.fromUserId,
      receiverPushToken: widget.userPushToken,
      isImage: true,
    );

    setState(() {
      selectedImage = null;
    });
  }

  void sendFile() async {
    await chatService.uploadAndSendImageOrFile(
      file: selectedFile!,
      receiverID: widget.fromUserId,
      receiverPushToken: widget.userPushToken,
      isImage: false,
    );
    setState(() {
      selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chatScreenAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: StreamBuilder(
                stream: chatService.getMessage(
                  userId: widget.fromUserId,
                  otherUserId: firebaseAuth.currentUser!.uid,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text("Loading"),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 300),
                      child: Text("No messages here yet!"),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map(
                      (document) {
                        Map<String, dynamic> messageData =
                            document.data() as Map<String, dynamic>;
                        if (messageData['messageType'] == "image") {
                          return imageBubble(document: document);
                        }
                        if (messageData['messageType'] == "file") {
                          return fileBubble(document: document);
                        }
                        return messageBubble(document: document);
                      },
                    ).toList(),
                  );
                },
              ),
            ),
          ),
          selectedImage != null
              ? imageOrFilePreview(messageType: MessageType.image)
              : selectedFile != null
                  ? imageOrFilePreview(messageType: MessageType.file)
                  : const SizedBox(),
          messageTextField(),
        ],
      ),
    );
  }

  PreferredSizeWidget chatScreenAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.chevron_left_rounded,
          size: 36,
        ),
      ),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              widget.fromUserImage,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    widget.fromUserName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 3,
                      backgroundColor: widget.isUserOnline
                          ? Colors.greenAccent[700]
                          : Colors.grey[300],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        widget.isUserOnline ? "Online" : "Offline",
                        style: TextStyle(
                          fontSize: 10,
                          color: widget.isUserOnline
                              ? Colors.greenAccent[700]
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu_rounded,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget messageBubble({required DocumentSnapshot document}) {
    Map<String, dynamic> messageData = document.data() as Map<String, dynamic>;

    bool isMessageIncoming =
        messageData['senderID'] != firebaseAuth.currentUser!.uid;

    DateTime dateTime = (messageData['timestamp'] as Timestamp).toDate();

    String messageTime = DateFormat('h:mm a').format(dateTime);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isMessageIncoming ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!isMessageIncoming)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/icons/read.png',
                      height: 20,
                      width: 20,
                    ),
                    Text(
                      messageTime,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7D7F88),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: isMessageIncoming
                  ? const Color(0xFFFDFDFD)
                  : const Color(0xFFFF4E00),
              border: Border.all(
                color: isMessageIncoming
                    ? const Color(0xFFE3E3E7)
                    : Colors.transparent,
              ),
              boxShadow: isMessageIncoming
                  ? [
                      BoxShadow(
                        offset: const Offset(0, 3),
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 3,
                      ),
                    ]
                  : null,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: Radius.circular(
                  isMessageIncoming ? 0 : 10,
                ),
                bottomRight: Radius.circular(
                  isMessageIncoming ? 10 : 0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                messageData['message'],
                style: TextStyle(
                  color: isMessageIncoming ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
          if (isMessageIncoming)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messageTime,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget imageBubble({required DocumentSnapshot document}) {
    Map<String, dynamic> messageData = document.data() as Map<String, dynamic>;

    bool isMessageIncoming =
        messageData['senderID'] != firebaseAuth.currentUser!.uid;

    DateTime dateTime = (messageData['timestamp'] as Timestamp).toDate();

    String messageTime = DateFormat('h:mm a').format(dateTime);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!isMessageIncoming)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/icons/read.png',
                    height: 20,
                    width: 20,
                  ),
                  Text(
                    messageTime,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7D7F88),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ImageView(
                  imageUrl: messageData['message'],
                );
              }));
            },
            child: Hero(
              tag: 'heroTag',
              child: Container(
                height: 220,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                  image: DecorationImage(
                    image: NetworkImage(
                      messageData['message'],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isMessageIncoming)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    messageTime,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget fileBubble({required DocumentSnapshot document}) {
    Map<String, dynamic> messageData = document.data() as Map<String, dynamic>;

    bool isMessageIncoming =
        messageData['senderID'] != firebaseAuth.currentUser!.uid;

    DateTime dateTime = (messageData['timestamp'] as Timestamp).toDate();

    String messageTime = DateFormat('h:mm a').format(dateTime);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!isMessageIncoming)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/icons/read.png',
                    height: 20,
                    width: 20,
                  ),
                  Text(
                    messageTime,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7D7F88),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            height: 70,
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.attach_file_rounded,
                    color: Colors.grey[700],
                  ),
                  const Spacer(),
                  const Text(
                    "attachment.pdf",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  if (isMessageIncoming)
                    IconButton(
                      onPressed: () async {
                        log("download file");
                        await launchUrl(
                          Uri.parse(
                            messageData['message'],
                          ),
                        );
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      icon: Icon(
                        Icons.arrow_downward_rounded,
                        color: Colors.grey[700],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (isMessageIncoming)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    messageTime,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget imageOrFilePreview({required MessageType messageType}) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: messageType == MessageType.file
                  ? Icon(
                      Icons.attach_file_rounded,
                      color: Colors.grey[700],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(selectedImage!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                messageType == MessageType.file
                    ? fileName ?? "error"
                    : "Captured from camera",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  selectedImage = null;
                  selectedFile = null;
                });
              },
              icon: Icon(
                Icons.close_rounded,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
      child: TextFormField(
        controller: messageController,
        scrollPadding: MediaQuery.of(context).viewInsets,
        decoration: InputDecoration(
          hintText: "Type something",
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: const Color(0xFFF2F2F3),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color(0xFFE3E3E7),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color(0xFFE3E3E7),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color(0xFFE3E3E7),
            ),
          ),
          prefixIcon: GestureDetector(
            onTap: () {
              log("keyboard tapped");
            },
            child: const Icon(
              Icons.keyboard,
              color: Color(0xFF7D7F88),
            ),
          ),
          suffixIcon: SizedBox(
            width: 112,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    chooseImage();
                  },
                  child: const Icon(
                    Icons.photo_camera_back_outlined,
                    color: Color(0xFF7D7F88),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    onTap: () {
                      log("file tapped");
                      chooseFile();
                    },
                    child: const Icon(
                      Icons.attach_file,
                      color: Color(0xFF7D7F88),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (selectedFile != null) {
                      // send file
                      sendFile();
                    } else if (selectedImage != null) {
                      // send image
                      sendImage();
                    } else {
                      sendMessage();
                    }
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4E00),
                  ),
                  icon: const Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void chooseImage() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Choose image from",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Divider(
                  height: 1,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  openImagePicker(imageSource: ImageSource.camera);
                },
                title: const Center(
                  child: Text("Camera"),
                ),
              ),
              const Divider(
                height: 1,
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  openImagePicker(imageSource: ImageSource.gallery);
                },
                title: const Center(
                  child: Text("Gallery"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  XFile? selectedImage;
  String? imageName;
  void openImagePicker({required ImageSource imageSource}) async {
    selectedImage = await ImagePicker().pickImage(source: imageSource);
    setState(() {
      imageName = selectedImage!.path.split('/').last.split('-').last;
      log("Image path : $imageName");
    });
  }

  File? selectedFile;
  String? fileName;
  void chooseFile() async {
    FilePickerResult? pickerResult = await FilePicker.platform.pickFiles();

    if (pickerResult != null) {
      setState(() {
        selectedFile = File(pickerResult.files.single.path!);
        log("File path : ${selectedFile!.path}");
        fileName = selectedFile!.path.split('/').last;
      });
    } else {
      log("File picker cancelled!");
    }
  }
}
