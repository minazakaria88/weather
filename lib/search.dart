import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_new_app/reuseable.dart';
import 'package:weather_new_app/states.dart';

import 'cubit.dart';

class Search extends StatelessWidget {
  TextEditingController controller=TextEditingController();
  var formKey=GlobalKey<FormState>();
  var d=DateTime.now();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          var cubit=AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.pink,
              title: const Text('weather for cities'),
            ),
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                  const  SizedBox(
                      height: 10,
                    ),
                   Row(
                     children: [
                       Expanded(
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: TextFormField(
                             validator: (value)
                             {
                               if(value!.isEmpty)
                                 {
                                   return ' must not be empty';
                                 }
                             },
                             controller: controller,
                             decoration: const InputDecoration(
                               prefixIcon: Icon(
                                 Icons.search,
                                 color: Colors.black,
                               ),
                               label: Text('Enter city name'),
                               labelStyle: TextStyle(
                                 color: Colors.black,
                               ),
                               border: OutlineInputBorder(),
                               focusedBorder: OutlineInputBorder(
                                 borderSide: BorderSide(
                                   color: Colors.pink,
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(5.0),
                         child: Container(
                           height: 50,
                           decoration: BoxDecoration(
                             color: Colors.pink,
                             borderRadius: BorderRadius.circular(7),
                           ),
                           child: MaterialButton(
                             child: const Text('search',
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 20,
                             ),
                             ),
                               onPressed: ()
                                   {
                                     if(formKey.currentState!.validate())
                                       {
                                         cubit.searchByCityName(controller.text);
                                       }
                                   }
                           ),
                         ),
                       ),
                     ],
                   ),
                   const SizedBox(
                      height: 10,
                    ),
                   cubit.modelCity==null? Container(): Column(
                     children: [
                       newContainer(
                         model: cubit.modelCity,
                       ),
                       const SizedBox(
                         height: 20,
                       ),
                       SizedBox(
                         width: double.infinity,
                         height: 300,
                         child: ListView.separated(
                           scrollDirection: Axis.horizontal,
                             itemBuilder: (context, index) => new7Container(
                               temp: cubit.list[index]['temp']['day'],
                               image: cubit.list[index]['weather'][0]['icon'],
                               status: cubit.list[index]['weather'][0]['main'],
                               date: dateFormat(date: DateTime(d.year,d.month,d.day+1+index).toString()),
                               name:cubit.name ,
                               width: 300,
                             ),
                             separatorBuilder:(context, index) =>  Container(
                               width: 20,
                             ),
                             itemCount: cubit.list.length
                         ),
                       ),
                     ],
                   ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
