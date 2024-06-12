// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sharemagazines/src/blocs/auth/auth_bloc.dart';
// import 'package:sharemagazines/src/blocs/splash/splash_bloc.dart';
// import 'package:sharemagazines/src/presentation/pages/navbarpages/mainpage.dart';
//
// import '../../blocs/navbar/navbar_bloc.dart';
// import '../../models/location_model.dart';
// import 'startpage/startpage.dart';
//
// class SplashScreen extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: Hero(
//             tag: 'bg',
//             child: Image.asset(
//               "assets/images/background/Background.png",
//               fit: BoxFit.fill,
//               // allowDrawingOutsideViewBox: true,
//             ),
//           ),
//         ),
//         Align(child: BlocBuilder<SplashBloc, SplashState>(
//           builder: (context, state) {
//             if ((state is Initial)) {
//               BlocProvider.of<SplashBloc>(context).add(
//                 NavigateToHomeEvent(),
//               );
//               return SplashScreenWidget(context);
//             } else if (state is SkipLogin) {
//               // await authRepository.signIn(email: existingemail, password: existingpwd).then((value) => {emit(IncompleteAuthenticated())});
//               BlocProvider.of<AuthBloc>(context).add(SignInRequested(state.email, state.pwd, "", "", false));
//               return BlocListener<AuthBloc, AuthState>(
//                 listener: (context, state) {
//                   // Check if the state is the one you expect after IncompleteSignInRequested
//                   if (state is Authenticated) {
//                     // Now that AuthBloc has finished its work, do the next steps
//                     BlocProvider.of<NavbarBloc>(context).add(InitializeNavbar(currentPosition: LocationData()));
//                     Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(builder: (context) => MainPage()),
//                       (Route<dynamic> route) => false,
//                     );
//                   } else {
//                     Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(builder: (context) => StartPage(title: "title")),
//                       (Route<dynamic> route) => false,
//                     );
//                   }
//                 },
//                 child: Container(),
//               );
//             } else if (state is SkipLoginIncomplete) {
//               return const StartPage(
//                 title: "notitle",
//               );
//             } else if (state is Loaded) {
//               return const StartPage(
//                 title: "notitle",
//               );
//             } else if (state is SplashError) {
//               print(state.error);
//               BlocProvider.of<AuthBloc>(context).emit(AuthError(state.error));
//               return const StartPage(
//                 title: "notitle",
//               );
//             }
//             return Container();
//           },
//         ))
//       ],
//     );
//   }
//
//   Widget SplashScreenWidget(BuildContext context) {
//     return Scaffold(
//       body:  Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           // Positioned.fill(
//           //   child:
//           Image.asset(
//             "assets/images/background/Background.png",
//             fit: BoxFit.fill,
//             // allowDrawingOutsideViewBox: true,
//           ),
//           // ),
//           Center(
//             child: Image.asset(
//               'assets/images/logo/logo.png',
//               width: MediaQuery.of(context).size.width * 0.5,
//               // ,fit: BoxFit.,
//               // filterQuality: FilterQuality.high,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class JobDetailsPage extends StatefulWidget {
  const JobDetailsPage({key, @PathParam() required this.jobId});

  final int jobId;

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
  TabController(length: 3, vsync: this);
  @override
  void initState() {
    super.initState();
    _tabController;
  }

  Future<List<Map<String, dynamic>>> fetchJobDetails() async {
    try {
      final response = await Supabase.instance.client
          .from('job_list')
          .select('*')
          .eq('id', widget.jobId) // Adjust the filter condition
          .single();

      // ignore: unnecessary_cast
      return [response as Map<String, dynamic>];
    } catch (error) {
      // Handle errors gracefully
      debugPrint('$error');
      return []; // Return an empty list on error
    }
  }

  Future<List<Map<String, dynamic>>> fetchJobRequirements() async {
    try {
      final response = await Supabase.instance.client
          .from('job_list')
          .select('requirements')
          .eq('job_id', widget.jobId); // Adjust the filter condition

      return response;
    } catch (error) {
      // Handle errors gracefully
      debugPrint('$error');
      return []; // Return an empty list on error
    }
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Iconsax.bookmark4))
        ],
        title: Text(
          'Job Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchJobDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No data available',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
            );
          } else {
            // Display your job details using the snapshot.data
            final jobDetails =
            snapshot.data![0]; // Assuming only one row is returned
            return Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.blueAccent, boxShadow: []),
                  width: MediaQuery.of(context).size.width,
                  height: 260,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 45,
                                child: Icon(
                                  Icons.abc_outlined,
                                  size: 60,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${jobDetails['jobTitle']}',
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${jobDetails['department']}',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 45,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 45.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${jobDetails['jobSalary']}/m',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '${jobDetails['location']}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: TabBar(
                    splashFactory: InkRipple.splashFactory,
                    overlayColor:
                    const MaterialStatePropertyAll(Colors.transparent),
                    controller: _tabController,
                    indicatorColor: Colors.blue,
                    labelStyle: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: GoogleFonts.poppins(
                        color: Colors.black38, fontWeight: FontWeight.w500),
                    tabs: const [
                      Tab(
                        text: 'Description',
                      ),
                      Tab(
                        text: 'Requirements',
                      ),
                      Tab(
                        text: 'About',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 400,
                  child: TabBarView(
                      controller: _tabController,
                      children: [
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: fetchJobDetails(),
                          builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(snapshot.data![index].toString()),
// You can customize the ListTile as per your requirements
                                  );
                                },
                              );
                            }
                          },
                        ),

                        Center(child: Text('Requirements')),
                Center(child: Text('About')),
              ],
            ),
          ),
          const SizedBox(
          height: 20,
          ),
          Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: double.maxFinite,
          height: 60,
          decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
          BoxShadow(blurRadius: 3, color: Colors.black54),
          ]),
          child: Center(
          child: Text(
          'Apply Now',
          style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white),
          )),
          )
          ],
          );
        }
        },
      ),
    );
    return scaffold;
  }
}