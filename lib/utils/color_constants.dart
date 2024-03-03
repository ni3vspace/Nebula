import 'dart:ui';

class ColorConstants{
  static Color bottomBorder = hexToColor('#BCA0F5');
  static Color pinOnCamera = hexToColor('#CAB4FF');
  static Color presentaion = hexToColor('#7DA1FF');



  static Color camItemsBack = Color(int.parse('0x55555555'));
  static Color camItemsBack1 = Color(int.parse('0x50000000'));
  // static Color camItemsBack = Color(0xFF555555).withOpacity(0.5);
  static Color presentaionDisable = presentaion.withOpacity(0.5);

}
Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
  'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}