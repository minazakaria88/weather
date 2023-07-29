import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_new_app/cubit.dart';
import 'package:weather_new_app/reuseable.dart';
import 'package:weather_new_app/search.dart';
import 'package:weather_new_app/states.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getDataByLatAndLon(),
      child: BlocConsumer<AppCubit,AppState >(
       listener: (context, state) {
       },
        builder: (context, state) {
         var cubit=AppCubit.get(context);
         print('lol');
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.pink,
              title: const Text('weather for your place'),
              actions: [
                IconButton(
                  onPressed: ()
                  {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) =>  Search(),),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 25,
                  ),
                ),
              ],
            ),
            body: SizedBox(
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        child: const Text('show',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        ),
                          onPressed: (){
                            cubit.getDataByLatAndLon();
                          }

                          ),
                    ),
                  ),
                const  SizedBox(
                    height: 20,
                  ),
                  cubit.modelLatAndLon==null? Container():newContainer(
                    model: cubit.modelLatAndLon,
                    width: double.infinity
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
