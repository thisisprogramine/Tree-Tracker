
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tree_tracker/theme/app_color.dart';

import '../model/TreeLocation.dart';
import '../services/file_service.dart';
import '../services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LocationService locationService;
  List<Location> positions = [];
  bool isStarted = false;

  @override
  void initState() {
    super.initState();

    locationService = LocationService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Canvas Green', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: isStarted,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isStarted = true;
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                                margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                                color: !isStarted ? AppColor.primary : Colors.grey,
                                child: Center(
                                    child: Text('Start', style: Theme.of(context).textTheme.titleMedium,)
                                )
                            )
                          ),
                        ),
                      ),
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: !isStarted,
                          child: InkWell(
                              onTap: () {
                                final treeLocations = PlantLocation(
                                    locations: positions
                                );
                                FileService.saveFile(filename: 'location', json: treeLocations.toJson());

                                setState(() {
                                  positions.clear();
                                  isStarted = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                                margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                                color: isStarted ? AppColor.primary : Colors.grey,
                                  child: Center(
                                      child: Text('End', style: Theme.of(context).textTheme.titleMedium,)
                                  )
                              )
                          ),
                        ),
                      )

                    ],
                  ),

                  AbsorbPointer(
                    absorbing: !isStarted,
                    child: InkWell(
                        onTap: () async{
                          final position = await locationService.getLatitudeLongitude();
                          setState(() {
                            positions.add(Location(latitude: position.latitude, longitude: position.longitude));
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                            margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                            color: isStarted ? Colors.green : Colors.green.withOpacity(0.5),
                            child: Center(
                                child: Text('Capture', style: Theme.of(context).textTheme.titleMedium,)
                            )
                        )
                    ),
                  ),
                ],
              )
          ),
          Expanded(
            flex: 6,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Center(
                            child: Container(
                              child: Text('Latitude', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            ),
                          )
                      ),
                      Expanded(
                          child: Center(
                            child: Container(
                              child: Text('Latitude', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            ),
                          )
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: positions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(child: Center(child: Text('${positions[index].latitude}', style: Theme.of(context).textTheme.titleMedium))),
                                    Expanded(child: Center(child: Text('${positions[index].longitude}', style: Theme.of(context).textTheme.titleMedium)))
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                color: Colors.grey,
                                height: 1,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}

