import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/controller/controller.dart';
import 'package:flutter_application_2/data%20services/data_services.dart';
import 'package:flutter_application_2/models/todo_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var todoController = TodoController(TodoDataService());

    todoController.fetchTodoList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(child: Text('Todo App')),
        backgroundColor: Color(0xffF1DDBF),
      ),
      body: FutureBuilder<List<Todo>>(
        future: todoController.fetchTodoList(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('error'),
            );
          }

          return ListView.separated(
              itemBuilder: (context, index) {
                var todo = snapshot.data?[index];

                return Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text('${todo!.id}'),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('${todo.title} // ${todo.completed}'),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                todoController
                                    .updateTodoCompleted(todo)
                                    .then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      content: Text('Todo Updated'),
                                    ),
                                  );
                                });
                              },
                              child: functionButtons(
                                'EDIT',
                                Color(0xffD9D7F1),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  todoController
                                      .deleteTodoCompleted(todo)
                                      .then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        content: Text('Todo Deleted  = $value'),
                                      ),
                                    );
                                  });
                                },
                                child:
                                    functionButtons('🗑️', Color(0xffF3E9DD))),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 8.5,
                  height: 0.5,
                );
              },
              itemCount: snapshot.data!.length);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Todo todo =
              Todo(userId: 3, title: 'new user created todo', completed: false);
          todoController.addTodoCompleted(todo).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 800),
                content: Text(value == 'true'
                    ? 'New Todo Added'
                    : 'Server Error try again later!'),
              ),
            );
          });
        },
        backgroundColor: Color(0xffCDC2AE),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget functionButtons(String name, Color color) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Chip(
            backgroundColor: color,
            padding: EdgeInsets.all(8),
            label: Text(
              '$name',
              style: TextStyle(
                fontSize: 14,
              ),
            )),
      );
}
