import 'package:flutter/material.dart';
import 'package:sars_cov_two_info/src/controllers/home_controller.dart';
import 'package:sars_cov_two_info/src/util/date_to_number_days.dart';
import '../controllers/historical_graphic_controller.dart';

class StateManagement extends StatefulWidget {
  @override
  State<StateManagement> createState() {
    return TelaPrincipalState();
  }
}
class TelaPrincipalState extends State<StateManagement> {
  final controller = HomeController();
  bool loudedGrephic = false;
  @override
  void initState() {
    controller.start();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sars Cov 2 info',
          style: TextStyle(
            color: Color.fromRGBO(154, 69, 33, 1.0),
            fontWeight: FontWeight.bold,
          )
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_outlined),
            onPressed: () {
              restart();
            },
          ),
        ]
       // actions: [SwitchTheme(),],
      ),
      body: AnimatedBuilder(
              animation:
              controller.state,
              builder: (context, child) {
                return stateManagement(controller.state.value);
              },
            ),
    );
  }
  Widget buildCard(it) => SizedBox(
    width: 200,
      child:
        Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(149, 206, 157, 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          padding: const EdgeInsets.all(15),
          width: 200,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  width: 200,
                  child: Text("Cases ${controller.historicalCountry.timeline!.cases[it]}",
                    style: TextStyle(color: Color.fromRGBO(2, 110, 60, 1.0), fontSize: 18, fontWeight: FontWeight.bold ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  width: 200,
                  child: Text(controller.historicalCountry.timeline!.dayCases[it],
                    style: TextStyle(color: Color.fromRGBO(154, 69, 33, 1.0), fontSize: 18, fontWeight: FontWeight.bold ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  width: 200,
                  child: Text("Recovered ${controller.historicalCountry.timeline!.recovered[it]}",
                    style: TextStyle(color: Color.fromRGBO(2, 110, 60, 1.0), fontSize: 18, fontWeight: FontWeight.bold ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  width: 200,
                  child: Text(controller.historicalCountry.timeline!.dayRecovereds[it],
                    style: TextStyle(color: Color.fromRGBO(154, 69, 33, 1.0), fontSize: 18, fontWeight: FontWeight.bold ),
                  ),
                ),
              ],
            ),
          ),
        ),
  );

  _start(){
    return Container();
  }

  _loading(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _sucess(){
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(15,20,15,15),
          child: Center(
            child:
              Text(controller.historicalCountry.country!,
                style: TextStyle(color: Color.fromRGBO(154, 69, 33, 1.0), fontSize: 22, fontWeight: FontWeight.bold ),
              ),
          ),
        ),
        Card(
          margin: EdgeInsets.only(left: 16, right: 16),
          elevation: 10,
          child: HistoricalGraphic(controller.historicalCountry).getGraphic(),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.historicalCountry.timeline!.cases.length,
            separatorBuilder: (context, _) => SizedBox(width: 12,),
            itemBuilder: (context, index) => buildCard(index),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 15, left: 295, right: 16),
          child:
            FloatingActionButton(
              backgroundColor: Color.fromRGBO(154, 69, 33, 1.0),
              child: Icon(
                Icons.search,
                color: Color.fromRGBO(225, 180, 163, 1.0),
              ),
              onPressed: (){
                showDialogWithFields();
              }),
        )
      ],
    );
  }

  _error(){
    return Center(
      child: ElevatedButton(onPressed: (){
        restart();
      },
        child: Text('Try again'),),
    );
  }
  void showDialogWithFields() {
    showDialog(
      context: context,
      builder: (_) {
        var countryController = TextEditingController();
        var dateStartController = TextEditingController();

        return AlertDialog(
          title: Text('Research:', style: TextStyle(color: Color.fromRGBO(154, 69, 33, 1.0))),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Color.fromRGBO(149, 206, 157, 1.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [              
              TextFormField(
                controller: countryController,
                decoration: InputDecoration(
                  hintText: 'Country',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(154, 69, 33, 1.0)
                  )
                ),
              ),
              TextFormField(
                controller: dateStartController,
                decoration: InputDecoration(
                  hintText: 'Initial date',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(154, 69, 33, 1.0)
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Color.fromRGBO(154, 69, 33, 1.0))),
            ),
            TextButton(
              onPressed: () { 

                var country = countryController.text;
                var dateInitial = dateStartController.text;

                if(country.isNotEmpty){
                  if(verifyDate(dateInitial)){
                    controller.country = country;
                    controller.lastdays = DateToNumberDays(dateInitial).numberDays();
                    Navigator.pop(context);
                    controller.start();
                  }else{
                    Navigator.pop(context);
                    showMaterialBannerDate();
                  }
                }else{
                  Navigator.pop(context);
                  showMaterialBannerCountry();
                }
              },
              child: Text('Research', style: TextStyle(color: Color.fromRGBO(154, 69, 33, 1.0))),
            ),
          ],
        );
      },
    );
  }
  showMaterialBannerCountry(){
    ScaffoldMessenger.of(context)..removeCurrentMaterialBanner()..showMaterialBanner(
      MaterialBanner(
        content: const Text('Complete the text field correctly!', style: TextStyle(color: Color.fromRGBO(154, 69, 33, 1.0))),
        leading: const Icon(Icons.info),
        backgroundColor: Colors.tealAccent,
        actions: [
          TextButton(onPressed: (){
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            showDialogWithFields();
          }, child: const Text('Close')),
        ],
      )
    );
  }
  showMaterialBannerDate(){
    ScaffoldMessenger.of(context)..removeCurrentMaterialBanner()..showMaterialBanner(
        MaterialBanner(
          content: const Text('Enter the date in the format dd/MM/yyyy.', style: TextStyle(color: Color.fromRGBO(154, 69, 33, 1.0))),
          leading: const Icon(Icons.info),
          backgroundColor: Colors.tealAccent,
          actions: [
            TextButton(onPressed: (){
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              showDialogWithFields();
            }, child: const Text('Close')),
          ],
        )
    );
  }
  restart(){
    controller.country = "brasil";
    controller.lastdays = '31';
    controller.start();
  }
  bool verifyDate(String date){

    for(int i = 0; i < 10; i++ ) {
      date = date.replaceAll(i.toString(), "*");
    }
    return (date == "**/**/****");
  }
  stateManagement(HOME_STATE state){
    switch(state){
      case HOME_STATE.start:
        return _start();//start, loading, sucess, error
      case HOME_STATE.loading:
        return _loading();
      case HOME_STATE.sucess:
        return _sucess();
      case HOME_STATE.error:
        return _error();
      }
  }
}
