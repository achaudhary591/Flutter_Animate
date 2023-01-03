import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:form_field_validator/form_field_validator.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Page1(),
    ),
  );
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(_assignment1());
              },
              child: const Text('Assignment 1'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(_assignment2());
              },
              child: const Text('Assignment 2'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(_assignment3());
              },
              child: const Text('Assignment 3'),
            ),
          ),
        ],
      ),
    );
  }
}

Route _assignment1() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const PhysicsCardDragDemo1(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route _assignment2() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const PhysicsCardDragDemo(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route _assignment3() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const MyCustomForm(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class PhysicsCardDragDemo1 extends StatelessWidget {
  const PhysicsCardDragDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Animate"),
      ),
      body: const DraggableCard(
        child: FlutterLogo(
          size: 128,
        ),
      ),
    );
  }
}

class PhysicsCardDragDemo extends StatelessWidget {
  const PhysicsCardDragDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon:const Icon(Icons.arrow_back_rounded),
                //replace with our own icon data.
              ),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: const Text('Tabs Demo'),
          ),
          body: const TabBarView(
              children: [
                DraggableCard(
                    child: FlutterLogo(
                      size: 128,
                      //colors: Colors.red,
                      style: FlutterLogoStyle.horizontal,
                      curve: Curves.bounceInOut,
                      duration: Duration(seconds: 1),
                    ),
                ),
                DraggableCard(
                    child: FlutterLogo(
                      size: 128,
                      style: FlutterLogoStyle.stacked,
                      curve: Curves.linearToEaseOut,
                      duration: Duration(seconds: 5),
                    ),
                ),
                DraggableCard(
                  child: FlutterLogo(
                    size: 128,
                    style: FlutterLogoStyle.markOnly,
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(seconds: 5),
                    textColor: Colors.red,
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}



/// A draggable card that moves back to [Alignment.center] when it's
/// released.
class DraggableCard extends StatefulWidget {
  const DraggableCard({required this.child, super.key});

  final Widget child;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// The alignment of the card as it is dragged or being animated.
  ///
  /// While the card is being dragged, this value is set to the values computed
  /// in the GestureDetector onPanUpdate callback. If the animation is running,
  /// this value is set to the value of the [_animation].
  Alignment _dragAlignment = Alignment.center;

  late Animation<Alignment> _animation;

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanDown: (details) {
        _controller.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2),
          );
        });
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Align(
        alignment: _dragAlignment,
        child: Card(
          child: widget.child,
        ),
      ),
    );
  }
}

//Assignment 3 started

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon:const Icon(Icons.arrow_back_rounded),
            //replace with our own icon data.
          ),
          title: const Text(appTitle),
        ),
        body: const MyCustomFormHelper(),
      ),
    );
  }
}

class MyCustomFormHelper extends StatefulWidget {
  const MyCustomFormHelper({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomFormHelper> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "* Required";
    } else if (value.length < 6) {
      return "Password should be atleast 6 characters";
    } else if (value.length > 15) {
      return "Password should not be greater than 15 characters";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.always, //check for validation while typing
          key: formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: SizedBox(
                      width: 200,
                      height: 150,
                      child: Image.asset('assets/images/flutter-logo.png')),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter valid email id as abc@gmail.com'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                      EmailValidator(errorText: "Enter valid email id"),
                    ])),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter secure password'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                      MinLengthValidator(6,
                          errorText: "Password should be atleast 6 characters"),
                      MaxLengthValidator(15,
                          errorText:
                          "Password should not be greater than 15 characters")
                    ])
                  //validatePassword,        //Function to check validation
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FormApp()));
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const Page1()));
                      print("Validated");
                    } else {
                      print("Not Validated");
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              const Text('New User? Create Account')
            ],
          ),
        ),
      ),
    );
  }
}

class FormApp extends StatelessWidget {
  const FormApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Form Demo',
      theme: ThemeData(),
      home: const FormPage(title: 'Flutter Form Demo Page'),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon:const Icon(Icons.arrow_back_rounded),
          //replace with our own icon data.
        ),
        title: Text(widget.title),
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SignUpForm()),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

  String _name = '';
  String _email = '';
  int _age = -1;
  String _maritalStatus = 'single';
  int _selectedGender = 0;
  String _password = '';
  bool _termsChecked = true;

  List<DropdownMenuItem<int>> genderList = [];

  void loadGenderList() {
    genderList = [];
    genderList.add(const DropdownMenuItem(
      child: Text('Male'),
      value: 0,
    ));
    genderList.add(const DropdownMenuItem(
      child: Text('Female'),
      value: 1,
    ));
    genderList.add(const DropdownMenuItem(
      child: Text('Others'),
      value: 2,
    ));
  }

  @override
  Widget build(BuildContext context) {
    loadGenderList();
    // Build a Form widget using the _formKey we created above
    return Form(
        key: _formKey,
        child: ListView(
          children: getFormWidget(),
        ));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = [];

    formWidget.add(TextFormField(
      decoration:
      const InputDecoration(labelText: 'Enter Name', hintText: 'Name'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a name';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _name = value.toString();
        });
      },
    ));

    validateEmail(String? value) {
      if (value!.isEmpty) {
        return 'Please enter mail';
      }

      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern.toString());
      if (!regex.hasMatch(value.toString())) {
        return 'Enter Valid Email';
      } else {
        return null;
      }
    }

    formWidget.add(TextFormField(
      decoration:
      const InputDecoration(labelText: 'Enter Email', hintText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      onSaved: (value) {
        setState(() {
          _email = value.toString();
        });
      },
    ));

    formWidget.add(TextFormField(
      decoration:
      const InputDecoration(hintText: 'Age', labelText: 'Enter Age'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter age';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _age = int.parse(value.toString());
        });
      },
    ));

    formWidget.add(DropdownButton(
      hint: const Text('Select Gender'),
      items: genderList,
      value: _selectedGender,
      onChanged: (value) {
        setState(() {
          _selectedGender = int.parse(value.toString());
        });
      },
      isExpanded: true,
    ));

    formWidget.add(Column(
      children: <Widget>[
        RadioListTile<String>(
          title: const Text('Single'),
          value: 'single',
          groupValue: _maritalStatus,
          onChanged: (value) {
            setState(() {
              _maritalStatus = value.toString();
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Married'),
          value: 'married',
          groupValue: _maritalStatus,
          onChanged: (value) {
            setState(() {
              _maritalStatus = value.toString();
            });
          },
        ),
      ],
    ));

    formWidget.add(
      TextFormField(
          key: _passKey,
          obscureText: true,
          decoration: const InputDecoration(
              hintText: 'Password', labelText: 'Enter Password'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter password';
            } else if (value.length < 8) {
              return 'Password should be more than 8 characters';
            } else {
              return null;
            }
          }),
    );

    formWidget.add(
      TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
              hintText: 'Confirm Password',
              labelText: 'Enter Confirm Password'),
          validator: (confirmPassword) {
            if (confirmPassword != null && confirmPassword.isEmpty) {
              return 'Enter confirm password';
            }
            var password = _passKey.currentState?.value;
            if (confirmPassword != null &&
                confirmPassword.compareTo(password) != 0) {
              return 'Password mismatch';
            } else {
              return null;
            }
          },
          onSaved: (value) {
            setState(() {
              _password = value.toString();
            });
          }),
    );

    formWidget.add(CheckboxListTile(
      value: _termsChecked,
      onChanged: (value) {
        setState(() {
          _termsChecked = value.toString().toLowerCase() == 'true';
        });
      },
      subtitle: !_termsChecked
          ? const Text(
        'Required',
        style: TextStyle(color: Colors.red, fontSize: 12.0),
      )
          : null,
      title: const Text(
        'I agree to the terms and condition',
      ),
      controlAffinity: ListTileControlAffinity.leading,
    ));

    void onPressedSubmit() {
      if (_formKey.currentState!.validate() && _termsChecked) {
        _formKey.currentState?.save();

        print("Name " + _name);
        print("Email " + _email);
        print("Age " + _age.toString());
        switch (_selectedGender) {
          case 0:
            print("Gender Male");
            break;
          case 1:
            print("Gender Female");
            break;
          case 3:
            print("Gender Others");
            break;
        }
        print("Marital Status " + _maritalStatus);
        print("Password " + _password);
        print("Termschecked " + _termsChecked.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Form Submitted')));
      }
    }

    formWidget.add(ElevatedButton(
        child: const Text('Sign Up'), onPressed: onPressedSubmit));

    return formWidget;
  }
}



