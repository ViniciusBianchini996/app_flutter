import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ACQA Flutter',
      theme: ThemeData(primarySwatch: Colors.red),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  void login() {
    String email = emailController.text;
    String senha = senhaController.text;
    if (email.isNotEmpty && senha.isNotEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CalendarPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Login', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 10),
            TextField(controller: senhaController, decoration: InputDecoration(labelText: 'Senha'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text('Entrar')),
          ]),
        ),
      ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();
  Map<String, List<Task>> tasks = {};

  void addTask(String title) {
    String key = selectedDate.toIso8601String().split('T')[0];
    if (!tasks.containsKey(key)) tasks[key] = [];
    tasks[key]!.add(Task(title));
    setState(() {});
  }

  void removeTask(Task task) {
    String key = selectedDate.toIso8601String().split('T')[0];
    tasks[key]!.remove(task);
    setState(() {});
  }

  List<Task> getTasksForDay() {
    String key = selectedDate.toIso8601String().split('T')[0];
    if (!tasks.containsKey(key)) return [];
    List<Task> dayTasks = List.from(tasks[key]!);
    dayTasks.sort((a, b) {
      if (a.done && !b.done) return 1;
      if (!a.done && b.done) return -1;
      return a.title.compareTo(b.title);
    });
    return dayTasks;
  }

  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  void showAddTaskDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Nova tarefa'),
              content: TextField(controller: controller),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar')),
                TextButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) addTask(controller.text);
                      Navigator.pop(context);
                    },
                    child: Text('Adicionar')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    List<Task> dayTasks = getTasksForDay();
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(icon: Icon(Icons.calendar_today), onPressed: pickDate),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Text('Tarefas de ${selectedDate.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
                  itemCount: dayTasks.length,
                  itemBuilder: (context, index) {
                    Task task = dayTasks[index];
                    return ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.done ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                      leading: Checkbox(
                        value: task.done,
                        onChanged: (val) => setState(() => task.done = val!),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => removeTask(task),
                      ),
                    );
                  }))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class Task {
  String title;
  bool done;
  Task(this.title) : done = false;
}
