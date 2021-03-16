import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
final TextEditingController wordname = new TextEditingController();
final TextEditingController synonym = new TextEditingController();
final TextEditingController tamil = new TextEditingController();
final TextEditingController example = new TextEditingController();
class Wordsaver extends StatefulWidget {
  @override
  _WordsaverState createState() => _WordsaverState();
}

class _WordsaverState extends State<Wordsaver> {
  final saverkey = new GlobalKey<FormState>();
 CollectionReference users = FirebaseFirestore.instance.collection('users');



    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        toolbarHeight: 90.0,
        backgroundColor: Colors.greenAccent,
        title: Text('Save your word!',style: TextStyle(color: Theme.of(context).accentColor),),
        centerTitle: true,
      ),
      body: Form(
        key: saverkey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: wordname,
                  validator: (String value) {
                    if(value.isEmpty){
                      return 'Required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    //  prefixIcon: Icon(Icons.system_update_alt,color: CustomTheme.of(context).accentColor,),
                    filled: true,
                    labelText: 'Word',
                    hintText: 'Enter the Word',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).accentColor,),
                      borderRadius: BorderRadius.all(Radius.circular(30)),

                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: synonym,
                  decoration: InputDecoration(
                    //  prefixIcon: Icon(Icons.system_update_alt,color: CustomTheme.of(context).accentColor,),
                    filled: true,
                    labelText: 'Synonym',
                    hintText: 'Enter the Meaning of the word',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).accentColor,),
                      borderRadius: BorderRadius.all(Radius.circular(30)),

                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: tamil,
                  decoration: InputDecoration(
                    //  prefixIcon: Icon(Icons.system_update_alt,color: CustomTheme.of(context).accentColor,),
                    filled: true,
                    labelText: 'Tamil Meaning',
                    hintText: 'Enter tamil word of the given word',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).accentColor,),
                      borderRadius: BorderRadius.all(Radius.circular(30)),

                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value){
                    if(value.isEmpty){
                      return 'Required';
                    }
                    return null;
                  },
                  controller: example,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    //  prefixIcon: Icon(Icons.system_update_alt,color: CustomTheme.of(context).accentColor,),
                    filled: true,
                    labelText: 'Example',
                    hintText: 'Enter Example Sentence of the given word',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).accentColor,),
                      borderRadius: BorderRadius.all(Radius.circular(30)),

                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                MaterialButton(
                  height: 50,
                  minWidth: 150,
                  onPressed: (){
                    if(saverkey.currentState.validate())
                      {
                        users.add({
                          'word' : wordname.text,
                          'meaning': synonym.text,
                          'tamil_meaning': tamil.text,
                          'example': example.text,
                        }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green[900],
                            elevation: 20.0,
                            content:  Text('Saved Successfully!',style: TextStyle(color: Colors.white),),
                          ),
                        ));
                        wordname.clear();
                        synonym.clear();
                        tamil.clear();
                        example.clear();
                      }
                  },child: Text('Save'),color: Colors.green,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
