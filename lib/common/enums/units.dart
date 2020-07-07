enum Units {
  Metric,
  Imperic,
}

extension UnitsExtension on Units {
  String get stringRepr {
    switch (this) {
      case Units.Imperic:
        return "Imperic";
        break;
      case Units.Metric:
        return "Metric";
        break;
    }
    return null;
  }
}
