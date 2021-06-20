class EcdhKeyResource {
  String id;
  String public_key;
  List<int> private_key;
  bool claimed;

  EcdhKeyResource({
    required this.id,
    required this.public_key,
    required this.private_key,
    required this.claimed,
  });
}
