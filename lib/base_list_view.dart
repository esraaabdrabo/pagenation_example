import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
///reusable  ListView.separated widget that is wrapped with 'Expanded' and 'BlocBuilder' widgets
///first of all the widget will take the cubit type , it's states and the model data type so in what we will use those?
///the cubit and it's states will be given to  BlocBuilder as  BlocBuilder<B, States>
///and the model data type wil be used in the widget param  'items' to indicate that this is a list of what like if the
///DataType is String then we will know thatthe items is a List<String>
///
///param :
///[init] is a function that will be passed to the initState override in fact this function will start the listening process on the controller
///this function should be passed as a parameter because it will make the cubit call the fetching method .
///[isLoading] is a bool variable that is necessary to be used in the item builder method to show the '_LoadingWidget'
///whenever we need
///[allCaught] is a bool variable that is necessary to be used in the item builder method to show the 'AllCaughtUpWidget'
///whenever we need (used when there is no other data to fetch [when the next == null])
///[items] are a list<DataType>
///[childBuilder] is a function takes int as the index of the child and return custom widget for every screen
///[controller] is a ScrollController used by the listview.builder to be it's controller (attach the controller to any list you wanna listen to
///it on scrolling ) , this controller will be disposed after not being used
///[padding] (nullable and not required) is an EdgeInsetsGeometry type is passed to the listview.builder padding in order to controll how much padding we want
class PagenatedListView<B extends StateStreamable<States>, States, DataType>
    extends StatefulWidget {
  final Function() init;
  final bool isLoading, allCaught;
  final List<DataType> items;
  final Widget Function(int index) childBuilder;
  final ScrollController controller;
  final EdgeInsetsGeometry? padding;
  const PagenatedListView(
      {required this.init,
      required this.controller,
      required this.items,
      required this.childBuilder,
      required this.allCaught,
      required this.isLoading,
      this.padding,
      super.key});

  @override
  State<PagenatedListView<B, States, DataType>> createState() =>
      _PagenatedListViewState<B, States, DataType>();
}

class _PagenatedListViewState<B extends StateStreamable<States>, States,
    DataType> extends State<PagenatedListView<B, States, DataType>> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.init();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        //the parent is bloc builder with the passed bloc & states types
        //we are using this here to rebuild the widget whenever a new state has been emitted
        child: BlocBuilder<B, States>(builder: (context, state) {
      return ListView.separated(
          //attach the scroll controller in order to listen on it
          controller: widget.controller,
          //leave a 2.h vertical space between every item
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          padding: widget.padding ??
              EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                //return a specific widget for every screen
                widget.childBuilder(index),
                //is this is the last item on the cureent data , a pagenation may happen if the next has value
                //so the widget must has 'isLoading' equal to true and the '_LoadingWidget' must appear
                //if there's no value for next variable it will be null then the cubit will emit a state which is all caught state
                //and the  widget must has 'allCaught' equal to true so that the 'AllCaughtUpWidget' appear
                if (_isLastItem(index))
                  Column(
                    children: [
                      //show loading to indicate the user that we are fetching another posts for him
                      if (widget.isLoading) const _LoadingWidget(),

                      if (widget.allCaught) const _AllCaughtUpWidget()
                    ],
                  )
              ],
            );
          });
    }));
  }

  bool _isLastItem(int index) => index == widget.items.length - 1;
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: const CircularProgressIndicator(),
        ),
      );
}

class _AllCaughtUpWidget extends StatelessWidget {
  const _AllCaughtUpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Text("end"),
    );
  }
}
