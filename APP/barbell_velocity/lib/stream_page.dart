// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoStreamPage extends StatefulWidget {
//   @override
//   _VideoStreamPageState createState() => _VideoStreamPageState();
// }

// class _VideoStreamPageState extends State<VideoStreamPage> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(
//       Uri.parse('http://10.0.2.2:5000/webcam')
//     )
//       ..initialize().then((_) {
//         // Ensure the first frame is shown.
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Stream'),
//       ),
//       body: Center(
//         child: _controller.value.isInitialized
//             ? AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               )
//             : CircularProgressIndicator(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             if (_controller.value.isPlaying) {
//               _controller.pause();
//             } else {
//               _controller.play();
//             }
//           });
//         },
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class VideoStreamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MJPEG Video Stream'),
      ),
      body: const Center(
        child: Mjpeg(
          stream: 'http://10.0.2.2:5000/webcam', // URL to your MJPEG stream
        ),
      ),
    );
  }
}
