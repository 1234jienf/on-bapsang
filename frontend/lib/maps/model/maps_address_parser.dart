class Address {
  final String city;
  final String gu;

  Address({required this.city, required this.gu});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] ?? '',
      gu: json['gu'] ?? '',
    );
  }
}

class MapsAddressParser {
  static Address parseAddress(String address) {
    String cleanAddress =
        address.replaceAll('대한민국 ', '').replaceAll('South Korea', '').trim();

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
      if (part.endsWith('시') || part.endsWith('군') || part.endsWith('구')) {
        if (!part.endsWith('특별시') &&
            !part.endsWith('광역시') &&
            !part.endsWith('특별자치시')) {
          gu = part;
          break;
        }
      }
    }

    return Address(city: city, gu: gu);
  }
}
