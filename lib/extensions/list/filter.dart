//extension is used to use a functionality of a library according to your own need and implemenetation to define it in your own way. It's like you're extending the library.
extension Filter<T> on Stream<List<T>> {
  // T here is a database note. Like we want to filter the notes to display only the notes of a currentUser.
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}
