class Package {
  final String package;

  const Package(this.package);

  factory Package.fromJson(dynamic json) {
    return Package(json['package'] as String);
  }

  @override
  String toString() {
    return '{ $package }';
  }
}