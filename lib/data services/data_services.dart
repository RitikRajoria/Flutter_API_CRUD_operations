import 'dart:convert';

import 'package:flutter_application_2/models/todo_model.dart';
import 'package:http/http.dart' as http;

abstract class DataService {
  //GET
  Future<List<Todo>> getTodoList();
  //PUT
  Future<List<String>> putCompleted(Todo todo);
  //DELETED
  Future<String> deletedTodo(Todo todo);
  //POST
  Future<String> postTodo(Todo todo);
}

class TodoDataService implements DataService {
  String baseUrl = 'https://jsonplaceholder.typicode.com';

//GET
  @override
  Future<List<Todo>> getTodoList() async {
    List<Todo> todoList = [];
    var url = Uri.parse('$baseUrl/todos');
    var response = await http.get(url);
    print('status code: ${response.statusCode}');
    var body = json.decode(response.body);
    for (int i = 0; i < body.length; i++) {
      todoList.add(Todo.fromJson(body[i]));
    }
    return todoList;
  }

  //POST
  @override
  Future<String> postTodo(Todo todo) async{
    print('${todo.toJson()}');
    var url = Uri.parse('$baseUrl/todos/');
    var result = '';
    var response = await http.post(url, body: todo.toJson());
    print(response.statusCode);
    print(response.body);
    return 'true';
  }

  //PUT
  @override
  Future<List<String>> putCompleted(Todo todo) async {
    var url = Uri.parse('$baseUrl/todos/${todo.id}');

    List<String> resData = [];
    await http.put(
      url,
      body: {
        'completed': (!todo.completed!).toString(),
        'title': ' updated todo title',
      },
    ).then((response) {
      Map<String, dynamic> result = json.decode(response.body);
      print(result);
      return resData.add(result.toString());
    });

    return resData;
  }

  //DELETE
  @override
  Future<String> deletedTodo(Todo todo) async {
    var url = Uri.parse('$baseUrl/todos/${todo.id}');
    var result = 'false';

    await http.delete(url).then((value) {
      print(value.body);

      return result = 'true';
    });
    return result;
  }
}
