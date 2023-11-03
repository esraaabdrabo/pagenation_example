import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagenation_example/controller/cubit.dart';
import 'package:pagenation_example/controller/states.dart';
class PostsView extends StatefulWidget {
  const PostsView({super.key});

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider(
            create: (context) => PostsCubit(PostsInitState())..call(),
            child:
                BlocBuilder<PostsCubit, PostsStates>(builder: (context, state) {
              if (state is PostsLoadingState) {
                return const CircularProgressIndicator();
              } else {
                return Column(
                  children: [
                    state is PostsSuccessNoPostsState
                        ? const Expanded(child: Text("no posts"))
                        : const PostsListView()
                  ],
                );
              }
            })),
      ),
    );
  }
}