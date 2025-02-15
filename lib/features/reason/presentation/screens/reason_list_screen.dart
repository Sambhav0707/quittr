import 'package:flutter/material.dart';
import '../../data/datasources/database_helper.dart';
import '../../data/models/reason_model.dart';
import '../screens/reason_detail_screen.dart';

class ReasonListScreen extends StatefulWidget {
  const ReasonListScreen({Key? key}) : super(key: key);

  @override
  State<ReasonListScreen> createState() => _ReasonListScreenState();
}

class _ReasonListScreenState extends State<ReasonListScreen> {
  final TextEditingController _reasonController = TextEditingController();

  void _showAddReasonBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _reasonController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_reasonController.text.isNotEmpty) {
                        final reason = ReasonModel(
                          reason: _reasonController.text,
                          createdAt: DateTime.now(),
                        );
                        await DatabaseHelper.instance.create(reason);
                        _reasonController.clear();
                        Navigator.pop(context);
                        setState(() {});
                      }
                    },
                    child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New Reason',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _reasonController,
                        decoration: const InputDecoration(
                          labelText: 'Enter your reason',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reasons for Change', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18,),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black, size: 22,),
            onPressed: _showAddReasonBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<ReasonModel>>(
              future: DatabaseHelper.instance.getAllReasons(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No reasons added yet'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final reason = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => ReasonDetailScreen(reason: reason)
                          )
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 16, right: 0, top: 0, bottom: 0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          title: Text(
                            reason.reason,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, 
                            color: Colors.grey, 
                            size: 18,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showAddReasonBottomSheet,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                    'New Reason',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.add, color: Theme.of(context).colorScheme.onSurface,),
                    ],
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
} 