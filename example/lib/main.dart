import 'package:flutter/material.dart';
import 'package:formio/formio.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<FormModel> forms = [];
  int index = 0;

  @override
  void initState() {
    ApiClient.setBaseUrl(Uri.parse('https://formio.spinex.io'));
    final formService = FormService(ApiClient());
    formService.fetchForms().then((e) {
      forms = e;
      // Debug: print(forms.length);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text('Form Number: ${index + 1} of ${forms.length}'),
          ),
          Container(
              padding: const EdgeInsets.all(20),
              child: forms.isEmpty
                  ? const SizedBox()
                  : FormRenderer(
                      form: forms[index],
                    )),
          Container(padding: const EdgeInsets.all(20), child: forms.isEmpty ? const SizedBox() : Text(forms[index].toJson().toString())),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (forms.isNotEmpty && forms.length > index + 1) {
            index++;
          }
          setState(() {
            // Debug: print(jsonEncode(forms[index]));
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
