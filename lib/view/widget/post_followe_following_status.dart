import 'package:flutter/material.dart';

class PostFollowerFollowingStatus extends StatelessWidget {
  const PostFollowerFollowingStatus({
    required this.title,
    required this.values,
    required this.onPressed,
    super.key,
  });

  final int values;
  final String title;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Text(
            values.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
          ),
        ],
      ),
    );
  }
}
