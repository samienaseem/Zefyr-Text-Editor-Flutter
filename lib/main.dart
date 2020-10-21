import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zefyr_text_editor/DBHelper/DBHelper.dart';
import 'package:zefyr_text_editor/Model/SavedNotes.dart';

import 'EditorPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DBHelper dbHelper=new DBHelper();
  int count=0;
  List<SavedNotes> list;//to store savednotes object return from database
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(list==null){
      list=List<SavedNotes>();
      getData();
    }

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Container(
        padding:EdgeInsets.all(10.0),
        child: GetListData(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          bool result=await Navigator.push(context, MaterialPageRoute(builder: (context)=>EditorPage(new SavedNotes(""))));

          if(result==true){
            getData();
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void getData() {
    final dbfuture=dbHelper.initDatabase(); //return manager
    dbfuture.then((result){
      final Notes=dbHelper.getNotes(); // return list
      Notes.then((result){
        List<SavedNotes> tempList=List<SavedNotes>();
        int count=result.length;
        for(int i=0;i<count;i++){
          tempList.add(SavedNotes.FromObject(result[i])); //result[0] have id and content returned from db in the form of map.
        }
        setState(() {
          list=tempList;
          this.count=count;
          //assign temp list to main list.
        });
      });
    });
  }

 ListView GetListData() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (context,position){
          return Card(
            elevation: 4.0,
            child: Container(
              child: ListTile(
                title: Text((this.list[position].id).toString()),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute( builder: (context)=>EditorPage(this.list[position])));
                },
              ),
            ),
          );
        }
    );
 }
}
