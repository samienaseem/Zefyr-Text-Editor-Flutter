import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:zefyr_text_editor/DBHelper/DBHelper.dart';
import 'package:zefyr_text_editor/Model/SavedNotes.dart';

DBHelper helper=DBHelper();
class EditorPage extends StatefulWidget{
  SavedNotes _savedNotes;
  EditorPage(this._savedNotes);
  @override
  State<StatefulWidget> createState()=>createNote(_savedNotes);

}

class createNote extends State{
  SavedNotes _notes;
  createNote(this._notes);

  ZefyrController _controller;
  FocusNode _focusNode;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Note"),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ZefyrScaffold(
          child: ZefyrEditor(
            padding: EdgeInsets.all(5.0),
            controller: _controller,
            focusNode: _focusNode,
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context){
          return FloatingActionButton(
            child: Icon(Icons.save),
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            onPressed: (){
              save();
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    final document=_loadDocument();
    _controller=ZefyrController(document);
    _focusNode=FocusNode();
  }

  NotusDocument _loadDocument(){
    if(_notes.id==null) {
      final Delta delta = Delta()..insert("Insert text here\n"); //import quill_delta
      return NotusDocument.fromDelta(delta);
    }
    else{
      return NotusDocument.fromJson(jsonDecode(_notes.content));
    }
  }

  void save() {
    final content=jsonEncode(_controller.document);
    debugPrint(content.toString());
    _notes.content=content;
    if(_notes.id!=null){
      //write update logic here
    }
    else{
      helper.insertNote(_notes);
    }
    Navigator.pop(context,true);
    //lets try to run it see if any error
    //exception is thrown because we never called initDatabase method of DBHelper class
    //Lets write some more code for that in main.dart .
  }
}