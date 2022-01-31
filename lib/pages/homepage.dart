import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:github_api_connect/models/gitusersmodel.dart';
import 'package:github_api_connect/services/api_manager.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Search Bar Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SearchBarDemoHome());
  }
}

class SearchBarDemoHome extends StatefulWidget {
  const SearchBarDemoHome({Key? key}) : super(key: key);

  @override
  _SearchBarDemoHomeState createState() => _SearchBarDemoHomeState();
}

class _SearchBarDemoHomeState extends State<SearchBarDemoHome> {
  late SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<gitUserModel> _gitUserModel  = API_Manager().getUserDetails('KSMubasshir');

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: const Text('Github'),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    setState(() => _scaffoldKey.currentState
        ?.showSnackBar(SnackBar(content: Text('You wrote $value!'))));
    _gitUserModel  = API_Manager().getUserDetails(value);
  }

  _SearchBarDemoHomeState() {
    searchBar = SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          if (kDebugMode) {
            print("cleared");
          }
        },
        onClosed: () {
          if (kDebugMode) {
            print("closed");
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: searchBar.build(context),
        key: _scaffoldKey,
        body: Container(
          child: FutureBuilder<gitUserModel>(
            future: _gitUserModel,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                String avatar = '';
                if (snapshot.data?.avatarUrl != null) {
                  avatar = snapshot.data!.avatarUrl!;
                }
                String name = '';
                if (snapshot.data?.name != null) {
                  name = snapshot.data!.name!;
                }
                String company = '';
                if (snapshot.data?.company != null) {
                  company = snapshot.data!.company!;
                }
                return Container(
                  height: 100,
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    children: <Widget>[
                      Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              avatar,
                              fit: BoxFit.cover,
                            )),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              company,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        )
    );
  }
}

//
