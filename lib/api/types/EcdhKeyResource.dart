class EcdhKeyResource {
  final String id;
  final String public_key;
  final List<int> private_key;
  final bool claimed;

  EcdhKeyResource({
    required this.id,
    required this.public_key,
    required this.private_key,
    required this.claimed,
  });
}
