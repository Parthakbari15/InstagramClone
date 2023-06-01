import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import '../view.dart';
import '../../core/core.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    required dynamic snap,
    super.key,
  }) : _snap = snap;

  // ignore: prefer_typing_uninitialized_variables
  final _snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  bool isAnimating = false;
  User? user;
  int commentLength = 0;
  double _scale = 1.0;
  double _previousScale = 1.0;

  ///for zooming effect in photos
  void _onScaleStart(ScaleStartDetails details) {
    _previousScale = _scale;
    setState(() {});
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = _previousScale * details.scale;
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  void initState() {
    super.initState();
    getComments();
  }

  ///to get the length of comments on particular post
  void getComments() async {
    QuerySnapshot snap = await _fireStore.collection('posts').doc(widget._snap['postId']).collection('comments').get();
    setState(() {
      commentLength = snap.docs.length;
    });
  }

  /// to delete the post
  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackbar(
        err.toString(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    bool isDataLoaded = widget._snap.containsKey('photoUrl') && widget._snap.containsKey('profImage');
    return SafeArea(
      child: !isDataLoaded
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => context.push('/SearchedUser/${widget._snap['uid']}'),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget._snap['profImage']),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget._snap['userName'],
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                              const Text(
                                'Gandhinagar Gujrat',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        widget._snap['uid'].toString() == user!.uid
                            ? IconButton(
                                onPressed: () {
                                  showDialog(
                                    useRootNavigator: false,
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: InkWell(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                                              child: const Text('Delete Post'),
                                            ),
                                            onTap: () {
                                              deletePost(
                                                widget._snap['postId'].toString(),
                                              );
                                              // remove the dialog box
                                              Navigator.of(context).pop();
                                            }),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.more_vert),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTapUp: (_) {
                    HapticFeedback.mediumImpact(); // Provide haptic feedback when long press occurs
                    setState(() {
                      _scale = 2.0; // Set the initial zoom scale when long press occurs
                    });
                  },
                  onTapDown: (_) {
                    setState(() {
                      _scale = 1.0; // Reset the zoom scale when the long press ends
                    });
                  },
                  onScaleStart: _onScaleStart,
                  onScaleUpdate: _onScaleUpdate,
                  onScaleEnd: _onScaleEnd,
                  onDoubleTap: () async {
                    await FireStoreMethods().likePost(widget._snap['postId'], user!.uid, widget._snap['likes'], true);
                    setState(() {
                      isAnimating = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        widget._snap['photoUrl'],
                        fit: BoxFit.fill,
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isAnimating ? 1 : 0,
                        child: LikeAnimation(
                          isAnimating: isAnimating,
                          duration: const Duration(milliseconds: 400),
                          onEnd: () {
                            setState(() {
                              isAnimating = false;
                            });
                          },
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 120,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  // crossAxisAlignment:CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LikeAnimation(
                      isAnimating: widget._snap['likes'].contains(user!.uid),
                      smallLike: true,
                      child: IconButton(
                        onPressed: () async {
                          await FireStoreMethods().likePost(widget._snap['postId'], user!.uid, widget._snap['likes'], false);
                        },
                        icon: widget._snap['likes'].contains(user!.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(Icons.favorite_border),
                      ),
                    ),
                    IconButton(
                        onPressed: () => context.push('/CommentScreen/${widget._snap['postId']}'),
                        icon: const Icon(CupertinoIcons.bubble_right)),
                    Transform.rotate(
                      angle: 610 * pi / 330,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.send,
                            )),
                      ),
                    ),
                    const Spacer(),
                    IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.bookmark)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0, left: 15.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${widget._snap['likes'].length} likes',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 8.0),
                          child: ReadMoreText(
                            '${widget._snap['userName']} ${' '} ${widget._snap['caption']}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            trimLines: 2,
                            colorClickableText: secondaryColor,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',
                            moreStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: secondaryColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: InkWell(
                            onTap: () => context.push('/CommentScreen/${widget._snap['postId']}'),
                            child: Text(
                              'view all $commentLength comments',
                              style: const TextStyle(fontWeight: FontWeight.w400, color: secondaryColor),
                            ),
                          ),
                        ),
                        Text(
                          DateFormat.yMMMd().format(widget._snap['datePublished'].toDate()),
                          style: const TextStyle(fontWeight: FontWeight.w400, color: secondaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
