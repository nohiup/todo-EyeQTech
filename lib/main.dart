import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TODO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> tasks = [
    Task(title: 'Run', description: 'Run 20 miles.'),
    Task(title: 'Swim', description: 'Swim 10 miles.'),
    Task(title: 'Bike', description: 'Bike 50 miles.'),
  ];
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    // TODO: implement initState
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Add Task"),
                  actions: [
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: (){
                        if (_titleController.text.isEmpty
                            || _descriptionController.text.isEmpty){
                          return;
                        }
                        setState(() {
                          tasks.add(Task(title: _titleController.text,
                              description: _descriptionController.text));
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('Add'),
                    ),
                  ],
                  content: SizedBox(
                    height: 300,
                    width: 300,
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),
                        ),
                      ],
                    ),
                  )
                );
              });
            },
          ),
        ],
      ),
      body: Center(
        child:  _buildTaskList(),
      ),
    );
  }

  Widget _buildTaskList(){
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index){
      return _buildListTile(tasks.elementAt(index));
    });

  }

  Widget _buildListTile(Task task){
    return ListTile(
      title: task.isDone ?
      Text(task.title, style: TextStyle(decoration: TextDecoration.lineThrough)) : Text(task.title),
      subtitle: task.isDone?
          Text(task.description, style: TextStyle(decoration: TextDecoration.lineThrough)) : Text(task.description),
      trailing: Wrap(
        children: [
          task.isDone ?
              IconButton(
                icon: Icon(Icons.radio_button_unchecked),
                onPressed: (){
                  setState(() {
                    task.toggleDone();
                  });
                },
              ) : IconButton(
            icon: const Icon(Icons.check_circle),
            onPressed: (){
              setState(() {
                task.toggleDone();
              });
            },
          ),

          IconButton(
            icon: const Icon(Icons.delete),

            onPressed: (){
              setState(() {
                tasks.remove(task);
              });
            },
          ),

        ],
      )
    );
  }
}

class Task{
  final String title;
  final String description;
  bool isDone = false;

  Task({required this.title, required this.description});

  void toggleDone(){
    isDone = !isDone;
  }
}
