import 'package:flutter/material.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Color.fromARGB(255, 39, 39, 43),
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyText2: TextStyle(
            fontSize: 16.0,
            color: Colors.black87,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.blueGrey,
            textStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: tasks.isEmpty
          ? Center(
              child: Text(
                'No hay tareas pendientes',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return _buildTaskCard(tasks[index], index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(0, 61, 36, 36),
        child: Container(
          height: 40.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Tareas Pendientes',
                style: TextStyle(
                  fontSize: 18.0,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTaskCard(Task task, int index) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              task.description,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tasks[index].isCompleted = !tasks[index].isCompleted;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: task.isCompleted ? Colors.green : Colors.grey,
                  ),
                  child: Text(
                    task.isCompleted ? 'Completado' : 'Completar',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _editTask(index);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  child: Text('Editar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tasks.removeAt(index);
                    });
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Text('Eliminar Tarea'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addTask() async {
    final task = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskFormScreen()),
    );

    if (task != null) {
      setState(() {
        tasks.add(task);
      });
    }
  }

  void _editTask(int index) async {
    final editedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: tasks[index]),
      ),
    );

    if (editedTask != null) {
      setState(() {
        tasks[index] = editedTask;
      });
    }
  }
}

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _isCompleted = widget.task!.isCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _titleController,
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), // Cambiar el color del texto en el campo de entrada
              decoration: InputDecoration(
                labelText: 'Título',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), // Cambiar el color del texto de la etiqueta
                filled: true, // Establecer el campo como lleno
                fillColor: Colors.white, // Establecer el color de fondo en blanco
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), // Cambiar el color del texto en el campo de entrada
              decoration: InputDecoration(
                labelText: 'Descripción',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), // Cambiar el color del texto de la etiqueta
                filled: true, // Establecer el campo como lleno
                fillColor: Colors.white, // Establecer el color de fondo en blanco
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
         
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  isCompleted: _isCompleted,
                );
                Navigator.pop(context, newTask);
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  final String title;
  final String description;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}

