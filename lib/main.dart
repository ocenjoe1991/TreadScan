import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'ui/image_analysis_page.dart';

void main() {
  runApp(const TireDepthApp());
}

class TireDepthApp extends StatelessWidget {
  const TireDepthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tire Depth Analyzer',
      theme: ThemeData.dark(),
      home: const MainTabs(),
    );
  }
}

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tier Analyser'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Analysis'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          IdentifyTab(),
          HistoryTab(),
        ],
      ),
    );
  }
}


class IdentifyTab extends StatefulWidget {
  const IdentifyTab({super.key});

  @override
  State<IdentifyTab> createState() => _IdentifyTabState();
}

class _IdentifyTabState extends State<IdentifyTab> {
  Uint8List? lastAnalyzedImage;
  String? analysisResult;
  String? depth;
  String? carType;
  String? tireSize;
  String? tireBrand;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      final imageBytes = await image.readAsBytes();
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageAnalysisPage(image: imageBytes),
        ),
      ).then((result) {
        if (result is Map) {
          setState(() {
            lastAnalyzedImage = result['image'];
            depth = result['depth'];
            carType = result['carType'];
            tireSize = result['tireSize'];
            tireBrand = result['tireBrand'];
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Trained Image', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: lastAnalyzedImage == null
                  ? const Center(child: Text('No Trained Image.'))
                  : Image.memory(lastAnalyzedImage!, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Result of analysis', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: analysisResult == null
                      ? const Center(child: Text('No result of analysis.'))
                      : SingleChildScrollView(child: Text(analysisResult!)),
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () => pickImage(ImageSource.camera), child: const Text('Camera')),
              ElevatedButton(onPressed: () => pickImage(ImageSource.gallery), child: const Text('Gallery')),
            ],
          ),
        ],
      ),
    );
  }
}

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  final List<String> historyList = ['history 1', 'history 2', 'history 3'];
  String? selectedHistory;
  Uint8List? historyImage;
  String depth = '7.5';
  String carType = 'SUV';
  String tireSize = '225/60R17';
  String tireBrand = 'Michelin';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('History', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: ListView.builder(
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  final item = historyList[index];
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      setState(() {
                        selectedHistory = item;
                        //
                      });
                    },
                    selected: selectedHistory == item,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: historyImage == null
                        ? const Center(child: Text('No image selected.'))
                        : Image.memory(historyImage!, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('depth: $depth mm'),
                        Text('car type: $carType'),
                        Text('tire size: $tireSize'),
                        Text('car brand: $tireBrand'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


