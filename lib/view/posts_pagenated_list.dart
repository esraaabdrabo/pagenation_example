import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagenation_example/base_list_view.dart';
import 'package:pagenation_example/controller/cubit.dart';
import 'package:pagenation_example/controller/states.dart';
import 'package:pagenation_example/post_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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

    ///why we are using the bloc builder here ? to update the value of parameters
    ///[allCaught] and [isLoading] when emitting there state
    return BlocBuilder<PostsCubit, PostsStates>(
        buildWhen: (previous, current) =>
            current is PostsSuccessAllCaughtState ||
            current is PostsPagentationLoadingState,
        builder: (context, state) {
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
              childBuilder: (index) => _Item(cubit.posts![index], index),
              allCaughtState: PostsSuccessAllCaughtState(),
              loadingState: PostsPagentationLoadingState());
        });
  }
}

class _Item extends StatelessWidget {
  const _Item(this.post, this.index);

  final PostModel post;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      tileColor: Colors.grey.withOpacity(.1),
      titleAlignment: ListTileTitleAlignment.top,
      leading: CircleAvatar(
        radius: 5.w,
        child: Text("${index + 1}"),
      ),
      title: Text("Title : ${post.title}"),
      subtitle: Text("Body : ${post.body}"),
    );
  }
}
