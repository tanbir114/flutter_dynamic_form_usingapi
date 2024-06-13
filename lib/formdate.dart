import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
class fromdata extends StatefulWidget {
  const fromdata({Key? key}) : super(key: key);

  @override
  _fromdataState createState() => _fromdataState();
}

class _fromdataState extends State<fromdata> {
  int ids =-1;
  List selectdata = List<String>.empty(growable: true);
  List radiotdata = List<String>.empty(growable: true);
  var url = Uri.parse('https://stoplight.io/mocks/khurramsoftware/data/20414976/getdata');

//getapidata
  apirequest() async {
    final response = await http.get(url) ;
    if(response.statusCode==200){
      final responsebody = json.decode(response.body);
      return responsebody;
    }
    else{
      print(response.reasonPhrase);
    }

  }
//dynamic row
  _row(int index, name,field_type,id,field_data){
    var _mySelection;
    field_type=="select"?selectdata=field_data:selectdata;
    field_type=="radio"?radiotdata=field_data:radiotdata;
    if(field_type=="select"){
      return Container(
        padding: const EdgeInsets.fromLTRB(28, 15, 28, 28),
        child: InputDecorator(
            decoration: InputDecoration(
              labelText: name,focusColor: Colors.blue,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrangeAccent),
                borderRadius: new BorderRadius.circular(10.0),
              ),
              border: OutlineInputBorder(
                borderSide:  BorderSide(
                    color: Colors.deepOrangeAccent
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrangeAccent),
                borderRadius: new BorderRadius.circular(20.0),
              ),
            ),
            child:Center(
                child: new DropdownButton(
                  style: TextStyle(
                      color: Colors.deepOrangeAccent
                  ),
                  autofocus: true,
                  hint: Text(
                      "Select "+name
                  ),
                  items: selectdata.map((t) {
                    return new DropdownMenuItem(

                      child: new Text(t["text"]),
                      value: t["value"],
                    );
                  }).toList(),
                  onChanged: (newVal) {

                    _mySelection = newVal ;
                    print(_mySelection);
                    setState(() {

                    });
                  },
                  value: _mySelection,
                ))
        ),
      );
    }
    else if(field_type=="radio"){

      return Container(

        padding: const EdgeInsets.fromLTRB(28, 15, 28, 28),
        child: InputDecorator(

          decoration: InputDecoration(
            labelText: name,fillColor: Colors.blue,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrangeAccent),
              borderRadius: new BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderSide:  BorderSide(
                  color: Colors.deepOrangeAccent
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrangeAccent),
              borderRadius: new BorderRadius.circular(20.0),
            ),
          ),
          child:  Column(
            children:
            radiotdata.map((data) {
              var inde = radiotdata.indexOf(data);
              return RadioListTile(
                title: Text("${data["text"]}"),
                groupValue: inde,
                // toggleable: true,
                // controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.lightBlue,
                autofocus: true,
                value: ids,

                onChanged: (val) {
                  setState(() {
                    print(inde);
                    ids = inde;
                  });
                },
              );}).toList(),
          ),
        ),


      );
    }
    else{
      return  Padding(
        padding: const EdgeInsets.fromLTRB(28, 15, 28, 28),
        child: TextFormField(
          keyboardType:  field_type=="number"&&id=="amount"?TextInputType.numberWithOptions(decimal: true):field_type=="text"?TextInputType.text:TextInputType.phone,
          inputFormatters: [
            field_type=="number"&&id=="amount"?FilteringTextInputFormatter.allow(RegExp("[. 0-9]")):field_type=="text"?FilteringTextInputFormatter.allow(RegExp("[a-z A-Z á-ú Á-Ú 0-9]")):FilteringTextInputFormatter.digitsOnly,
          ],
          decoration:  InputDecoration(
            labelText: name,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrangeAccent),
              borderRadius: new BorderRadius.circular(10.0),
            ),
            border:  OutlineInputBorder(

              borderRadius:  BorderRadius.circular(10.0),
              borderSide:  BorderSide(
                  color: Colors.deepOrangeAccent
              ),
            ),
            labelStyle: TextStyle(


            ),


          ),
          onChanged: (val){
          },
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SingleChildScrollView(
      physics: ScrollPhysics(),
      child: FutureBuilder(
        future: apirequest(),
        builder: (context,AsyncSnapshot snapshot){
          if(snapshot.hasError){
            return Container(
              child: Text('error'),
            );
          }
          if(snapshot.data!=null){
            return Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 120,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(
                      snapshot.data['image_url']
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(snapshot.data['service_name']),
                SizedBox(
                  height: 5,
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!['fields'].length,
                    itemBuilder:(context,index){
                      return _row(index,snapshot.data!['fields'][index]["name"],snapshot.data!['fields'][index]["type"],snapshot.data!['fields'][index]["id"],snapshot.data!['fields'][index]["options"]);
          }

            ),]

            );}
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(child: CircularProgressIndicator()),
          );
        },
      ),
    ),

    );
  }
}
