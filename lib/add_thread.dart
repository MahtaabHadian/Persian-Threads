import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

class NewClaimPostPage extends StatefulWidget {
  @override
  _NewClaimPostPageState createState() => _NewClaimPostPageState();
}

class _NewClaimPostPageState extends State<NewClaimPostPage> {
  final TextEditingController _textController = TextEditingController();
  List<File> _selectedImages = [];
  List<String> _audioPaths = [];
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isPlayerInited = false;
  bool _isRecorderReady = false;
  Duration _recordDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initRecorder();
    _initPlayer();
  }

  Future<void> _initRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }

    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
    setState(() => _isRecorderReady = true);
  }

  Future<void> _initPlayer() async {
    await _player.openPlayer();
    setState(() => _isPlayerInited = true);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _startRecording() async {
    if (!_isRecorderReady || !_recorder.isStopped) return;

    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/claim_audio_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.startRecorder(
      toFile: path,
      codec: Codec.aacADTS,
    );
    setState(() {
      _audioPaths.add(path);
      _isRecording = true;
      _recordDuration = Duration.zero;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() => _isRecording = false);
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removeAudio(int index) {
    final path = _audioPaths[index];
    File(path).delete();
    setState(() {
      _audioPaths.removeAt(index);
    });
  }

  Future<void> _playAudio(String path) async {
    if (!_isPlayerInited) return;

    setState(() => _isPlaying = true);
    await _player.startPlayer(
      fromURI: path,
      whenFinished: () => setState(() => _isPlaying = false),
    );
  }

  Future<void> _stopAudio() async {
    await _player.stopPlayer();
    setState(() => _isPlaying = false);
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ثبت ادعا جدید', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(backgroundImage: AssetImage('assets/user.jpg'), radius: 20),
                  const SizedBox(width: 10),
                  Text('مهدی حمود', style: TextStyle(color: Colors.white)),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text('افزودن موضوع پست', style: TextStyle(color: Colors.blueAccent)),
                  )
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _textController,
                style: TextStyle(color: Colors.white),
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'متن ادعا را وارد کنید...',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_selectedImages.length, (index) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_selectedImages[index], height: 100, width: 100, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: InkWell(
                        onTap: () => _removeImage(index),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                    )
                  ],
                )),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                  IconButton(
                    icon: Icon(Icons.image, color: Colors.white),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                  GestureDetector(
                    onLongPressStart: (_) => _startRecording(),
                    onLongPressEnd: (_) => _stopRecording(),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
                      child: Icon(Icons.mic, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: List.generate(_audioPaths.length, (index) => Row(
                  children: [
                    const SizedBox(width: 8),
                    Text('صدای ${index + 1}', style: TextStyle(color: Colors.white)),
                    Spacer(),
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow, color: Colors.white),
                      onPressed: _isPlaying ? _stopAudio : () => _playAudio(_audioPaths[index]),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => _removeAudio(index),
                    ),
                  ],
                )),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 6,
                  ),
                  child: Text('ثبت پست', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
