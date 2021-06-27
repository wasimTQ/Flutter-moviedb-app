class Genre {
  final int id;
  final String name;
  bool isSelected;

  Genre({
    this.id,
    this.name,
    this.isSelected = false,
  });

   factory Genre.fromJson(json) {
    return Genre(
     id: json['id'],
     name: json['name']
    );
  }
}
