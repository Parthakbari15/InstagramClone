import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:instagram_clone/view/view.dart';
import 'package:flutter/material.dart';
class ContentScreen extends StatefulWidget {
  final String? src;

  const ContentScreen({Key? key, this.src}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.src!);
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: true,
      aspectRatio: 510/1000
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
            ? GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    _liked = true;
                  });
                },
                child: Chewie(
                  controller: _chewieController!,
                ),
              )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
                children: const [Center(child: CircularProgressIndicator()), SizedBox(height: 10), Text('Loading...')],
              ),
        (_liked)
            ? Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _liked ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: _liked,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        _liked = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                ),
              )
            : Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _liked ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: _liked,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        _liked = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                ),
              ),
        const OptionsScreen()
      ],
    );
  }
}
