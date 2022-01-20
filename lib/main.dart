import 'package:flutter/material.dart';
import 'dart:convert';
import 'detailPage.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Resep{
  final String nama, resep, gambar;

  Resep(this.nama, this.resep, this.gambar);
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getResepData()async{
    var response = 
      await http.get(Uri.https('secure-reaches-32632.herokuapp.com', '/api/food'));
    var jsonData = jsonDecode(response.body);
    List<Resep> reseps = [];

    for(var r in jsonData){
      Resep makanan = Resep(r['nama'], r['resep'], r['gambar']);
      reseps.add(makanan);
    }
    print(reseps.length);
    return reseps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        SizedBox(height: 20.0),
        Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.autorenew),
                color: Colors.black,
                onPressed: (){
                  getResepData();
                },
              ),
              Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    image: DecorationImage(
                        image: AssetImage('assets/avocado.png'),
                        fit: BoxFit.cover)),
              )
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Hello!',
                  style: TextStyle(
                      fontFamily: 'Futur',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5B8842),
                      fontSize: 50.0)
              ),
              SizedBox(height: 20.0),
              Text('Popular Food',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0))
            ],
          ),
        ),
        SizedBox(height: 7.0),
        Container(
          height: 250.0,
          child: Card(child: FutureBuilder(
            future: getResepData(),
            builder: (context, snapshot){
              if(snapshot.data==null){
                return Container(child: Center(child: Text('Loading..'),),);
              } else
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i){
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/plate1.png'),
                    ),
                    title: Text(snapshot.data[i].nama),
                    subtitle: Text('Read More...'),
                  );
                });
            },
            ),
          ),
          // child: ListView(
          //   scrollDirection: Axis.horizontal,
          //   children: <Widget>[
          //     _buildListItem('assets/plate1.png', 'Vegan Breakfast', ''),
          //     _buildListItem('assets/plate2.png', 'Protein Salad', ''),
          //     _buildListItem('assets/plate6.png', 'Sirloin Steak', ''),
          //   ],
          // ),
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text('Best Food',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0)) 
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            height: 200.0,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFFACBEA3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                    image: AssetImage('assets/plate4.png'),
                    fit: BoxFit.contain)),
          ),
        ),
        SizedBox(height: 20.0),
      ],
    ),
    // bottomNavigationBar: Container(     
    //   height: 75,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.only(
    //       topRight: Radius.circular(30),
    //       topLeft: Radius.circular(30)),
    //   ),
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.only(
    //     topLeft: Radius.circular(30.0),
    //     topRight: Radius.circular(30.0),
    //     ),
    //     child: BottomNavigationBar(
    //       backgroundColor: Color(0xFF5AC035),
    //       items: <BottomNavigationBarItem>[
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.favorite), title: Text('Favourite')),
    //         BottomNavigationBarItem(                                               
    //           icon: Icon(Icons.favorite), title: Text('Favourite'))
    //       ],                                                                       
    //     ),                                                                         
    //   )                                                                            
    // ),
    bottomNavigationBar: Container(
      height: 75.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0)
        ),
        color: Color(0xFF5AC035)
      ),
      padding: EdgeInsets.only(left: 40.0, right: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.bookmark_border, color: Colors.white),
            Icon(Icons.search, color: Colors.white),
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.person_outline, color: Colors.white),
          ],
        ),
    ),
    );
  }

  Widget _buildListItem(String imgPath, String foodName, String price) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push((MaterialPageRoute(
          builder: (context) => DetailsPage(heroTag: imgPath, foodName: foodName, foodPrice: price)
        )));
      },
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
        child: Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 6.0,
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5.0)
                ]),
          child: Stack(
            children: <Widget>[
              Container(
                height: 175.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFFACBEA3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)
                  )
                )
              ),
              Hero(
                tag: imgPath,
                child: Container(
                  height: 175.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imgPath),
                      fit: BoxFit.contain
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)
                    )
                  ),
                )
              ),
              Positioned(
                top: 160.0,
                right: 20.0,
                child: Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    height: 30.0,
                    width: 30.0,
                    child: Center(
                      child: Icon(Icons.favorite, color: Colors.red, size: 17.0)
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white
                    ),
                  )
                )
              ),
              Positioned(
                top: 190.0,
                left: 10.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(foodName,
                      style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 14.0)),
                    SizedBox(height: 3.0),
                    Container(
                      width: 175.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                      '4.9',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.grey,
                                          fontSize: 12.0),
                                    ),
                              SizedBox(width: 3.0),
                                Icon(Icons.star,
                                    color: Colors.green, size: 14.0),
                                Icon(Icons.star,
                                    color: Colors.green, size: 14.0),
                                Icon(Icons.star,
                                    color: Colors.green, size: 14.0),
                                Icon(Icons.star,
                                    color: Colors.green, size: 14.0),
                                Icon(Icons.star,
                                    color: Colors.green, size: 14.0),
                            ],
                          ),
                          Text(price,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 16.0)),      
                        ],
                      )
                    )
                  ],
                )
              )
            ],
          )
        )
      )
    );
  }
}
