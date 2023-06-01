import 'package:flutter/material.dart';
import '../../../utils/utils.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Flutter Shorts',
                  style: TextStyles.h1Bold.copyWith(color: primaryColor),
                ),
                const Icon(Icons.camera_alt,color: primaryColor,),
              ],
            ),
          ),
          const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 110),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        child: Icon(Icons.person, size: 18),
                      ),
                      const SizedBox(width: 6),
                      const Text('flutter_developer01',style: TextStyles.p2Normal),
                      const SizedBox(width: 10),
                      const Icon(Icons.verified, size: 15,color: blueColor,),
                      const SizedBox(width: 6),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),
                  const Text('Flutter is beautiful and fast 💙❤💛 ..',style: TextStyles.p2Normal),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Icon(
                        Icons.music_note,
                        size: 15,
                        color: primaryColor,
                      ),
                      Text('Original Audio - some music track--',style: TextStyles.p2Normal,),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.favorite_outline,color: primaryColor,),
                  const Text('601k',style: TextStyles.p2Normal,),
                  const SizedBox(height: 20),
                  const Icon(Icons.comment_rounded,color: primaryColor,),
                  const Text('1123',style: TextStyles.p2Normal,),
                  const SizedBox(height: 20),
                  Transform(
                    transform: Matrix4.rotationZ(5.8),
                    child: const Icon(Icons.send,color: primaryColor,),
                  ),
                  const SizedBox(height: 20),
                  const Icon(Icons.more_vert,color: primaryColor,),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}