

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'content.dart';

//final DBreference=FirebaseDatabase.instance.reference();
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
 // Stream collectionStream = FirebaseFirestore.instance.collection('users').snapshots();
  //Stream documentStream = FirebaseFirestore.instance.collection('users').doc('ABC123').snapshots();
 // CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference ref = FirebaseFirestore.instance.collection('url');
  final TextEditingController urlcontroller = new TextEditingController(text: 'https://');
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            return ListView.builder(
                itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
                itemBuilder: (_,index){
                 if(index==0){
                   String id =snapshot.data.docs[index].id;
                   urlcontroller.text = snapshot.data.docs[index].data()['url'];
                   return Container(
                     margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height*0.5, 0, 0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Container(
                           height: 50.0,
                           width: 150.0,
                           child: ElevatedButton(
                             style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue[800]),
                               mouseCursor: MaterialStateMouseCursor.clickable,
                             ),
                               onPressed: (){
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
                                       return Content();
                                     }
                                 )
                             );
                           }, child: Text('WordSaver')),
                         ),
                         Container(
                           height: 50.0,
                           width: 150.0,
                           child: ElevatedButton(
                               onLongPress: (){
                                 showDialog(context: context, builder: (context){
                                   return Form(
                                     key: formkey,
                                     child: AlertDialog(
                                       title: Text('Custom URL'),
                                       content:
                                       TextFormField(
                                         controller: urlcontroller,
                                         validator: (String value) {
                                           if(!value.contains('https')){
                                             return 'https link only be allow';
                                           }
                                           return null;
                                         },
                                         decoration: InputDecoration(
                                           //  prefixIcon: Icon(Icons.system_update_alt,color: CustomTheme.of(context).accentColor,),
                                           filled: true,
                                           labelText: 'Url',
                                           hintText: 'Enter your website link',
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
                                       actions: [
                                         MaterialButton(onPressed: (){
                                           if(formkey.currentState.validate()){

                                            ref.doc(id).set({
                                              'url' : urlcontroller.text.trim(),
                                            });
                                          Navigator.pop(context);
                                           }
                                         },child: Text('Save'),color: Colors.green,),
                                       ],
                                     ),
                                   );
                                 });
                               },
                               style: ButtonStyle(
                                 backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue[800]),
                                 mouseCursor: MaterialStateMouseCursor.clickable,
                               ),
                               onPressed: ()async{
                                 var _url = snapshot.data.docs[index].data()['url'];
                                 await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                               }, child: Text('Web')),
                         ),
                       ],
                     ),
                   );
                 }
                 return Text('End..');
                });
          },
        ),
      ),
    );
  }
}



