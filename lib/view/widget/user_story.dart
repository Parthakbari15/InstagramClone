import 'package:flutter/material.dart';

class UserStory extends StatelessWidget {
  const UserStory({
    required this.snap,
    super.key,
  });

  final dynamic snap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.16,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 20,
          child: Column(
            children: [
              CircleAvatar(
                maxRadius: 32,
                backgroundImage: NetworkImage(snap['photoUrl']),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  snap['userName'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
