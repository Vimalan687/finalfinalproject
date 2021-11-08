class entity {
  String? title;

  entity(this.title);

  entity.fromJson(Map<String, dynamic> json) {
    title = json[title];
   
  }
}
