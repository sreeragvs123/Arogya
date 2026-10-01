// TODO: replace values with your backend enums exactly.
enum Sex { MALE, FEMALE, OTHER }

enum Department { NURSING, PHARMACY, LABORATORY, RADIOLOGY, ADMINISTRATION, HOUSEKEEPING }

String prettyEnum(Enum e) {
  final s = e.name.toLowerCase();
  return s[0].toUpperCase() + s.substring(1);
}