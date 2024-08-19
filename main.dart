//import 'package:english_words/english_words.dart';
// ignore_for_file: non_constant_identifier_names

//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromRGBO(255, 105, 180, 50)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<String> recipeNames = [];
  List<List<String>> ingredientLists = [];
  List<List<String>> stepsLists = [];
  List<String> tempIngredients = [];
  List<String> tempSteps = [];
  List<bool?> ingredientPresent = [];
  int openRecipe = 0;

  void saveRecipe(String recipeName, List<TextEditingController> ingredients,
      List<TextEditingController> steps) {
    recipeNames.add(recipeName);
    tempIngredients = [];
    tempSteps = [];
    for (final tempController in ingredients) {
      tempIngredients.add(tempController.text);
    }
    ingredientLists.add(tempIngredients);
    for (final tempController in steps) {
      tempSteps.add(tempController.text);
    }
    stepsLists.add(tempSteps);
    notifyListeners();
  }

  void passRecipeNumber(int num) {
    openRecipe = num;
    ingredientPresent = [];
    for (int i = 0; i < ingredientLists[num].length; i++) {
      ingredientPresent.add(false);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = NewRecipe();
        break;
      case 2:
        page = BrowseRecipes();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                      icon: Icon(Icons.home), label: Text('home page')),
                  NavigationRailDestination(
                      icon: Icon(Icons.add), label: Text('new recipe')),
                  NavigationRailDestination(
                      icon: Icon(Icons.dining_outlined),
                      label: Text('browse recipes')),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 50,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Card(
            color: Theme.of(context).colorScheme.surfaceTint,
            child: SizedBox(
              width: 600,
              height: 100,
              child: Center(
                  child: Text(
                'Welcome to the home page!',
                style: TextStyle(
                    color: Color.fromRGBO(254, 216, 229, 0.925),
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              )),
            ))
      ]),
    ]);
  }
}

class NewRecipe extends StatefulWidget {
  @override
  State<NewRecipe> createState() => _NewRecipeState();
}

class _NewRecipeState extends State<NewRecipe> {
  final controllerName = TextEditingController();
  List<TextEditingController> ingredients = [];
  List<TextField> ingredientFields = [];
  List<TextEditingController> steps = [];
  List<TextField> stepFields = [];

  @override
  void dispose() {
    for (final controller in ingredients) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pageState = context.watch<MyAppState>();
    return Scaffold(
        backgroundColor: Color.fromRGBO(254, 216, 229, 255),
        body: Column(children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                  color: Theme.of(context).colorScheme.surfaceTint,
                  child: SizedBox(
                    height: 100,
                    width: 600,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controllerName,
                        showCursor: true,
                        cursorColor: Color.fromRGBO(254, 216, 229, 0.925),
                        style: TextStyle(
                            color: Color.fromRGBO(254, 216, 229, 0.925),
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            hintText: 'adding a new recipe!',
                            border: OutlineInputBorder()),
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: SizedBox(
                  height: 80,
                  width: 150,
                  child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.save_alt,
                        size: 30,
                      ),
                      onPressed: () {
                        pageState.saveRecipe(
                            controllerName.text, ingredients, steps);
                        controllerName.clear();
                        for (int i = 0; i < ingredients.length; i++) {
                          ingredients[i].clear();
                        }
                        for (int i = 0; i < steps.length; i++) {
                          steps[i].clear();
                        }
                        for (int i = 0; i < ingredientFields.length; i++) {
                          ingredientFields.clear();
                        }
                        for (int i = 0; i < stepFields.length; i++) {
                          stepFields.clear();
                        }
                      },
                      style: ButtonStyle(),
                      label: Text(
                        'Save',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.surfaceTint,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Text(
                  'Ingredients:',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.surfaceTint,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              )),
          drawingFieldsForIngredients(),
          Expanded(child: ListViewOfFieldsIngredients()),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text('Preparation steps:',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.surfaceTint,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          drawingFieldsForSteps(),
          Expanded(child: ListViewOfFieldsSteps()),
          SizedBox(
            height: 20,
          ),
        ]));
  }

  Widget drawingFieldsForIngredients() {
    return ListTile(
      title: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.surfaceTint,
      ),
      onTap: () {
        final tempController = TextEditingController();
        final field = TextField(
          controller: tempController,
          showCursor: true,
          cursorColor: Theme.of(context).colorScheme.surfaceTint,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surfaceTint,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
              hintText: 'type in an ingredient',
              hintStyle: TextStyle(
                color: Color.fromRGBO(100, 100, 100, 0.9),
              ),
              border: OutlineInputBorder()),
        );
        setState(() {
          ingredients.add(tempController);
          ingredientFields.add(field);
        });
      },
    );
  }

  Widget ListViewOfFieldsIngredients() {
    return ListView.builder(
      itemCount: ingredientFields.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(5),
          child: ingredientFields[index],
        );
      },
    );
  }

  Widget drawingFieldsForSteps() {
    return ListTile(
      title: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.surfaceTint,
      ),
      onTap: () {
        final tempController = TextEditingController();
        final field = TextField(
          controller: tempController,
          showCursor: true,
          cursorColor: Theme.of(context).colorScheme.surfaceTint,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surfaceTint,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
              hintText: 'type in step ${steps.length + 1}',
              hintStyle: TextStyle(
                color: Color.fromRGBO(100, 100, 100, 0.9),
              ),
              border: OutlineInputBorder()),
        );
        setState(() {
          steps.add(tempController);
          stepFields.add(field);
        });
      },
    );
  }

  Widget ListViewOfFieldsSteps() {
    return ListView.builder(
      itemCount: stepFields.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(5),
          child: stepFields[index],
        );
      },
    );
  }
}

class BrowseRecipes extends StatefulWidget {
  @override
  State<BrowseRecipes> createState() => _BrowseRecipesState();
}

class _BrowseRecipesState extends State<BrowseRecipes> {
  @override
  Widget build(BuildContext context) {
    var pageState = context.watch<MyAppState>();
    return ListView(
      children: [
        Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Card(
              color: Theme.of(context).colorScheme.surfaceTint,
              child: SizedBox(
                width: 600,
                height: 100,
                child: Center(
                    child: Text(
                  'You have ' '${pageState.recipeNames.length} recipes so far:',
                  style: TextStyle(
                      color: Color.fromRGBO(254, 216, 229, 0.925),
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
            for (int i = 0; i < pageState.recipeNames.length; i++)
              ListTile(
                leading: ElevatedButton.icon(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.surfaceTint,
                    size: 30,
                  ),
                  onPressed: () {
                    pageState.passRecipeNumber(i);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => recipePage()));
                  },
                  label: Text(''),
                ),
                title: Text(
                  pageState.recipeNames[i],
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.surfaceTint,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              )
          ],
        ),
      ],
    );
  }
}

class recipePage extends StatefulWidget {
  @override
  State<recipePage> createState() => _recipePageState();
}

class _recipePageState extends State<recipePage> {
  @override
  Widget build(BuildContext context) {
    var pageState = context.watch<MyAppState>();
    int neededRecipe = pageState.openRecipe;

    return Scaffold(
        backgroundColor: Color.fromRGBO(254, 216, 229, 1),
        body: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: SizedBox(
                    height: 80,
                    width: 150,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30,
                        ),
                        label: Text(
                          'back',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surfaceTint,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                Card(
                  color: Theme.of(context).colorScheme.surfaceTint,
                  child: SizedBox(
                      height: 100,
                      width: 600,
                      child: Center(
                          child: Text(
                        '${pageState.recipeNames[neededRecipe]}',
                        style: TextStyle(
                          color: Color.fromRGBO(254, 216, 229, 0.925),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ))),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Text('Ingredients:',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceTint,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ))),
            ),
            for (int i = 0;
                i < pageState.ingredientLists[neededRecipe].length;
                i++)
              Padding(
                padding: const EdgeInsets.only(left: 80),
                child: ListTile(
                  leading: Checkbox(
                    value: pageState.ingredientPresent[i],
                    activeColor: Theme.of(context).colorScheme.surfaceTint,
                    onChanged: (newBool) {
                      setState(() {
                        pageState.ingredientPresent[i] = newBool;
                      });
                    },
                  ),
                  title: Text(
                    '${pageState.ingredientLists[neededRecipe][i]}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceTint,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Text('Preparation steps:',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceTint,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ))),
            ),
            for (int i = 0; i < pageState.stepsLists[neededRecipe].length; i++)
              Padding(
                padding: const EdgeInsets.only(left: 80),
                child: ListTile(
                  leading: Text(
                    '${i + 1}.  ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceTint,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  title: Text(
                    '${pageState.stepsLists[neededRecipe][i]}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceTint,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}

/*
fix not disappearing fields
*/
