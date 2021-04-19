import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class Covid{
 final String country;
 final int deaths;
 final int recovered;
 final int active;
 Covid({

   this.country, this.active, this.deaths, this.recovered
});

 factory Covid.fromJson(Map<String, dynamic> json){
   return Covid(
     country: json['Country'],
     deaths: json['Deaths'],
     recovered: json['Recovered'],
     active: json['Active']
   );
 }


}

Stream<List> getData() async*{
 while(true){
   final response = await http.get(Uri.parse('https://api.covid19api.com/countries'));
   final data = jsonDecode(response.body) as List;
   yield  data;
 }

}

Stream<List> getStatus(String county) async*{

  while(true){
    final response = await http.get(Uri.parse('https://api.covid19api.com/live/country/$county'));
    final data = jsonDecode(response.body) as List;
    Rx.combineLatest2(getData(), getStatus('london'), (a, b) => null);
    yield  data;
  }


}

final streamData = StreamProvider.family((ref, county) {
  return getStatus(county);
});
final streamCountry = StreamProvider((ref) => getData());
class DataStream extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final data = watch(streamCountry);
    return Scaffold(
        body: data.when(
            data: (data){
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => watch(streamData(data[index]['Slug'])).maybeWhen(
                  data: (data) => ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(data[index]['Confirmed']),
                      )) ,
                    orElse: () => Text('Loading....'))
            );
            },
            loading: () => Center(child: CircularProgressIndicator(),),
            error: (err, stack) => Center(child: Text('$err')))
    );
  }
}
