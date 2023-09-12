import 'package:chat_app/chat_app/chat_app.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/model/model.dart';
import 'package:chat_app/search/cubit/search_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<SearchScreen> {
   final TextEditingController _controller= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          var cubit = SearchCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Search'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    onChanged: (val) {
                      cubit.searchUser(val);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: cubit.users.isEmpty
                        ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Search for users')
                      ],
                    )
                        : ListView.builder(
                        itemCount: cubit.users.length,
                        itemBuilder: (context, index) {
                          return  userItem(
                              userModel: cubit.users[index]);
                        }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class userItem extends StatelessWidget {
  const userItem({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateWithoutBack(context, ChatScreen(userModel: userModel));
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
                backgroundColor: userModel.isOnline ? Colors.green : Colors.grey,
              ),
            ],
          ),
          title: Text(userModel.name),
          //format widget.userModel.lastActive

          subtitle: Text('Last Active : ${timeago.format(userModel.lastActive)}',
              maxLines: 2,
              style: const TextStyle(
                color: Colors.grey,
              )),
        ),
      ),
    );
  }
}
