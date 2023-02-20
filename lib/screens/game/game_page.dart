import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

import '../../models/my_marker_model.dart';

class GamePage extends StatefulWidget {
  static const String routeName = "/GamePage";
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  // Note the addition of the TickerProviderStateMixin here. If you are getting an error like
  // 'The class 'TickerProviderStateMixin' can't be used as a mixin because it extends a class other than Object.'
  // in your IDE, you can probably fix it by adding an analysis_options.yaml file to your project
  // with the following content:
  //  analyzer:
  //    language:
  //      enableSuperMixins: true
  // See https://github.com/flutter/flutter/issues/14317#issuecomment-361085869
  // This project didn't require that change, so YMMV.

  late LatLng carPosition;

  late final MapController mapController;

  bool isCarMoving = false, isGamePaused = false;
  int currentPopupIndex = -1;

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  Future<void> startMovingCar() async {
    if(isCarMoving) {
      print("Car is Already Moving");
      return;
    }

    // resetSystem();

    isCarMoving = true;
    isGamePaused = false;

    final List<LatLng> points = calculatePolylinePointsForAllPolylinePoints().toList();
    print("got ${points.length} points for car");

    final List<MyMarkerModel> popups = getPopupsCoordinates();
    print("got ${popups.length} popups for car");

    if(popups.isNotEmpty) {
      currentPopupIndex = 0;
    }
    else {
      currentPopupIndex = -1;
    }

    moveCar(
      allPoints: points,
      positionIndex: -1,
      popups: popups,
      popupIndex: currentPopupIndex,
    );
  }

  Future<void> moveCar({required List<LatLng> allPoints, int positionIndex = -1, required List<MyMarkerModel> popups, int popupIndex = -1,}) async {
    print("moveCar called with index $positionIndex");

    if(!isCarMoving) {
      isGamePaused = false;
      print("returning from moveCar because Car is Not Moving");
      return;
    }

    while(isGamePaused) {
      print("Game Paused");
      await Future.delayed(const Duration(milliseconds: 500));
    }

    positionIndex++;
    print("currentIndex:$positionIndex");
    if(positionIndex < allPoints.length) {
      final LatLng point = allPoints[positionIndex];
      carPosition = point;
      print("Moving Car at position:$carPosition");
      setState(() {});

      if((popupIndex >= 0 && popupIndex < popups.length) && point == popups[popupIndex].latLng) {
        final MyMarkerModel myMarkerModel = popups[popupIndex];

        await showMarkerPopup(myMarkerModel: myMarkerModel);

        currentPopupIndex++;
      }
    }
    else {
      isCarMoving = false;
      isGamePaused = false;
      setState(() {});
      print("returning from moveCar because Not more points found");
      return;
    }

    await Future.delayed(const Duration(milliseconds: 100));
    moveCar(
      allPoints: allPoints,
      positionIndex: positionIndex,
      popups: popups,
      popupIndex: currentPopupIndex,
    );
  }

  List<Marker> getMarkers() {
    return <Marker>[
      Marker(
        width: 40,
        height: 40,
        point: LatLng(22.28577343017038, 73.17520619661104),
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.location_on_outlined,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
      Marker(
        width: 40,
        height: 40,
        point: LatLng(22.284449337190993, 73.17073600790816),
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            MdiIcons.speedometerSlow,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      Marker(
        width: 40,
        height: 40,
        point: LatLng(22.29350473452168, 73.1717791956286),
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.turn_left,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      Marker(
        width: 40,
        height: 40,
        point: LatLng(22.294234976670997, 73.16587008950348),
        builder: (ctx) => RotatedBox(
          quarterTurns: 3,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.turn_right,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
      Marker(
        width: 40,
        height: 40,
        point: LatLng(22.300335862552807, 73.16670368059339),
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.school,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
      Marker(
        width: 40,
        height: 40,
        point: LatLng(22.305805437948145, 73.16709855623556),
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.local_hospital,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
      Marker(
        width: 40,
        height: 40,
        point: LatLng(22.308357817410382, 73.16357594673609),
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.share_location,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
      Marker(
        width: 40,
        height: 40,
        point: carPosition,
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.directions_car,
            color: Colors.white,
            size: 30,
          ),
        ),
        /*builder: (ctx) => Image.asset(
          "assets/icons/car icon.jpeg",
        ),*/
      ),
    ];
  }

  List<LatLng> getPolylinePoints() {
    return <LatLng>[
      LatLng(22.28577343017038, 73.17520619661104),
      LatLng(22.285649337190993, 73.17073600790816),
      LatLng(22.28625207348761, 73.16853755444777),
      LatLng(22.290444564347816, 73.1704471914732),
      LatLng(22.293192217414195, 73.17083515384854),
      LatLng(22.29345811645701, 73.16792112534021),
      LatLng(22.292917454538433, 73.16461482376349),
      LatLng(22.29428240027457, 73.16431307524931),
      LatLng(22.2962513257833, 73.16458033821895),
      LatLng(22.300335862552807, 73.16540368059339),
      LatLng(22.305805437948145, 73.16599855623556),
      LatLng(22.308251469197494, 73.16520538871264),
      LatLng(22.308357817410382, 73.16357594673609),
    ];
  }

  List<MyMarkerModel> getPopupsCoordinates() {
    final List<LatLng> points = getPolylinePoints();

    return <MyMarkerModel>[
      MyMarkerModel(
        title: "Bumper Ahead",
        description: "There is a bumper Ahead, slow down your speed",
        widget: const Icon(
          MdiIcons.speedometerSlow,
          size: 80,
        ),
        latLng: points[1],
      ),
      MyMarkerModel(
        title: "Turn Left",
        description: "There is a left turn Ahead",
        widget: const Icon(
          Icons.turn_left,
          size: 80,
        ),
        latLng: points[3],
      ),
      MyMarkerModel(
        title: "Turn Right",
        description: "There is a right turn Ahead",
        widget: const Icon(
          Icons.turn_right,
          size: 80,
        ),
        latLng: points[5],
      ),
      MyMarkerModel(
        title: "School Ahead",
        description: "Slow down your speed",
        widget: const Icon(
          Icons.school,
          size: 80,
        ),
        latLng: points[9],
      ),
      MyMarkerModel(
        title: "Hospital Ahead",
        description: "Maintain Silence",
        widget: const Icon(
          Icons.local_hospital,
          size: 80,
        ),
        latLng: points[10],
      ),
    ];
  }

  Iterable<LatLng> calculatePolylinePointsForAllPolylinePoints() sync* {
    final List<LatLng> points = getPolylinePoints();
    print("Main Points length:${points.length}");

    for(int i = 0; i < points.length; i++) {
      final LatLng firstPoint = points[i];
      LatLng? secondPoint;
      if(i < (points.length - 1)) {
        secondPoint = points[i + 1];
      }

      if(secondPoint != null) {
        Iterable<LatLng> innerPoints = calculatePolylinePointsBetweenPoint(
          start: firstPoint,
          end: secondPoint,
          depth: 1,
        );
        print("innerPointsLength:${innerPoints.length}");
        yield* innerPoints;
      }
    }
  }

  Iterable<LatLng> calculatePolylinePointsBetweenPoint({required LatLng start, required LatLng end, double depth = 1}) sync* {
    print("calculatePolylinePointsBetweenPoint called for start:$start, end:$end");

    final double slope = (end.longitude - start.longitude) / (end.latitude - start.latitude);
    print("slope:$slope");

    double x = start.latitude;
    final double multiplier = (end.latitude - start.latitude) >= 0 ? 1 : -1;
    const diff = 0.0001;
    print("initial x:$x");
    print("multiplier:$multiplier");
    print("diff:$diff");

    while(multiplier == 1 ? (x < end.latitude) : (x > end.latitude)) {
      final double y = (slope * x) + (start.longitude - (slope * start.latitude));
      yield LatLng(x, y);
      print("new x:$x");
      print("new y:$y");

      x += (multiplier * diff);
    }

    yield end;
  }

  Future<void> showMarkerPopup({required MyMarkerModel myMarkerModel}) async {
    FlutterTts flutterTts = FlutterTts();
    bool isPoped = false;

    if(myMarkerModel.title.isNotEmpty) {
      flutterTts.speak(myMarkerModel.title).then((value) async {
        await Future.delayed(const Duration(seconds: 2));
        if(!isPoped && myMarkerModel.description.isNotEmpty) {
          flutterTts.speak(myMarkerModel.description);
        }
      });
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text("Sign")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              myMarkerModel.widget,
              const SizedBox(height: 10,),
              Text(myMarkerModel.title),
              Text(myMarkerModel.description),
            ],
          ),
        );
      },
    );

    isPoped = true;
    flutterTts.stop();
  }

  void onTap(TapPosition tapPosition, LatLng latLng) {
    // print("tapPosition:${tapPosition.global.}");
    print("lat:${latLng.latitude}");
    print("lng:${latLng.longitude}");
  }

  void resetSystem() {
    isCarMoving = false;
    isGamePaused = false;
    carPosition = getPolylinePoints().first;
    currentPopupIndex = -1;
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    resetSystem();
  }

  @override
  void dispose() {
    resetSystem();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Bumper, Silent, Left, Right, Speed
    return Scaffold(
      appBar: getAppBar(),
      floatingActionButton: getFloatingActionButton(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(22.297538953318465, 73.17017992850349),
            zoom: 15,
            maxZoom: 20,
            minZoom: 3,
            onTap: onTap,
          ),
          children: [
            getMapTileWidget(),
            getPolylineWidget(),
            getMarkersWidget(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppBar(
      title: const Text('Game'),
    );
  }

  Widget getFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        if(!isCarMoving) {
          if(isGamePaused) {
            isGamePaused = false;
          }

          startMovingCar();
        }
        else {
          isGamePaused = !isGamePaused;
          setState(() {});
        }
      },
      child: Icon(isCarMoving && !isGamePaused ? Icons.pause : Icons.play_arrow),
    );
  }

  Widget getMapTileWidget() {
    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
  }

  Widget getPolylineWidget() {
    return PolylineLayer(
      polylines: [
        Polyline(
          points: getPolylinePoints(),
          strokeWidth: 4,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget getMarkersWidget() {
    return MarkerLayer(markers: getMarkers());
  }
}
