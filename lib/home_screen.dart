import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String  fromCurrency = "USD";
  String  toCurrency = "EUR" ;
  double rate = 0.0 ;
  double total = 0.0 ;
  TextEditingController amountController =  TextEditingController();
  List<String> currencies = [ ] ;

  @override
  void initState() {
    super.initState();
    _getCurrencies();
  }
  Future<void> _getCurrencies()async{
    var response = await http.get(Uri.parse("https://v6.exchangerate-api.com/v6/fcd4cf163a7d8534c930ca1d/latest/USD"));

    var data  = json.decode(response.body);
    setState(() {

      rate = data["conversion_rates"][toCurrency];
    });


  }

  void _swapCurrencies(){
    setState(() {
      String temp = fromCurrency;
      fromCurrency =  toCurrency ;
      toCurrency  = temp;
      getRate();
    });
  }

  Future<void> getRate()async{
    var response = await http.get(Uri.parse("https://v6.exchangerate-api.com/v6/fcd4cf163a7d8534c930ca1d/latest/$fromCurrency"));

    var data  = json.decode(response.body);
    setState(() {
      currencies = (data['conversion_rates'] as Map<String, dynamic>).keys.toList();
      rate = data['conversion_rates'][toCurrency];
    });


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF1d2630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text("     Convertion de Devise  by zops"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(40),
              child: Image.asset('images/currence.png',  // photo du haut
                width: MediaQuery.of(context).size.width/2 ,
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.amber,            // changer la couleur du text
                  ),
                  decoration: InputDecoration(
                    labelText: "MONTANT" ,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelStyle: TextStyle(color: Colors.amber),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),

                      focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),


                  ),
                  onChanged: (value){
                    if (value != '') {
                      setState(() {
                        double amount = double.parse(value);
                        total = amount * rate ;
                      });
                    }
                  },

                ),
              ),
              Padding(padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                  child:
                  DropdownButton<String>(
                    value: fromCurrency,
                    isExpanded: true,
                    style: TextStyle(color: Colors.white),
                    dropdownColor: Color(0xFF1d2630),
                    items: currencies.map((String value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue){
                      setState(() {
                        fromCurrency = newValue!;
                        getRate();
                      });
                    },
                  ),
                  ),
                  IconButton(
                    onPressed: _swapCurrencies,

                    icon:  Icon(Icons.swap_horiz,
                    size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: DropdownButton<String>(
                      value: toCurrency,
                      isExpanded: true,
                      style: TextStyle(color: Colors.white),
                      dropdownColor: Color(0xFF1d2630),
                      items: currencies.map((String value){
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue){
                        setState(() {
                          toCurrency = newValue!;
                          getRate();
                        });
                      },
                    ),
                  ),


                ],
              ),
              ),
              SizedBox(height: 10),
              Text("Rate $rate",
                style: TextStyle(
                  fontSize: 20 , color: Colors.white ,
                ),
              ),
              SizedBox(height: 20,) ,
              Text('${total.toStringAsFixed(3)}',
              style: TextStyle(
                color: Colors.greenAccent ,
                fontSize: 40
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

