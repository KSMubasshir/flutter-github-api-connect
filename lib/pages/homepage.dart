import 'package:flutter/material.dart';
import 'package:github_api_connect/models/gitusersmodel.dart';
import 'package:github_api_connect/services/api_manager.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<gitUserModel> _gitUserModel;

  @override
  void initState() {
    _gitUserModel = API_Manager().getUserDetails('KSMubasshir');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Github'),
      ),
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
                    SizedBox(width: 16),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
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
            } else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
