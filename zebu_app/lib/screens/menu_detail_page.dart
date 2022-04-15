import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zebu_app/bloc/menu/menu_bloc.dart';
import 'package:zebu_app/bloc/menu/menu_event.dart';
import 'package:zebu_app/bloc/menu/menu_state.dart';

class MenuDetailPage extends StatefulWidget {
  final Map argObj;

  const MenuDetailPage({Key? key, required this.argObj}) : super(key: key);

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState(argObj: argObj);
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  final Map argObj;
  _MenuDetailPageState({required this.argObj});
  @override
  Widget build(BuildContext context) {
    var id = argObj['id'];
    final menuBloc = BlocProvider.of<MenuBloc>(context);
    menuBloc.add(SingleMenuLoad(id));
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Color(0xff404E65),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'MENU',
            style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                color: Color(0xff404E65),
                fontWeight: FontWeight.w500),
          ),
        ),
        body: DefaultTextStyle(
          style: TextStyle(decoration: TextDecoration.none),
          child: SingleChildScrollView(
            child: Expanded(
              child: BlocConsumer<MenuBloc, MenuState>(
                  listener: (ctx, singleMenuState) {},
                  builder: (_, singleMenuState) {
                    print(singleMenuState);
                    if (singleMenuState is LoadingMenu) {
                      return const CircularProgressIndicator(
                        color: Color(0xff5D7498),
                      );
                    }

                    if (singleMenuState is SingleMenuLoadFailure) {
                      return const Text("Loading Failed");
                    }

                    if (singleMenuState is SingleMenuLoadSuccess) {
                      var singleMenu = singleMenuState.singleMenu;
                      return Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              singleMenu.title,
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              singleMenu.description,
                              style: TextStyle(color: Colors.black),
                            ),
                            Container(
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "http://45.79.249.127" + singleMenu.image,
                                  ),
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Text(
                              singleMenu.memberPrice + ' Birr',
                              style: TextStyle(color: Colors.black),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: singleMenu.type.contains("Spicy/hot")
                                      ? Image.asset(
                                          'assets/images/spicy.png',
                                          width: 20,
                                        )
                                      : Container(),
                                ),
                                singleMenu.type.contains("Vegetarian")
                                    ? Image.asset(
                                        'assets/images/vegeterian.png',
                                        width: 20,
                                      )
                                    : Container(),
                                singleMenu.type.contains("Vegan/fasting")
                                    ? Image.asset(
                                        'assets/images/vegan.png',
                                        width: 20,
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  }),
            ),
          ),
        ));
  }
}
