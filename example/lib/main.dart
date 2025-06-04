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
  String _result = 'No result yet';
  String _accessibilityData = 'No data yet';
  bool _isServiceEnabled = false;
  bool _isGraphQueryInitialized = false;
  final _crepePlugin = CrepePlugin();

  @override
  void initState() {
    super.initState();
    _checkServiceStatus();
  }

  Future<void> _checkServiceStatus() async {
    try {
      final enabled = await _crepePlugin.isAccessibilityServiceEnabled();
      setState(() => _isServiceEnabled = enabled);
    } catch (e) {
      setState(() => _result = 'Error checking service: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Crepe Plugin Test')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Service Status
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Service Status: ${_isServiceEnabled ? "Enabled" : "Disabled"}',
                          style: TextStyle(color: _isServiceEnabled ? Colors.green : Colors.red)),
                      Text('GraphQuery: ${_isGraphQueryInitialized ? "Initialized" : "Not Initialized"}',
                          style: TextStyle(color: _isGraphQueryInitialized ? Colors.green : Colors.red)),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Basic Methods
              const Text('Basic Methods', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final result = await _crepePlugin.echo('Hello World');
                    setState(() => _result = result ?? 'null');
                  } catch (e) {
                    setState(() => _result = 'Error: $e');
                  }
                },
                child: const Text('Test Echo'),
              ),
              
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _crepePlugin.requestAccessibilityPermission();
                    setState(() => _result = 'Permission requested');
                    _checkServiceStatus();
                  } catch (e) {
                    setState(() => _result = 'Permission Error: $e');
                  }
                },
                child: const Text('Request Accessibility Permission'),
              ),
              
              const SizedBox(height: 20),
              
              // Accessibility Service Methods
              const Text('Accessibility Service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final result = await _crepePlugin.startAccessibilityService();
                          final success = result['success'] ?? false;
                          final message = result['message'] ?? 'Unknown result';
                          final requiresManual = result['requiresManualEnable'] ?? false;
                          
                          setState(() => _result = success 
                              ? 'Service already enabled' 
                              : (requiresManual 
                                  ? 'Please enable service in Settings: $message'
                                  : message));
                          
                          _checkServiceStatus();
                        } catch (e) {
                          setState(() => _result = 'Start Error: $e');
                        }
                      },
                      child: const Text('Start Service'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final result = await _crepePlugin.stopAccessibilityService();
                          final success = result['success'] ?? false;
                          final message = result['message'] ?? 'Unknown result';
                          final requiresManual = result['requiresManualDisable'] ?? false;
                          
                          setState(() => _result = success 
                              ? 'Service already disabled' 
                              : (requiresManual 
                                  ? 'Please disable service in Settings: $message'
                                  : message));
                          
                          _checkServiceStatus();
                        } catch (e) {
                          setState(() => _result = 'Stop Error: $e');
                        }
                      },
                      child: const Text('Stop Service'),
                    ),
                  ),
                ],
              ),
              
              ElevatedButton(
                onPressed: () async {
                  try {
                    final data = await _crepePlugin.getAccessibilityData();
                    setState(() => _accessibilityData = data ?? 'No data');
                  } catch (e) {
                    setState(() => _accessibilityData = 'Data Error: $e');
                  }
                },
                child: const Text('Get Accessibility Data'),
              ),
              
              const SizedBox(height: 20),
              
              // GraphQuery Methods
              const Text('GraphQuery Methods', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _crepePlugin.initializeGraphQuery();
                    setState(() {
                      _result = 'GraphQuery Initialized';
                      _isGraphQueryInitialized = true;
                    });
                  } catch (e) {
                    setState(() => _result = 'GraphQuery Init Error: $e');
                  }
                },
                child: const Text('Initialize GraphQuery'),
              ),
              
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _crepePlugin.updateSnapshot();
                    setState(() => _result = 'Snapshot Updated');
                  } catch (e) {
                    setState(() => _result = 'Snapshot Error: $e');
                  }
                },
                child: const Text('Update Snapshot'),
              ),
              
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Example query to find clickable text elements
                    final results = await _crepePlugin.queryGraph(
                      "(conj (IS_CLICKABLE true) (HAS_CLASS_NAME android.widget.TextView))"
                    );
                    setState(() => _result = 'Query Results: ${results.toString()}');
                  } catch (e) {
                    setState(() => _result = 'Query Error: $e');
                  }
                },
                child: const Text('Test Query (Clickable Text)'),
              ),
              
              const SizedBox(height: 20),
              
              // Results Display
              const Text('Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Result: $_result'),
                      const SizedBox(height: 8),
                      Text('Accessibility Data: $_accessibilityData'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}