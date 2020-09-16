import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'widgets/ticker.dart';

import '../../models/address.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Address> _addresses = List<Address>();
  List<Address> _filteredAddresses = List<Address>();

  Future<List<Address>> fetchAddresses() async {
    var url = 'https://jsonplaceholder.typicode.com/posts'; // Fake REST API for Testing
    var response = await http.get(url);
    var addresses = List<Address>();
    if (response.statusCode == 200) {
      var addressesJson = json.decode(response.body);
      for (var addressJson in addressesJson) {
        addresses.add(Address.fromJson(addressJson));
      }
    }
    return addresses;
  }

  @override
  void initState() {
    fetchAddresses().then((value) {
      setState(() {
        _addresses.addAll(value);
        _filteredAddresses = _addresses;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemBuilder: (context, index) {
            return index == 0 ? _searchBar() : _listItem(index-1);
          },
          itemCount: _filteredAddresses.length + 1,
        )
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.search),
            SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Введите для поиска",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (text) {
                  text = text.toLowerCase();
                  setState(() {
                    _filteredAddresses = _addresses.where((address) {
                      var addressTitle = address.title.toLowerCase();
                      return addressTitle.contains(text);
                    }).toList();
                  });
                },
              ),
            ),
          ]
        ),
    );
  }

  _listItem(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TickerWidget(
              direction: Axis.horizontal,
              child: Text(
                _filteredAddresses[index].title,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _filteredAddresses[index].body,
              style: TextStyle(
                  color: Colors.grey.shade600
              ),
            ),
          ],
        ),
      ),
    );
  }

}
