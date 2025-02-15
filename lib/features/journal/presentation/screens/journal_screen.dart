import 'package:flutter/material.dart';
import '../../data/datasources/journal_database_helper.dart';
import '../../data/models/journal_entry_model.dart';
import 'journal_detail_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  late Future<List<JournalEntry>> _journalEntries;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    _journalEntries = JournalDatabaseHelper.instance.getAllEntries();
  }

  void _showAddEntryBottomSheet() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

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
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (titleController.text.isNotEmpty) {
                        final entry = JournalEntry(
                          title: titleController.text,
                          description: descriptionController.text,
                          createdAt: DateTime.now(),
                        );
                        await JournalDatabaseHelper.instance.create(entry);
                        if (mounted) {
                          setState(() {
                            _loadEntries();
                          });
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text('Save', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
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
                        'Notes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
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
        title: const Text('Journal', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18,),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showAddEntryBottomSheet();
            },
            icon: const Icon(Icons.add, color: Colors.black, size: 24,),
          ),
        ],
      ),
      
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<JournalEntry>>(
              future: _journalEntries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final entries = snapshot.data ?? [];

                // if (entries.isEmpty) {
                //   return const Center(
                //     child: Text('No journal entries yet. Add one to get started!'),
                //   );
                // }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JournalDetailScreen(entry: entry),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          title: Text(
                            entry.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(entry.description),
                              const SizedBox(height: 4),
                              Text(
                                entry.createdAt.toString(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
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
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _showAddEntryBottomSheet,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New Journal Entry', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                  const SizedBox(width: 8),
                  const Icon(Icons.add, color: Colors.black, size: 20,),
                ],  
              ),
            ),
          ),
        ],
      ),
    );
  }
} 