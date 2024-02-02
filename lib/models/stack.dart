class Stack{
  late String stackname;
  late String color;

  Stack();

  Map<String, dynamic> toJSON() =>{
    "stackname": stackname,
    "color": color,
  };



}