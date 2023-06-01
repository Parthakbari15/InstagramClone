import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/view/screens/search/searched_user_profillescreen.dart';
import '../view/view.dart';

/// The route configuration.

final router = GoRouter(
  routes: [
    ///initial
    GoRoute(
      path: "/",
      builder: (context, state) => const SplashScreen(),
    ),

    ///MainScreen
    GoRoute(
        path: "/MainScreen",
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 450),
              key: state.pageKey,
              child: const MainScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: CurveTween(curve: Curves.easeIn).animate(animation), child: child);
              });
        }),

    ///check internet connectivity
    GoRoute(
        path: "/ConnectivityCheck",
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 450),
              key: state.pageKey,
              child: const ConnectivityCheck(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: CurveTween(curve: Curves.easeIn).animate(animation), child: child);
              });
        }),

    ///AddPost Screen
    GoRoute(
      path: "/AddPostScreen",
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 450),
          key: state.pageKey,
          child: AddPostScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: CurveTween(curve: Curves.easeIn).animate(animation), child: child);
          },
        );
      },
    ),

    ///Chat Screen
    GoRoute(
      path: "/ChatScreen",
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 450),
          key: state.pageKey,
          child: const ChatScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: CurveTween(curve: Curves.easeIn).animate(animation), child: child);
          },
        );
      },
    ),

    ///Comments screen
    GoRoute(
      path: "/CommentScreen/:postId",
      builder: (context, state) => CommentsScreen(
        postId: state.pathParameters['postId']!,
      ),
    ),

    ///LoginScreen
    GoRoute(path: "/LoginScreen", builder: (context, state) => const LoginScreen()),

    ///Signup Screen
    GoRoute(path: "/SignUpScreen", builder: (context, state) => SignUpScreen()),

    /// Personal Chat
    GoRoute(
      name: 'PersonalChat',
      path: "/PersonalChat",
      builder: (context, state) => PersonalChatScreen(
        userName: state.queryParameters['userName']!,
        photoUrl: state.queryParameters['photoUrl']!,
        uid: state.queryParameters['uid']!,
        chatRoomId: state.queryParameters['chatRoomId']!,
      ),
    ),

    /// Navigate to Followers and following List
    GoRoute(
      name: 'FollowersAndFollowingList',
      path: "/FollowersAndFollowingList",
      builder: (context, state) => FollowersAndFollowingList(
        userName: state.queryParameters['userName']!,
        uid: state.queryParameters['uid']!,
        currentTabIndex: state.queryParameters['currentTabIndex']!,
      ),
    ),

    ///SearchScreen
    GoRoute(
      path: "/SearchScreen",
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 450),
            key: state.pageKey,
            child: SearchScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              final tween = Tween(begin: begin, end: end);
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: curve,
              );
              return SlideTransition(
                position: tween.animate(curvedAnimation),
                child: child,
              );
            });
      },
    ),

    ///Post Detailed View Screen
    GoRoute(
      path: "/PostDetailedView/:postId",
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 450),
            child: PostDetailedView(postId: state.pathParameters['postId']!),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              final tween = Tween(begin: begin, end: end);
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: curve,
              );
              return SlideTransition(
                position: tween.animate(curvedAnimation),
                child: child,
              );
            });
      },
    ),

    ///UpdateProfile Screen
    GoRoute(
      name: 'UpdateProfile',
      path: "/UpdateProfile",
      builder: (context, state) => EditProfile(
        photoUrl: state.queryParameters['photoUrl']!,
        uid: state.queryParameters['uid']!,
        userName: state.queryParameters['userName']!,
        bio: state.queryParameters['bio']!,
      ),
    ),

    ///Searched user screen
    GoRoute(
      path: "/SearchedUser/:uid",
      builder: (context, state) => SearchedUserProfileScreen(
        uid: state.pathParameters['uid']!,
      ),
    ),
  ],
);
