import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(
      MaterialApp(
          home:
          MyApp()
      )
  );
}

// Stateful Widget

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var contactList = <Contact>[];
  var likeList = <int>[];
  void addName (name) {
    var newName = new Contact();
    newName.givenName = name;
    ContactsService.addContact(newName);
    getPermissionContact();
  }
  void deleteName (name) {
    ContactsService.deleteContact(name);
  }
  void getPermissionContact() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('granted');
      var contacts = await ContactsService.getContacts();
      setState(() {
        contactList = contacts;
      });
    } else if (status.isDenied) {
      print('denied');
      Permission.contacts.request();
    }
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(context: context, builder: (context) {
            return userDialog(addName: addName);
          });
        },
      ),
      appBar: AppBar(
          title: Text('연락처 ' + contactList.length.toString() + '명'),
        actions: [
          IconButton(onPressed: () {
            getPermissionContact();
          }, icon: Icon(Icons.contacts))
        ],
      ),
      body: ListView.builder(
        itemCount: contactList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text((index + 1).toString()),
            title: Text(contactList[index].displayName.toString()),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                ),
                onPressed: () {
                  deleteName(contactList[index]);
                },
                child: Text('삭제')
            ),
          );
        }
      )
    );
  }
}

class userDialog extends StatefulWidget {
  userDialog({Key? key, this.addName}) : super(key: key);
  final addName;

  @override
  State<userDialog> createState() => _userDialogState();
}

class _userDialogState extends State<userDialog> {
  var inputData = '';

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text("Contact"),
        contentPadding: EdgeInsets.fromLTRB(24, 24, 24, 12),
        children: <Widget>[
          TextField(onChanged: (text) {
            inputData = text;
            print(inputData);
          },),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text("취소")),
                TextButton(onPressed: () {
                  if (inputData.length > 0) {
                    widget.addName(inputData);
                    Navigator.pop(context);
                  } else {
                    print(inputData == "");
                  }
                }, child: Text("생성")),
              ],
            ),
          )
        ]
    );
  }
}


// Flutter 기본 문법

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // home: Text('HelloWorld'),
//       // home: Icon(Icons.star),
//       // home: Image.asset('assets/DontLaugh.jpg'),
//       // home: Center(
//       //   child: Container(width: 50, height: 50, color: Colors.blue)
//       // )
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           title: const Text("방가방가"),
//           leading: const Icon(Icons.star),
//           actions: [
//             IconButton(
//                 icon: const Icon(Icons.search),
//                 onPressed: () {
//                   print("touch search");
//                 }),
//             IconButton(
//                 icon: const Icon(Icons.list),
//                 onPressed: () {
//                   print("touch list");
//                 }),
//             IconButton(
//                 icon: const Icon(Icons.notifications_none),
//                 onPressed: () {
//                   print("touch alarm");
//                 }),
//           ],
//         ),
//         body: Align(
//           alignment: Alignment.topCenter,
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity, height: 100,
//                 margin: const EdgeInsets.all(20),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: Colors.black26, width: 4),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.4),
//                       blurRadius: 5.0,
//                       spreadRadius: 0.0,
//                       offset: const Offset(0,7),
//                     )
//                   ]
//                 ),
//                 child: Column(
//                   children: const [
//                     Text('안녕하세요?',
//                       style: TextStyle(
//                         color: Color(0xff175495),
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 height: 160,
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 120,
//                       height: 120,
//                       margin: const EdgeInsets.all(20),
//                       decoration: const BoxDecoration(
//                         image: DecorationImage(
//                             fit: BoxFit.fill,
//                             image: AssetImage('assets/DontLaugh.jpg')
//                         ),
//                         borderRadius: BorderRadius.all(Radius.circular(8)),
//                         color: Colors.black
//                       ),
//                     ),
//                     Flexible(
//                       child: Container(
//                         margin: const EdgeInsets.fromLTRB(0, 20, 20, 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               "캐논 DSLR 100D (단렌즈, 충전기 16기가 SD 포함)",
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600
//                               ),
//                             ),
//                             const Text(
//                               "천안시 쌍용동 / 끌올 10분 전",
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                               style: TextStyle(
//                                 color: Colors.black45,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             const Text(
//                               "10,000원",
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 2,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w800
//                               ),
//                             ),
//                             SizedBox(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: const [
//                                   Icon(Icons.favorite_border,
//                                       size: 18,
//                                       color: Colors.black45),
//                                   Text('4', style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.black54
//                                   ),)
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 height: 50,
//                 child: Row(
//                   children: [
//                     Flexible(child: Container(color: Colors.blue), flex: 3,),
//                     Flexible(child: Container(color: Colors.green), flex: 5,),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 height: 50,
//                 child: Row(
//                   children: [
//                     Container(width: 200, color: Colors.blue,),
//                     Expanded(child: Container(color: Colors.green)),
//                   ],
//                 ),
//               ),
//               ElevatedButton(
//                   onPressed: () {
//                     print("Touch TextButton");
//                   },
//                   child: const Text("글자버튼11"),
//                   style: const ButtonStyle(
//                     backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
//                   )),
//               TextButton(onPressed: () {
//                 print("Touch TextButton");
//               }, child: const Text("글자버튼11")),
//             ],
//           ),
//         ),
//         // body: Row(
//         //   mainAxisAlignment: MainAxisAlignment.spaceEvenly, // display: flex
//         //   crossAxisAlignment: CrossAxisAlignment.center,
//         //   children: [
//         //     Icon(Icons.star),
//         //     Icon(Icons.star),
//         //     Icon(Icons.star),
//         //   ],
//         // ),
//         // body: Column(
//         //   mainAxisAlignment: MainAxisAlignment.spaceEvenly, // display: flex
//         //   crossAxisAlignment: CrossAxisAlignment.center,
//         //   children: [
//         //     Icon(Icons.star),
//         //     Icon(Icons.star),
//         //     Icon(Icons.star),
//         //   ],
//         // ),
//         bottomNavigationBar: BottomAppBar(
//           child: SizedBox(
//             height: 70,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 IconButton(
//                     icon: const Icon(Icons.phone),
//                     onPressed: () {
//                       print("touch phone");
//                     }),
//                 IconButton(
//                     icon: const Icon(Icons.message),
//                     onPressed: () {
//                       print("touch message");
//                     }),
//                 IconButton(
//                     icon: const Icon(Icons.contact_page),
//                     onPressed: () {
//                       print("touch contact_page");
//                     }),
//               ],
//             ),
//           )
//         ),
//       )
//     );
//   }
// }

