import 'dart:math';

class Generator
{
  double generateRandomDecimal()
  {
    Random random = Random();

    int wholePart = random.nextInt(100);

    int decimalPart = random.nextInt(99) + 1;

    double result = double.parse('$wholePart.${decimalPart.toString().padRight(2, '0')}');

    return result;
  }
}