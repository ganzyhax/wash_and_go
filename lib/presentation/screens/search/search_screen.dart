import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_and_go/presentation/screens/box/box_page.dart';
import 'package:wash_and_go/presentation/screens/search/bloc/search_bloc.dart';
import 'package:wash_and_go/presentation/screens/search/components/search_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc()..add(SearchLoad()),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 140,
            decoration: const BoxDecoration(color: Colors.deepPurple),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        child: Text(
                          'Kazakhstan',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(11), // Image border

                    child: SizedBox.fromSize(
                      size: Size.fromRadius(17), // Image radius
                      child: Image.network(
                          'https://louisville.edu/enrollmentmanagement/images/person-icon/image',
                          fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchLaoded) {
                return SingleChildScrollView(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 100),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 6.0,
                              right: 8,
                              top: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Автомойки',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 19),
                                  ),
                                ),
                                (state.washes.length != 0)
                                    ? ListView.builder(
                                        padding: EdgeInsets.only(top: 0),
                                        itemCount: state.washes.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return (index + 1 ==
                                                  state.washes.length)
                                              ? Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      BoxScreen(
                                                                        wash: state
                                                                            .washes[index],
                                                                        title: state
                                                                            .washes[index]
                                                                            .name,
                                                                      )),
                                                        );
                                                      },
                                                      child: StationWidget(
                                                        data:
                                                            state.washes[index],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              1,
                                                    )
                                                  ],
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              BoxScreen(
                                                                wash: state
                                                                        .washes[
                                                                    index],
                                                                title: state
                                                                    .washes[
                                                                        index]
                                                                    .name,
                                                              )),
                                                    );
                                                  },
                                                  child: StationWidget(
                                                    data: state.washes[index],
                                                  ),
                                                );
                                        },
                                      )
                                    : Column(children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                        )
                                      ]),
                              ],
                            ),
                          ))),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
