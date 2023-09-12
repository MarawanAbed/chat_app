import 'package:chat_app/authen/auth_page.dart';
import 'package:chat_app/chat_app/chat_app.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/home/cubit/home_cubit.dart';
import 'package:chat_app/model/model.dart';
import 'package:chat_app/search/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
          HomeCubit.get(context).updateUserData(
              {'isOnline': true, 'lastActive': DateTime.now()});
          break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        HomeCubit.get(context).updateUserData(
            {'isOnline': false, 'lastActive': timeago.format(DateTime.now())});
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        if (cubit.currentUser != null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Chat App'),
              actions: [
                IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    navigateWithoutBack(context, const AuthScreen());
                  },
                  icon: const Icon(Icons.logout),
                ),
                IconButton(
                  onPressed: () {
                    navigateWithBack(context, const SearchScreen());
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            body: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => UserItem(
                    userModel: cubit.userModel[index],
                  ),
                  separatorBuilder: (context, index) => const AuthDivider(),
                  itemCount: cubit.userModel.length,
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Chat App'),
            ),
            body: const Center(
              child: Text('Please log in to see the user list'),
            ),
          );
        }
      },
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 3,
      thickness: 4,
    );
  }
}

class UserItem extends StatelessWidget {
  const UserItem({super.key, required this.userModel});

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateWithBack(
            context,
            ChatScreen(
              userModel: userModel,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: ListTile(
          leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(userModel.image),
              ),
              CircleAvatar(
                radius: 6,
                backgroundColor:
                    userModel.isOnline ? Colors.green : Colors.grey,
              ),
            ],
          ),
          title: Text(userModel.name),
          //format widget.userModel.lastActive

          subtitle:
              Text('Last Active : ${timeago.format(userModel.lastActive)}',
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.grey,
                  )),
        ),
      ),
    );
  }
}
