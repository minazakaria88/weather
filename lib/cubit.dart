import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:weather_new_app/model.dart';
import 'package:weather_new_app/reuseable.dart';
import 'package:weather_new_app/states.dart';

import 'dio.dart';

class AppCubit extends Cubit<AppState>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context)=>BlocProvider.of(context);

   //get location for home page
  Future<dynamic> getLocationId()
  async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    try {
      _serviceEnabled = await location.serviceEnabled();
    } on PlatformException catch (err) {
      print ("Platform exception calling serviceEnabled(): $err");
      _serviceEnabled = false;
      getLocationId();
      print('lol');
    }
    if (!_serviceEnabled) {
      getLocationId();
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        getLocationId();
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    return _locationData;
  }

  // get weather data for gbs screen
   Model ? modelLatAndLon;
  Future<dynamic> searchByLatAndLon(double ? lat,double? lon)
  {
    return DioHelper.getData(
        url: 'data/2.5/weather',
        query: {
          'lat':lat,
          'lon':lon,
          'appid':'c03011e05678ba0f0d74f5ca02d0dcf0',
          'units':'metric',
        }
    ).then((value) {
      var x =value.data['main']['temp'];
      var k=value.data['weather'][0]['main'];
      var z=value.data['weather'][0]['icon'];
      var l=value.data['name'];
      var p=dateFormat(date: DateTime.now().toString());
      modelLatAndLon=Model(temp: x,name:l,status: k,image: z ,date: p);
      print(x);
      print(k);
      print(z);
    });
  }

  void getDataByLatAndLon()
  {
    getLocationId().then((value) {
      searchByLatAndLon(value.latitude, value.longitude).then((value) {
        emit(AppGetByLatAndLon());
      });
    });
  }
  // search by city name
  Model  ? modelCity;
  Future<dynamic> searchByCityName(String name)
  {
    return DioHelper.getData(
        url: 'data/2.5/weather',
        query: {
          'q':name,
          'appid':'c03011e05678ba0f0d74f5ca02d0dcf0',
          'units':'metric',
        }
    ).then((value) {

      var x =value.data['main']['temp'];
      var y=value.data['weather'][0]['main'];
      var z=value.data['weather'][0]['icon'];
      var l=value.data['name'];
      var lat=value.data['coord']['lat'];
      var lon=value.data['coord']['lon'];
      var p=dateFormat(date: DateTime.now().toString());
      print(l);
      modelCity=Model(temp: x,status: y,image: z,name: l,date: p);
      get7DaysWeather(lat, lon);
      emit(AppGetByCity());
      print(value);

    });
  }


   // get 7 days weather
  List<dynamic> list=[];
  String ? name;
  List<Model> listModel=[];
  void get7DaysWeather(double lat,double lon)
  {
    DioHelper.getData(
        url: 'data/2.5/onecall',
        query: {
          'appid':'c03011e05678ba0f0d74f5ca02d0dcf0',
          'units':'metric',
          'lat':lat,
          'lon':lon,
          'exclude':'current,minutely,hourly,alerts',
        }
    ).then((value){
      list=value.data['daily'];
      name=value.data['timezone'];
      emit(AppGet7ByCity());
      print(value.data['timezone']);
    });
  }



}