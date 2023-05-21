import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:sharemagazines_flutter/src/blocs/navbar/navbar_bloc.dart';

import '../../../../models/locationOffers_model.dart';
import '../../../../models/place_map.dart';
import 'offerpage.dart';

class MapOffer extends StatefulWidget {
  final Place locationDetails;

  MapOffer({Key? key, required this.locationDetails}) : super(key: key);

  @override
  State<MapOffer> createState() => _MapOfferState();
}

class _MapOfferState extends State<MapOffer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background/Background.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => {
                      // setState(() {
                      // BlocProvider.of<NavbarBloc>(context).add(Map());
                      Navigator.pop(context)
                      // })
                    },
                child: Hero(tag: "backbutton", child: Icon(Icons.arrow_back_ios_new,color: Colors.white,))),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body:
              // BlocBuilder<NavbarBloc, NavbarState>(
              //         bloc: BlocProvider.of<NavbarBloc>(context),
              //         builder: (context, state) {
              //           if (state is MapLocationOffer) {
              //             return
              SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Hero(
                      tag: widget.locationDetails.nameApp,
                      child: Text(widget.locationDetails.nameApp, style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Text(
                        widget.locationDetails.addressStreet +
                            " " +
                            widget.locationDetails.addressHouseNr +
                            ",\n" +
                            widget.locationDetails.addressZip +
                            " " +
                            widget.locationDetails.addressCity,
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w300)),
                  ),
                  FutureBuilder<LocationOffers>(
                      future: NavbarState.maplocationoffers,
                      builder: (context, snapshot) {
                        print("NavbarState.maplocationoffers snapdata is ${snapshot.data}");
                        if (snapshot.hasData) {
                          // print(snapshot.data!.locationOffer!.length);

                          return Column(
                            children: [
                              for (int i = 0; i < snapshot.data!.locationOffer!.length; i++)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () => {
                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          builder: (context) => OfferPage(
                                            locOffer: snapshot.data!.locationOffer![i],

                                          ),
                                        ),
                                      ),
                                      // Navigator.push(
                                      //   context,
                                      //   PageRouteBuilder(
                                      //     pageBuilder: (_, __, ___) =>
                                      //         OfferPage(
                                      //       locOffer: snapshot
                                      //           .data!.locationOffer![i],
                                      //       heroTag: i,
                                      //     ),
                                      //   ),
                                      // )
                                    },
                                    child: Container(
                                      // color: Colors.yellow,
                                      width: MediaQuery.of(context).size.width - 40,
                                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white.withOpacity(0.1),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 0.25,
                                        ),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Hero(
                                          // tag: 'offer_title$i',
                                          tag: snapshot.data!.locationOffer![i].shm2Offer![0].title!,
                                          child: Text(snapshot.data!.locationOffer![i].shm2Offer![0].title!,
                                              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300))),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }
                        // else {
                        //   return SpinKitFadingCircle(
                        //     color: Colors.white,
                        //     size: 50.0,
                        //   );
                        // }
                        else
                          return Container(
                              child: Text(("noLocationOffers").tr(), style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300))

                              // color: Colors.red,
                              // width: 20,
                              // height: 20,
                              );
                      })
                ],
              ),
            ),
          )
          //   }
          //   return Container();
          // }),
          ),
    );
  }
}