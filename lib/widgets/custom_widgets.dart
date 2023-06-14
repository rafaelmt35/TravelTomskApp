import 'package:flutter/material.dart';

class Nexttripmenu extends StatelessWidget {
  final String imagename;
  final String title;
  final String desc;
  const Nexttripmenu(
      {Key? key,
      required this.imagename,
      required this.title,
      required this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
          margin: const EdgeInsets.only(left: 10),
          height: 150,
          width: 355,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 120,
                height: 144,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // ignore: unnecessary_new
                  image: new DecorationImage(
                    image: NetworkImage(imagename),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 0, 0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 144,
                    width: 201,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            title,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            desc,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: FloatingActionButton(
                              heroTag: null,
                              backgroundColor:const Color(0xff588CDA),
                              elevation: 0.2,
                              onPressed: () {},
                              child: const Icon(
                                Icons.double_arrow_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

//city card menu
class Citycardmenu extends StatelessWidget {
  final String imagename;
  final String cityname;
  final void Function(BuildContext) callback;
  const Citycardmenu(
      {Key? key,
      required this.imagename,
      required this.cityname,
      required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => callback.call(context),
        child: Container(
            width: 172,
            height: 180,
            decoration: BoxDecoration(
                // ignore: unnecessary_new
                image: new DecorationImage(
                  image: NetworkImage(imagename),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.black.withOpacity(0.5),
                ),
                height: 34,
                width: 172,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    cityname,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

//small menu box
class Smallmenubox extends StatelessWidget {
  final IconData iconname;
  final String menuname;
  final void Function(BuildContext) callback;

  const Smallmenubox(
      {Key? key,
      required this.iconname,
      required this.menuname,
      required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 72,
          width: 72,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
             primary : Color(0xffEDF2F8),
              onPrimary: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // <-- Radius
              ),
            ),
            onPressed: () => callback.call(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Icon(
                    iconname,
                    size: 30.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Center(
              child: Text(
            menuname,
            style: const TextStyle(
                fontSize: 12.5, color: Colors.black, fontFamily: 'Inter'),
          )),
        )
      ],
    );
  }
}

Widget CommandWidget(String command, Function callback) {
  return Row(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(21, 11, 10, 10),
        child: Text(
          command,
          style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: Colors.black),
        ),
      ),
      SizedBox(
        height: 23,
        width: 23,
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Color(0xff588CDA),
          elevation: 0.2,
          onPressed: callback(),
          child: const Icon(
            Icons.double_arrow_outlined,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}

Widget customTextFieldLogIn(TextEditingController controller, String command) {
  return Container(
    padding: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(
        border: Border.all(width: 0.8),
        borderRadius: BorderRadius.circular(15)),
    height: 60,
    child: TextFormField(
      autofocus: true,
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: command,
      ),
    ),
  );
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField(
      {Key? key, required this.passwordcontroller, required this.command})
      : super(key: key);
  final TextEditingController passwordcontroller;

  final String command;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _passwordVisible = false;
  @override
  // ignore: must_call_super
  void initState() {
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(15)),
      height: 60,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: widget.passwordcontroller,
        obscureText: _passwordVisible,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.command,
          // Here is key idea
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: _passwordVisible ? Colors.black : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}

class ButtonMenuLong extends StatelessWidget {
  const ButtonMenuLong(
      {Key? key,
      required this.callback,
      required this.command,
      required this.iconname})
      : super(key: key);
  final void Function(BuildContext) callback;
  final String command;
  final IconData iconname;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 15),
      height: 60,
      width: 170,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
          backgroundColor: const Color(0xffEDF2F8),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        onPressed: () => callback.call(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconname,
              size: 23.0,
              color: Colors.black,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              command,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonGo extends StatelessWidget {
  const ButtonGo({
    Key? key,
    required this.callback,
    required this.command,
  }) : super(key: key);
  final void Function(BuildContext) callback;
  final String command;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 15),
      height: 60,
      width: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
          backgroundColor: const Color.fromARGB(255, 142, 184, 219),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        onPressed: () => callback.call(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              command,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

Widget textFieldandCommand(
    TextEditingController controller, String command, String hinttext) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 25,
      ),
      Text(
        command,
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(
        height: 15,
      ),
      customTextFieldLogIn(controller, hinttext),
    ],
  );
}

class ClickackbleText extends StatelessWidget {
  const ClickackbleText(
      {Key? key,
      required this.color,
      required this.command,
      required this.callback})
      : super(key: key);
  final Color color;
  final String command;
  final void Function(BuildContext) callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback.call(context),
      child: Text(
        command,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
