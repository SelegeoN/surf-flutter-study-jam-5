import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    height: 240,width: 160,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context)
                          .pushNamed('/demotivator_page');
                    },
                    child: Card(
                      color: Colors.grey,
                      child: Column(
                        children: [
                          SizedBox(height: 200,width: 130,child: Image.asset('lib/assets/demotivator_example.png')),
                          Text('Демотиватор'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 240,width: 160,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context)
                          .pushNamed('/livsey_page');
                    },
                    child: Card(
                      color: Colors.grey,
                      child: Column(
                        children: [
                          SizedBox(height: 200,width: 130,child: Image.asset('lib/assets/flutter_mem.png')),
                          Text('Ливси'),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
