import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'todo.dart';

class ItemList extends StatelessWidget {
  final Todo todo;
  final String transaksiDocId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference todoCollection;

  ItemList({
    Key? key,
    required this.todo,
    required this.transaksiDocId,
  }) : super(key: key) {
    todoCollection = _firestore.collection('Todos');
  }

  Future<void> deleteTodo() async {
    await todoCollection.doc(transaksiDocId).delete();
  }

  Future<void> updateTodo({
    required String title,
    required String description,
  }) async {
    await todoCollection.doc(transaksiDocId).update({
      'title': title,
      'description': description,
      'isComplete': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = TextEditingController(text: todo.title);
    TextEditingController _descriptionController = TextEditingController(text: todo.description);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Update Todo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Batalkan'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  updateTodo(
                    title: _titleController.text,
                    description: _descriptionController.text,
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    todo.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    todo.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: Icon(
                todo.isComplete
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: todo.isComplete ? Colors.blue : Colors.grey,
              ),
              onPressed: () {
                todoCollection.doc(transaksiDocId).update({
                  'isComplete': !todo.isComplete,
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: deleteTodo,
            ),
          ],
        ),
      ),
    );
  }
}
