import 'package:flutter/material.dart';
import 'package:flutter_liquidcore/liquidcore.dart';

void main() {
  //enableLiquidCoreLogging = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MicroService _microService;

  String _microServiceResponse = '<empty>';
  int _microServiceWorld = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FlutterLiquidcore Appxs'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: const Text('MicroService'),
                onPressed: initMicroService,
              ),
              Center(
                child: Text('MicroService response: $_microServiceResponse\n'),
              )
            ]),
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initMicroService() async {
    if (_microService == null) {
      String uri;

      // Android doesn't allow dashes in the res/raw directory.
      //uri = "android.resource://io.jojodev.flutter.liquidcoreexample/raw/liquidcore_sample";
      uri = "@flutter_assets/assets/resources/liquidcore_sample.js";
      //uri = "https://raw.githubusercontent.com/j0j00/flutter_liquidcore/master/example/Resources/liquidcore_sample.js";

      _microService = new MicroService(uri);
      await _microService.addEventListener('ready',
          (service, event, eventPayload) {
        // The service is ready.
        if (!mounted) {
          return;
        }
        //_emit();
      });
      await _microService.addEventListener('pong',
          (service, event, eventPayload) {
        if (!mounted) {
          return;
        }

        _setMicroServiceResponse(eventPayload['message'] as String);

        print("Got Pong: $eventPayload");
      });
      await _microService.addEventListener('object',
          (service, event, eventPayload) {
        if (!mounted) {
          return;
        }

        print("received obj: $eventPayload | type: ${eventPayload.runtimeType}");
      });

      // Start the service.
      await _microService.start();
    }

    if (_microService.isStarted) {
      _emit();
    }
  }

  void _emit() async {
    // Send the name over to the MicroService.
    await _microService.emit('ping', 'World ${++_microServiceWorld}');
  }

  void _setMicroServiceResponse(String message) {
    if (!mounted) {
      print("microService: widget not mounted");
      return;
    }

    setState(() {
      _microServiceResponse = message;
    });
  }
}
