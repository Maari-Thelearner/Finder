import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:finder/wordsaver.dart';
//final Dbreference = FirebaseFirestore.instance.collection('users');
class Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {

  final ref = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90.0,
        title: Text('Words Saver',style: TextStyle(fontSize: 25.0),),
        centerTitle: true,
        elevation: 20.0,
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(icon: Icon(Icons.delete,color: Colors.red,size: 30.0,),
            onPressed: (){
            showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text('Are you sure want to delete the all your content'),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red[400])
                          ),
                          onPressed: (){
                        ref.get().then((snapshot) {
                          for(DocumentSnapshot doc in snapshot.docs){
                            doc.reference.delete();
                          }
                        }
                        ).then((value) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red[400],
                            elevation: 15.0,
                            content:  Text('All Data Deleted Successfully!',style: TextStyle(color: Colors.white),),
                          ),
                        )).then((value) => Navigator.pop(context));
                      }, child: Text('Yes')),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.amber)
                          ),
                          onPressed: (){
                        Navigator.pop(context);
                      }, child: Text('No')),
                    ],
                  ),
                );
              }
            );
            },
      )

        ],
      ),
      body:StreamBuilder(
        stream: ref.snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      return ListView.builder(
        itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
        itemBuilder: (_,index){
          return GestureDetector(
            onTap: (){
              Navigator.push(context,
                  PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 200),
                      transitionsBuilder:(context,animation,animationTime,child){
                        return ScaleTransition(
                          alignment: Alignment.center,
                          scale:  animation,
                          child: child,
                        );
                      },
                      pageBuilder: (context,animation,animationTime){
                        return Details(docToEdit: snapshot.data.docs[index],);
                      }
                  )
              );
            },
            onLongPress: (){
              showDialog(context: context, builder: (_){
                return AlertDialog(
                  title: Center(child: Text('Word : \"${snapshot.data.docs[index].data()['word']}\"')),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: (){
                        Navigator.push(context,
                            PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 200),
                                transitionsBuilder:(context,animation,animationTime,child){
                                  return ScaleTransition(
                                    alignment: Alignment.center,
                                    scale:  animation,
                                    child: child,
                                  );
                                },
                                pageBuilder: (context,animation,animationTime){
                                  return Edit(docToEdit: snapshot.data.docs[index],);
                                }
                            )
                        );
                      }, child: Text('Edit')),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red[400])
                          ),
                          onPressed: (){
                        String id = snapshot.data.docs[index].id;
                        ref.doc(id).delete().then((value) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red[400],
                            elevation: 15.0,
                            content:  Text('One Data is Deleted!',style: TextStyle(color: Colors.white),),
                          ),
                        )).then((value) => Navigator.pop(context));
                      }, child: Text('Delete')),
                    ],
                  ),
                );
              });
            },
            child: Card(
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 20.0,
              color: index%2==0 ? Colors.white70 : Colors.white54,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Center(child: Text(snapshot.data.docs[index].data()['word'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Synonym:\n${snapshot.data.docs[index].data()['meaning'].toString()}",style: TextStyle(fontSize: 20.0),),
                          SizedBox(width: 50.0,),
                          Text("Tamil Meaning:\n${snapshot.data.docs[index].data()['tamil_meaning'].toString()}",style: TextStyle(fontSize: 20.0),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 200),
                  transitionsBuilder:(context,animation,animationTime,child){
                    return ScaleTransition(
                      alignment: Alignment.bottomRight,
                      scale:  animation,
                      child: child,
                    );
                  },
                  pageBuilder: (context,animation,animationTime){
                    return Wordsaver();
                  }
              )
          );
        },
        hoverColor: Colors.green[900],
        hoverElevation: 20.0,
        backgroundColor: Colors.greenAccent,
        child: Icon(Icons.add,color: Colors.black,),
      ),
    );
  }
}

class Edit extends StatefulWidget {
  DocumentSnapshot docToEdit;
  Edit({this.docToEdit});
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final TextEditingController word = new TextEditingController();
  final TextEditingController mean = new TextEditingController();
  final TextEditingController Tamil = new TextEditingController();
  final TextEditingController examples = new TextEditingController();
  final editkey = new GlobalKey<FormState>();
  final ref = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    word.text = widget.docToEdit.data()['word'];
    Tamil.text = widget.docToEdit.data()['tamil_meaning'];
    mean.text = widget.docToEdit.data()['meaning'];
    examples.text = widget.docToEdit.data()['example'];
    return Scaffold(
      appBar: AppBar(
        elevation: 20.0,
        toolbarHeight: 90.0,
        title: Text('Edit your word',style: TextStyle(fontSize: 25.0),),
        centerTitle: true,
      ),
     body: Form(
        key: editkey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: word,
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
                  controller: mean,
                  validator: (String value) {
                    if(value.isEmpty){
                      return 'Required';
                    }
                    return null;
                  },
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
                  controller: Tamil,
                  validator: (String value) {
                    if(value.isEmpty){
                      return 'Required';
                    }
                    return null;
                  },
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
                  controller: examples,
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
                    if(editkey.currentState.validate())
                    {
                        widget.docToEdit.reference.update({
                          'word': word.text,
                          'tamil_meaning': Tamil.text,
                          'meaning': mean.text,
                          'example': examples.text,
                        }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.blue,
                            elevation: 20.0,
                            content:  Text('Data Edited Successfully!',style: TextStyle(color: Colors.white),),
                          ),
                        ));
                    }
                  },child: Text('Edit'),color: Colors.blue,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Details extends StatefulWidget {
  DocumentSnapshot docToEdit;
  Details({this.docToEdit});
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 90.0,
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        backgroundColor: Colors.amber,
        title: Text('Knowledge is Power',style: TextStyle(color: Colors.black,fontSize: 25.0),),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: Center(child: Text(widget.docToEdit.data()['word'],style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
            ),
            ListTile(
              title: Text('Meaning : ${widget.docToEdit.data()['meaning']}',style: TextStyle(fontSize: 25.0),),
            ),
            ListTile(
              title: Text('Tamil meaning : ${widget.docToEdit.data()['tamil_meaning']}',style: TextStyle(fontSize: 25.0),),
            ),
            SizedBox(
              height: 20.0,
            ),
            ListTile(
              title: Center(child: Text('Examples'),),
              subtitle: Text(widget.docToEdit.data()['example'],textAlign: TextAlign.justify,style: TextStyle(fontSize: 25.0),),
            ),
            SizedBox(height: 30.0,),
            ListTile(
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.push(context,
                          PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 200),
                              transitionsBuilder:(context,animation,animationTime,child){
                                return ScaleTransition(
                                  alignment: Alignment.center,
                                  scale:  animation,
                                  child: child,
                                );
                              },
                              pageBuilder: (context,animation,animationTime){
                                return Edit(docToEdit: widget.docToEdit,);
                              }
                          )
                      );
                    }, child: Text('Edit')),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red[400])
                        ),
                        onPressed: (){
                          String id = widget.docToEdit.id;
                          FirebaseFirestore.instance.collection('users').doc(id).delete().then((value) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red[400],
                              elevation: 15.0,
                              content:  Text('One Data is Deleted!',style: TextStyle(color: Colors.white),),
                            ),
                          )).then((value) => Navigator.pop(context));
                        }, child: Text('Delete')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
