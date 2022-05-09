extension DoubleExt on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
