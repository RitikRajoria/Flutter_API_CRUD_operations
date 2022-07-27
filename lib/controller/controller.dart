import '../data services/data_services.dart';
import '../models/todo_model.dart';

class TodoController {
  final DataService _dataService;

  TodoController(this._dataService);

  //GET
  Future<List<Todo>> fetchTodoList() async {
    return _dataService.getTodoList();
  }

  //PUT
  Future<List<String>> updateTodoCompleted(Todo todo) async {
    return _dataService.putCompleted(todo);
  }

  //DELETE
  Future<String> deleteTodoCompleted(Todo todo) async {
    return _dataService.deletedTodo(todo);
  }

  //POST
  Future<String> addTodoCompleted(Todo todo) async {
    return _dataService.postTodo(todo);
  }
}
