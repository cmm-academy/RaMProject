
class RamResult<T> {
  final T? data;
  final String? error;

  RamResult({this.data, this.error});

  bool isSuccessful() {
    return data != null;
  }
}