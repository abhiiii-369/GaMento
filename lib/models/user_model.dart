class UserModel {

String uid;

String name;

String email;

String photo;

int highestLevel;

String country;

String state;

UserModel({

required this.uid,
required this.name,
required this.email,
required this.photo,
required this.highestLevel,
required this.country,
required this.state

});

Map<String,dynamic> toMap(){

return{

'uid':uid,
'name':name,
'email':email,
'photo':photo,
'highestLevel':highestLevel,
'country':country,
'state':state

};

}

}