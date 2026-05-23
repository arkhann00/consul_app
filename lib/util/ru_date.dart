String formatRuShortDate(DateTime utc) {
  final local = utc.toLocal();
  const months = [
    'янв',
    'фев',
    'мар',
    'апр',
    'мая',
    'июн',
    'июл',
    'авг',
    'сен',
    'окт',
    'ноя',
    'дек',
  ];
  return '${local.day} ${months[local.month - 1]}';
}
