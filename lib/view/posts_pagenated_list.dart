import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagenation_example/base_list_view.dart';
import 'package:pagenation_example/controller/cubit.dart';
import 'package:pagenation_example/controller/states.dart';
import 'package:pagenation_example/post_model.dart';

class PostsListView extends StatefulWidget {
  const PostsListView({super.key});

  @override
  State<PostsListView> createState() => _PostsListViewState();
}

class _PostsListViewState extends State<PostsListView> {
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final PostsCubit cubit = BlocProvider.of<PostsCubit>(context);
    return BlocBuilder<PostsCubit, PostsStates>(builder: (context, state) {
      return PagenatedListView<PostsCubit, PostsStates, PostModel>(
          init: () => controller.addListener(() async {
                var percentageOftotalLength =
                    0.7 * controller.position.maxScrollExtent;
                var currentLength = controller.position.pixels;
                if (currentLength >= percentageOftotalLength &&
                    cubit.state is! PostsPagentationLoadingState) {
                  await cubit.call();
                }
              }),
          controller: controller,
          items: cubit.posts!,
          childBuilder: (index) => Column(
                children: [
                  Text(index.toString()),
                  Text(cubit.posts![index].title),
                  Text(cubit.posts![index].body)
                ],
              ),
          allCaught: cubit.state is PostsSuccessAllCaughtState,
          isLoading: cubit.state is PostsPagentationLoadingState);
    });
  }
}
