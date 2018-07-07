import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/filter_param.dart';
import '../models/country_model.dart';
import '../utils/constant.dart';
import 'dart:convert';

class SearchCountryPage extends StatefulWidget {
  @override
  _SearchCountryPageState createState() => _SearchCountryPageState();
}

class _SearchCountryPageState extends State<SearchCountryPage> {
  SharedPreferences sharedPreferences;
  // List<String> listCountry = new List<String>();
  List<CountryModel> listCountries = new List<CountryModel>();

  /*
for demo hardcode
 */
  void _populateCountryData() {
    listCountries.add(new CountryModel("Indonesia", true));
    listCountries.add(new CountryModel("All Countries", false));
    listCountries.add(new CountryModel("Albania", false));
    listCountries.add(new CountryModel("Angola", false));
    listCountries.add(new CountryModel("Antigua", false));
    listCountries.add(new CountryModel("Argentina", false));
    listCountries.add(new CountryModel("Aruba", false));
    listCountries.add(new CountryModel("Australia", false));
    listCountries.add(new CountryModel("Austria", false));
    listCountries.add(new CountryModel("Bahamas", false));
    listCountries.add(new CountryModel("Bahrain", false));
    listCountries.add(new CountryModel("Barbados", false));
    listCountries.add(new CountryModel("Cambodia", false));
    listCountries.add(new CountryModel("Denmark", false));
    listCountries.add(new CountryModel("Eqypt", false));
    listCountries.add(new CountryModel("Fiji", false));
    listCountries.add(new CountryModel("Germany", false));
  }

  void checkAlreadySelected() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      String pref = sharedPreferences.getString(keyFilterParam);
      const JsonDecoder decoder = const JsonDecoder();
      Map filterParamMap = decoder.convert(pref);
      var filterParamNew = new FilterParam.fromJson(filterParamMap);

      for (var item in listCountries) {
        if (item.countryName == filterParamNew.countryName) {
          setState(() {
            clearSelected();
            listCountries.elementAt(listCountries.indexOf(item)).selected =
                true;
          });
          break;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  // hapus semua category yang dipilih
  void clearSelected() {
    for (var item in listCountries) {
      item.selected = false;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      // populate data country
      _populateCountryData();
      // cek apakah country sudah pernah dipilih sebelumnya dari shared preference
      checkAlreadySelected();
    });
  }

  Widget _buildCountry() {
    return new ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: listCountries.length,
      itemBuilder: (BuildContext context, int index) {
        // // cek apakah kategori dipilih atau tidak karena memiliki view beda
        if (listCountries.elementAt(index).selected == true) {
          return new Column(
            children: <Widget>[_buildRowSelected(context, index)],
          );
        } else {
          if (index == 0) {
            return new Column(
              children: <Widget>[
                new Container(
                  color: Colors.grey[150],
                  child: new ListTile(
                    leading: const Icon(Icons.search),
                    title: new TextField(
                      decoration: new InputDecoration(
                        hintText: "Search Select Country",
                      ),
                    ),
                  ),
                ),
                _buildRow(context, index)
              ],
            );
          } else {
            return new Column(
              children: <Widget>[_buildRow(context, index)],
            );
          }
        }
      },
    );
  }

  Widget _buildRow(BuildContext context, int index) {
    return new Column(
      children: <Widget>[
        new Container(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: new ListTile(
                onTap: () {
                  _onTap(context, listCountries.elementAt(index).countryName,
                      index);
                },
                title: new Text(listCountries.elementAt(index).countryName),
              ),
            )),
        new Divider(
          height: 2.0,
        )
      ],
    );
  }

  Widget _buildRowSelected(BuildContext context, int index) {
    return new Column(
      children: <Widget>[
        new Container(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: new ListTile(
                onTap: () {
                  _onTap(context, listCountries.elementAt(index).countryName,
                      index);
                },
                title: new Text(listCountries.elementAt(index).countryName),
                trailing: Icon(Icons.check),
              ),
            )),
        new Divider(
          height: 2.0,
        )
      ],
    );
  }

  _onTap(BuildContext context, selectedCountry, int index) async {
    setState(() {
      clearSelected();
      listCountries.elementAt(index).selected = true;
    });

    sharedPreferences = await SharedPreferences.getInstance();
    String filterParam = sharedPreferences.getString(keyFilterParam);
    const JsonDecoder decoder = const JsonDecoder();
    Map filterParamMap = decoder.convert(filterParam);
    var filterParamNew = new FilterParam.fromJson(filterParamMap);
    filterParamNew.countryName = selectedCountry;
    const JsonEncoder encoder = const JsonEncoder();
    String stringJson = encoder.convert(filterParamNew);
    print(stringJson);
    sharedPreferences.setString(keyFilterParam, stringJson);
    Navigator.pop(context, selectedCountry);
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Search Country"),
        ),
        body: _buildCountry(),
      ),
    );
  }
}