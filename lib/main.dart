import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Post Card Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PostCards(
                  username: 'Mahtaab',
                  time: '17:07',
                  postText:
                  'This portfolio is a collection of my digital and conceptual artworks, showcasing a blend of imagination, cinematic atmospheres, and visual storytelling.',
                  imageUrl: 'assets/img/image.png',
                  profilePicUrl: 'assets/img/pfp.png',
                  emojis: [
                    EmojiBubble(emoji: '😊'),
                    EmojiBubble(emoji: '😍'),
                    EmojiBubble(emoji: '👍'),
                    EmojiBubble(emoji: '😂'),
                    EmojiBubble(emoji: '🌟'),
                    EmojiBubble(emoji: '🔥'),
                    EmojiBubble(emoji: '💬'),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.white10,
                ),
                SizedBox(height: 20),
                PostCards(
                  username: 'Mahtaab',
                  time: '17:07',
                  postText:
                  'This is a text-only post, without any image or voice.',
                  profilePicUrl: 'assets/img/pfp.png',
                  emojis: [
                    EmojiBubble(emoji: '😊'),
                    EmojiBubble(emoji: '😍'),
                    EmojiBubble(emoji: '👍'),
                    EmojiBubble(emoji: '😂'),
                    EmojiBubble(emoji: '🌟'),
                    EmojiBubble(emoji: '🔥'),
                    EmojiBubble(emoji: '💬'),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.white10,
                ),
                SizedBox(height: 20),
                PostCards(
                  username: 'Mahtaab',
                  time: '17:07',
                  postText: 'This should be a post with voice',
                  profilePicUrl: 'assets/img/pfp.png',
                  emojis: [
                    EmojiBubble(emoji: '😊'),
                    EmojiBubble(emoji: '😍'),
                    EmojiBubble(emoji: '👍'),
                    EmojiBubble(emoji: '😂'),
                    EmojiBubble(emoji: '🌟'),
                    EmojiBubble(emoji: '🔥'),
                    EmojiBubble(emoji: '💬'),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.white10,
                ),
                SizedBox(height: 20),
                PostCards(
                  username: 'Mahtaab',
                  time: '17:10',
                  postText: 'I WILL TATTOO THIS CLIP!',
                  videoUrl: 'assets/videos/sample.mp4',
                  profilePicUrl: 'assets/img/pfp.png',
                  emojis: [
                    EmojiBubble(emoji: '😊'),
                    EmojiBubble(emoji: '😍'),
                    EmojiBubble(emoji: '👍'),
                    EmojiBubble(emoji: '😂'),
                    EmojiBubble(emoji: '🌟'),
                    EmojiBubble(emoji: '🔥'),
                    EmojiBubble(emoji: '💬'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmojiBubble extends StatelessWidget {
  final String emoji;

  const EmojiBubble({super.key, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Text(
      emoji,
      style: const TextStyle(fontSize: 19),
    );
  }
}

class PostCards extends StatefulWidget {
  final String username;
  final String time;
  final String profilePicUrl;

  final String? postText;
  final String? imageUrl;
  final String? voiceLabel;
  final String? videoUrl;

  final List<Widget> emojis;

  const PostCards({
    super.key,
    required this.username,
    required this.time,
    required this.profilePicUrl,
    this.postText,
    this.imageUrl,
    this.voiceLabel,
    this.videoUrl,
    this.emojis = const [],
  });

  @override
  State<PostCards> createState() => _PostCardsState();
}

class _PostCardsState extends State<PostCards> {
  bool isExpanded = false;
  bool _isMuted = true;
  VideoPlayerController? _videoController;
  Duration? _currentPosition;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl != null) {
      _videoController = VideoPlayerController.asset(widget.videoUrl!)
        ..initialize().then((_) {
          setState(() {});
        })
        ..setLooping(true)
        ..setVolume(0.0);

      _videoController!.addListener(() {
        setState(() {
          _currentPosition = _videoController!.value.position;
        });
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
  bool _isLiked = false;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _toggleSound() {
    if (_videoController != null) {
      setState(() {
        _isMuted = !_isMuted;
        _videoController!.setVolume(_isMuted ? 0.0 : 1.0);
      });
    }
  }

  void _toggleFullScreen() async {
    if (_videoController != null) {
      // Save current position
      Duration currentPosition = _videoController!.value.position;
      _videoController!.pause();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullScreenVideoPage(
            videoUrl: widget.videoUrl!,
            initialPosition: currentPosition,
          ),
        ),
      ).then((_) {
        if (mounted) {
          _videoController!.seekTo(FullScreenVideoPage.currentPosition ??
              Duration.zero);
          _videoController!.play();
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl ?? widget.imageUrl ?? widget.postText ?? "post"),
      onVisibilityChanged: (info) {
        if (_videoController != null) {
          if (info.visibleFraction > 0.5) {
            _videoController!.play();
          } else {
            _videoController!.pause();
          }
        }

      },
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(widget.profilePicUrl),
                  radius: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.username,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                      Text(widget.time,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_horiz,
                      color: Colors.white.withOpacity(0.6)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (widget.postText != null)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: RichText(
                  text: TextSpan(
                    text: widget.postText!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    children: [
                      if (!isExpanded && widget.postText!.length > 100)
                        const TextSpan(
                            text: " more...",
                            style: TextStyle(color: Colors.white60)),
                      if (isExpanded)
                        const TextSpan(
                            text: " less", style: TextStyle(color: Colors.white38)),
                    ],
                  ),
                  maxLines: isExpanded || widget.postText!.length <= 100
                      ? null
                      : 2,
                  overflow: isExpanded || widget.postText!.length <= 100
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),
              ),

            if (widget.imageUrl != null) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(widget.imageUrl!),
              ),
            ],

            if (widget.voiceLabel != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.voice_chat, color: Colors.white.withOpacity(0.6)),
                  const SizedBox(width: 8),
                  Text(widget.voiceLabel!,
                      style: TextStyle(color: Colors.white.withOpacity(0.6))),
                ],
              ),
            ],

            /// Video
            if (_videoController != null &&
                _videoController!.value.isInitialized) ...[
              const SizedBox(height: 16),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: GestureDetector(
                        onTap: _toggleFullScreen,
                        child: AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: _toggleSound,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.6),
                        child: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (widget.emojis.isNotEmpty) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.open_in_full_outlined,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: widget.emojis.map((emoji) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 7),
                                    child: emoji,
                                  );
                                }).toList(),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              width: 50,
                              child: IgnorePointer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(1),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white10),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text("Edit", style: TextStyle(fontSize: 19)),
                      ),
                    ),
                  ),

                ],
              ),
            ],
            Row(
              children: [
                IconButton(
                  onPressed: _toggleLike,
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.redAccent,
                  ),
                ),
                IconButton(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.comment_outlined, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.autorenew, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class FullScreenVideoPage extends StatefulWidget {
  final String videoUrl;
  final Duration? initialPosition;
  static Duration? currentPosition;

  const FullScreenVideoPage({Key? key, required this.videoUrl, this.initialPosition})
      : super(key: key);

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _fullScreenVideoController;
  bool _showControls = true;
  double _volume = 1.0;
  bool _isPlaying = true;
  bool _isLiked = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _fullScreenVideoController = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        if (widget.initialPosition != null) {
          _fullScreenVideoController.seekTo(widget.initialPosition!);
        }
        _fullScreenVideoController.play();
      })
      ..setLooping(true);

    _fullScreenVideoController.addListener(() {
      setState(() {
        _isPlaying = _fullScreenVideoController.value.isPlaying;
      });
    });
  }

  @override
  void dispose() {
    FullScreenVideoPage.currentPosition = _fullScreenVideoController.value.position;
    _fullScreenVideoController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _seekRelative(Duration duration) {
    final newPosition = _fullScreenVideoController.value.position + duration;
    if (newPosition < Duration.zero) {
      _fullScreenVideoController.seekTo(Duration.zero);
    } else if (newPosition > _fullScreenVideoController.value.duration) {
      _fullScreenVideoController.seekTo(_fullScreenVideoController.value.duration);
    } else {
      _fullScreenVideoController.seekTo(newPosition);
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _fullScreenVideoController.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleControls,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: _fullScreenVideoController.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _fullScreenVideoController.value.aspectRatio,
                child: VideoPlayer(_fullScreenVideoController),
              )
                  : const CircularProgressIndicator(),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: SafeArea(
                child: FloatingActionButton(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  mini: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
            if (_showControls)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => _seekRelative(const Duration(seconds: -10)),
                      icon:  Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.replay_10, color: Colors.white)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (_isPlaying) {
                            _fullScreenVideoController.pause();
                          } else {
                            _fullScreenVideoController.play();
                          }
                        },
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _seekRelative(const Duration(seconds: 10)),
                      icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.forward_10, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            if (_showControls)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _fullScreenVideoController.value.position.inSeconds.toDouble(),
                              min: 0,
                              max: _fullScreenVideoController.value.duration.inSeconds.toDouble(),
                              onChanged: (value) {
                                _fullScreenVideoController.seekTo(Duration(seconds: value.toInt()));
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: _toggleMute,
                            icon: Icon(
                              _isMuted ? Icons.volume_off : Icons.volume_up,
                              color: Colors.white,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _toggleLike,
                            icon: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: Colors.redAccent,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                            },
                            icon: const Icon(Icons.comment_outlined, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () {
                            },
                            icon: const Icon(Icons.autorenew, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () {
                            },
                            icon: const Icon(Icons.send, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

