class Picture {
  final int? id;
  final String url;
  final DateTime date;

  Picture({
    this.id,
    required this.url,
    required this.date,
  });

  static List<Picture> getPictures() {
    return [
      Picture(
        id: 1,
        url: "assets/images/01.jpg",
        date: DateTime.now(),
      ),
      Picture(
        id: 2,
        url: "assets/images/02.jpg",
        date: DateTime.now(),
      ),
      Picture(
        id: 3,
        url: "assets/images/03.jpg",
        date: DateTime.now(),
      ),
      Picture(
        id: 4,
        url: "assets/images/04.jpg",
        date: DateTime.now(),
      ),
      Picture(
        id: 5,
        url: "assets/images/05.jpg",
        date: DateTime.now(),
      ),
    ];
  }
}
