class MapsAddressParser {
  static Map<String, String> parseAddress(String address) {
    String cleanAddress = address
        .replaceAll('대한민국 ', '')
        .replaceAll('South Korea', '')
        .trim();

    List<String> parts = cleanAddress.split(' ');

    String city = '';
    String gu = '';

    for (String part in parts) {
      if (part.endsWith('도') ||
          part.endsWith('특별시') ||
          part.endsWith('광역시') ||
          part.endsWith('특별자치시')) {
        city = part;
        break;
      }
    }

    for (String part in parts) {
      if (part.endsWith('시') ||
          part.endsWith('군') ||
          part.endsWith('구')) {
        if (!part.endsWith('특별시') &&
            !part.endsWith('광역시') &&
            !part.endsWith('특별자치시')) {
          gu = part;
          break;
        }
      }
    }

    print(city);
    print(gu);

    return {
      'city': city,
      'gu': gu,
    };
  }
}