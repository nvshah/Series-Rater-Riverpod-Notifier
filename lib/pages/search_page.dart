import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/providers.dart';
import '../logic/series_notifier.dart';

import '../data/models/series.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Series Search"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: ProviderListener<SeriesState>(
          //NOTE - here state property is used as providr & not out custom seriesNotifierProvider itself
          provider: seriesNotifierProvider.state,
          onChange: (context, state) {
            if (state is SeriesError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: Consumer(
            builder: (context, watch, child) {
              //Note here we're watching state of stateNotifier & not notifier itself
              // .state itself is kida provider i.e internal provider managed by state-notifier
              final state = watch(seriesNotifierProvider.state);
              if (state is SeriesInitial) {
                return buildInitialInput();
              } else if (state is SeriesLoading) {
                return buildLoading();
              } else if (state is SeriesLoaded) {
                return buildColumnWithData(state.series);
              } else {
                //(state is SeriesError)
                return buildInitialInput();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: InputField(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(Series series) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          series.name,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the ratings with 1 decimal place
          "${series.ratings.toStringAsFixed(1)} <--#",
          style: TextStyle(fontSize: 80),
        ),
        InputField(),
      ],
    );
  }
}

class InputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (value) => submitName(context, value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  //submit name to get ratings
  void submitName(BuildContext context, String name) {
    context.read(seriesNotifierProvider).getRatings(name);
  }
}
