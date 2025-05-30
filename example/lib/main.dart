import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:crepe_plugin/crepe_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _echoResult = 'No result yet';
  String _serviceStatus = 'Not started';
  String _accessibilityData = 'No data yet';
  final _crepePlugin = CrepePlugin();
  
  // Counter for generating accessibility events
  int _counter = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the counter timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _counter++;
        if (_counter >= 100) {
          _counter = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Floating Title
                const Text(
                  'Crepe Plugin Demo',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Instructions Card
                SizedBox(
                  width: 350,
                  child: Card(
                    color: Colors.orange[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.info, color: Colors.orange, size: 32),
                          const SizedBox(height: 8),
                          const Text(
                            'How to Test',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '1. Tap "Start Service"\n'
                            '2. Go to Settings → Accessibility\n'
                            '3. Enable "Crepe Plugin Accessibility Service"\n'
                            '4. Use other apps (tap buttons, type text)\n'
                            '5. Return here and tap "Get Latest Data"',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                await _crepePlugin.openAccessibilitySettings();
                              } catch (e) {
                                // Show error if settings can't be opened
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error opening settings: $e')),
                                );
                              }
                            },
                            icon: const Icon(Icons.settings),
                            label: const Text('Open Accessibility Settings'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Counter for testing accessibility events
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!, width: 1),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.timer, color: Colors.blue, size: 24),
                      const SizedBox(height: 8),
                      const Text(
                        'Test Counter',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_counter',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Updates every second to generate accessibility events',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Accessibility Service Section
                SizedBox(
                  width: 350,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Accessibility Service',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'This service captures text from UI events across the device.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          
                          SizedBox(
                            width: 250,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  await _crepePlugin.startAccessibilityService();
                                  setState(() => _serviceStatus = 'Service Started - Enable in Settings!');
                                } catch (e) {
                                  setState(() => _serviceStatus = 'Start Error: $e');
                                }
                              },
                              icon: const Icon(Icons.play_circle),
                              label: const Text('Start Service'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          SizedBox(
                            width: 250,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  final data = await _crepePlugin.getAccessibilityData();
                                  setState(() => _accessibilityData = data ?? 'No data captured yet');
                                } catch (e) {
                                  setState(() => _accessibilityData = 'Data Error: $e');
                                }
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Get Latest Data'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          SizedBox(
                            width: 250,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  await _crepePlugin.stopAccessibilityService();
                                  setState(() => _serviceStatus = 'Service Stopped');
                                } catch (e) {
                                  setState(() => _serviceStatus = 'Stop Error: $e');
                                }
                              },
                              icon: const Icon(Icons.stop_circle),
                              label: const Text('Stop Service'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Service Status:',
                                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[600]),
                                ),
                                Text(_serviceStatus, style: const TextStyle(fontFamily: 'monospace')),
                                const SizedBox(height: 8),
                                Text(
                                  'Latest Captured Data:',
                                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[600]),
                                ),
                                Text(
                                  _accessibilityData,
                                  style: const TextStyle(fontFamily: 'monospace'),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Echo Test Section
                SizedBox(
                  width: 350,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Echo Test',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  final result = await _crepePlugin.echo('Hello World');
                                  setState(() => _echoResult = result ?? 'null');
                                } catch (e) {
                                  setState(() => _echoResult = 'Error: $e');
                                }
                              },
                              child: const Text('Test Echo'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Echo Result: $_echoResult',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}