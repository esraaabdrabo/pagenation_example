import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagenation_example/controller/states.dart';
import 'package:pagenation_example/post_model.dart';
import 'package:pagenation_example/services.dart';

class PostsCubit extends Cubit<PostsStates> {
  PostsCubit(super.initialState);
  List<PostModel>? posts;
  int _nextPageNumber = 1;

  ///fetching the posts
  ///will use pagenation method to fetch the posts the result will be saved in 'pagenationResult'
  ///with following attributes
  ///count indicates how much posts the system has
  ///next (url to fetch the next page) same as previous
  ///results (the actual list of posts)
  ///param [q] string that indicates the qurey to filter with (comming from 'search' method )

  Future<void> call() async {
    //when we can fetch more posts?
    // if the pagenation result is telling us that there's a next url & !=null
    if (_canFetchMore()) {
      //show loading (normal loading - pagenation loading - no loading)
      _emitLoadingState();

      //the use can return type is either so we will check for the faliure and succes
      await Services.getData(pageNumber: "$_nextPageNumber")
          .then((value) => _emitFetchingSuccessState(value));
    }
  }

  ///after fetching the posts succefully we will emit a success state
  ///if we fetch the posts succefully then we will emit 'PostsSuccessState'
  ///
  ///1-just in case we found that no next url that means that those were the last posts so will emit
  ///'PostsSuccessAllCaughtState' to notify the ui not making any other requests will scrolling and
  ///show the specific widget for all caught state
  ///
  ///2-if all ended well but there is no data we will emit 'PostsSuccessNoPostsState'
  ///to notify the ui that it should display no data found widget

  void _emitFetchingSuccessState(List<PostModel> posts) {
    emit(PostsSuccessState());
    if (posts.isEmpty) {
      //if there is no other posts then emit the last state which
      // indicates that there's no other call can be done
      if (_nextPageNumber == 1) {
        emit(PostsSuccessAllCaughtState());
      } else {
        emit(PostsSuccessNoPostsState());
      }
    } else {
      this.posts?.addAll(posts);
      _nextPageNumber++;
    }
  }

  ///if the [pagenationResult] variable is null it means that this is the first fetch for the data so will show the normal loading
  ///else this means that we will show the loading after the existing comments as pagenation loading
  void _emitLoadingState() {
    if (posts == null) {
      emit(PostsLoadingState());
    } else {
      emit(PostsPagentationLoadingState());
    }
  }

  // if the state is not (all caught state) then we can fetch
  bool _canFetchMore() => state is! PostsSuccessAllCaughtState;
}
