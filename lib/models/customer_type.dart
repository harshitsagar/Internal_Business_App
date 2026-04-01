enum CustomerType {
  dealer,
  retail,
}

extension CustomerTypeExtension on CustomerType {
  String get displayName {
    switch (this) {
      case CustomerType.dealer:
        return 'Dealer (Lower Price)';
      case CustomerType.retail:
        return 'Retail (Higher Price)';
    }
  }

  String get shortName {
    switch (this) {
      case CustomerType.dealer:
        return 'Dealer';
      case CustomerType.retail:
        return 'Retail';
    }
  }
}