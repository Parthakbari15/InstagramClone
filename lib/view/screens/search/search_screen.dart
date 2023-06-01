import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/core/controller/search_user_controller.dart';
import '../../view.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchUserController _searchUserController = Get.put(SearchUserController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: calculateHorizontalPadding(context)),
          width: double.infinity,
          child: AppBar(
            backgroundColor: scaffoldBackgroundColor,
            elevation: 0,
            title: SizedBox(
              height: 40,
              child: TextFormField(
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.start,
                controller: _searchUserController.searchController.value,
                decoration: const InputDecoration(
                  hintText: 'Search users...',
                  contentPadding: EdgeInsets.only(bottom: 20),
                  prefixIcon: Icon(
                    Icons.search,
                    color: darkGray,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: darkGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: darkGray),
                  ),
                ),
                onFieldSubmitted: (_) {
                  _searchUserController.setIsShowUser(true);
                  _searchUsers();
                },
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: calculateHorizontalPadding(context)),
        width: double.infinity,
        child: Obx(
          () {
            final searchResults = _searchUserController.searchResults.value;
            if (_searchUserController.isShowUsers.value) {
              if (searchResults != null) {
                return StreamBuilder<QuerySnapshot>(
                  stream: searchResults,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final docs = snapshot.data!.docs;
                    if (docs.isEmpty) {
                      return const Center(
                        child: Text('No users found.'),
                      );
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final userData = docs[index].data() as Map<String, dynamic>;
                        return InkWell(
                          onTap: () => context.push('/SearchedUser/${userData['uid']}'),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(userData['photoUrl']),
                                radius: 28,
                              ),
                              title: Text(userData['userName']),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('Enter Username to search...'),
                );
              }
            } else {
              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('posts').orderBy('datePublished').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text('No posts available.'),
                    );
                  }

                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    physics: const BouncingScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final postData = docs[index].data() as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () => context.push('/PostDetailedView/${postData['postId']}'),
                        child: Image.network(
                          postData['photoUrl'],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    staggeredTileBuilder: (index) => MediaQuery.of(context).size.width > webScreenSize
                        ? StaggeredTile.count((index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                        : StaggeredTile.count((index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _searchUsers() {
    final SearchUserController _searchUserController = Get.find();
    final searchText = _searchUserController.searchController.value.text;
    if (searchText.isNotEmpty) {
      final searchQuery = FirebaseFirestore.instance.collection('users').where(
            'userName',
            isGreaterThanOrEqualTo: searchText,
          );

      _searchUserController.setSearchResults(searchQuery.snapshots());
    } else {
      _searchUserController.setSearchResults(null);
    }
  }
}
