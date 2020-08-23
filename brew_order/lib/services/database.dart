import 'package:brew_order/models/brew.dart';
import 'package:brew_order/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  
  final String uid;
  DatabaseService({this.uid});

  //collection references
  final CollectionReference brewCollection = Firestore.instance.collection('brews');
  
  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({   //contains propertied of different values insife firestore
      'sugars': sugars,
      'name': name,
      'strength': strength,

    });
  }

  //brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Brew(
        name: doc.data['name'] ?? '', 
        sugars: doc.data['sugars'] ?? '0',
        strength:doc.data['strength'] ?? 0 
      );
    }).toList();
  }

  //userdata from snapshot

UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
  return UserData(
    uid: uid,
    name: snapshot.data['name'],
    sugars: snapshot.data['sugars'],
    strength: snapshot.data['strength']
  );
}

  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots()
    .map(_brewListFromSnapshot);
  }


  //get user doc Stream
  Stream<UserData> get userData{
    return brewCollection.document(uid).snapshots()
    .map(_userDataFromSnapshot);
  }

}