import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagenation_example/controller/states.dart';
import 'package:pagenation_example/post_model.dart';
import 'package:pagenation_example/services.dart';

class PostsCubit extends Cubit<PostsStates> {
  PostsCubit(super.initialState);
  List<PostModel>? posts;
  int _nextPageNumber = 1;

  ///fetching the posts
  ///will use pagenation method to fetch the posts , the result will be saved in 'posts'

  Future<void> call() async {
    //when we can fetch more posts?
    // if the state is not 'PostsSuccessAllCaughtState'
    if (_canFetchMore()) {
      //show loading (normal loading - pagenation loading )
      _emitLoadingState();
      await Services.getData(pageNumber: "$_nextPageNumber")
          .then((value) => _emitFetchingSuccessState(value));
    }
  }

  ///after fetching the posts succefully we will emit a success state
  ///if we fetch the posts succefully then we will emit 'PostsSuccessState'
  ///
  ///1-just in case we found that no posts was fetched and the '_nextPageNumber' is not equal to 1
  /// that means that those were the last posts so will emit a new state =>
  ///'PostsSuccessAllCaughtState' to notify the ui not making any other requests will scrolling and
  ///show the specific widget for all caught state
  /// but if the '_nextPageNumber' is equal to 1 that means that there are no posts

  ///2-if all ended well but there is no data we will emit 'PostsSuccessNoPostsState'
  ///so the cubit will emit a new state => 'PostsSuccessNoPostsState' indicates that the backend has no data right now
  ///so the ui will be notified to show the no data widget

  ///if the api call returned data then we need to
  ///1 add the new data to the old one by calling 'addAll' method
  ///this will happen only if the posts not equal to null (means that we have started the pagenation)
  ///2 assign the posts to the cubit's posts list
  ///(only if the posts is equal to null that means that this call is the first one)
  ///as the last step we will update the '_nextPageNumber' so the next time the listener function is calling
  ///the cubit's call method that pagenation will get the next page
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
      if (this.posts == null) {
        this.posts = posts;
      } else {
        this.posts!.addAll(posts);
      }
      _nextPageNumber++;
    }
  }

  ///if the [posts] variable is null it means that this is the first fetch for the data so will show the normal loading
  ///else this means that we will show the loading after the existing posts as pagenation loading
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
