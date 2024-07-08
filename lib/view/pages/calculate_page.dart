import 'package:calculator/model/button.dart';
import 'package:flutter/material.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key});

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
body: Column(children: [
  Expanded(
    child: SingleChildScrollView(
      reverse: true,
        child: Container(
          alignment: Alignment.bottomRight,
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("0",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 48),
            textAlign: TextAlign.end,
            ),
          ),
        ),

    ),
  ),
  Wrap(children: Button.buttonValues.map((value) => SizedBox(
      height:size.height/9 ,
      width:size.width/4 ,
      child: buildButton(value))).toList())

],),
    );
  }

Widget buildButton(value){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: getButtonColor(value),
        shape: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(20))

        ),
        child: InkWell(
            onTap: (){},
            child: Center(child: Text(value,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),))),
      ),
    );
}

Color getButtonColor(value){
    return [Button.del,Button.clr,Button.per,Button.multiply].contains(value)?Colors.purpleAccent:
    [Button.n7,Button.n8,Button.n9,Button.divide].contains(value)?Colors.cyan:
    [Button.n4,Button.n5,Button.n6,Button.sub].contains(value)?Colors.purpleAccent:
    [Button.n1,Button.n2,Button.n3,Button.add].contains(value)?Colors.cyan:Colors.purpleAccent;

}

}
