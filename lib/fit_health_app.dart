class FitHealthApp {
  String key;
  String keyVal;
  String value;
  String valueVal;
  String unit;
  String unitVal;

  FitHealthApp(this.key, this.keyVal, this.value, this.valueVal, this.unit,
      this.unitVal);

  @override
  String toString() {
    return '{ ${this.key},${this.keyVal}, ${this.value},${this.valueVal},  ${this.unit}, ${this.unitVal} }';
  }
}
