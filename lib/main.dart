import 'package:flutter/material.dart';
import 'package:flutter_list_sample/views/video_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyListApp());

class MyListApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyListState();
  }

}

class MyListState extends State<MyListApp>{
  var isRefreshed = true;
  var videos;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text("List Sample"),
              actions: <Widget>[
                new IconButton(icon: new Icon(Icons.refresh), onPressed: () {
                  print("Loading");
                  setState(() {
                    isRefreshed = true;
                  });

                  _fetchData();
                })
              ],
            ),

            body: new Center(child: isRefreshed ? new CircularProgressIndicator() :
            new ListView.builder(
                itemCount: this.videos != null ? this.videos.length : 0 ,
                itemBuilder: (context, i){

                  final video = this.videos[i];
                  return new FlatButton(
                    padding: new EdgeInsets.all(0.0),
                      child: new VideoItem(video),
                      onPressed: (){
                        print("clicked $i");
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => new SecondPage()
                        )
                        );
                      },
                  );
                }

            )
            )
        )
    );
  }


  void _fetchData() async {
    print("fetching data....");

    final url = "https://api.letsbuildthatapp.com/youtube/home_feed";
    final response = await http.get(url);

    if(response.statusCode == 200){
      print(response.body);

      final map = jsonDecode(response.body);
      final videoJason = map["videos"];

      setState(() {
        isRefreshed = false;
        this.videos = videoJason;
      });
    }
  }
}


class SecondPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(title: new Text("Detial page")),
        body: new Center(child: new Text("Details goes here...")),
      ),
    );
  }
}
