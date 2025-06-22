class Area{
  final int id;
  final String name;
  final List<City> cities;
  const Area({required this.id, required this.name, required this.cities});
}

class City{
  final int id;
  final String name;
  const City({required this.id, required this.name});
}

// Static list derived from provided PHP array
const List<Area> kAreas = [
  Area(id: 1, name: 'الرياض', cities: [
    City(id: 1, name: 'الرياض'),
    City(id: 2, name: 'الخرج'),
    City(id: 3, name: 'الدرعية'),
    City(id: 4, name: 'الدوادمي'),
    City(id: 5, name: 'المجمعة'),
    City(id: 6, name: 'القويعية'),
    City(id: 7, name: 'وادي الدواسر'),
    City(id: 8, name: 'الأفلاج'),
    City(id: 9, name: 'الزلفي'),
    City(id: 10, name: 'شقراء'),
    City(id: 11, name: 'حوطة بني تميم'),
    City(id: 12, name: 'عفيف'),
    City(id: 13, name: 'الغاط'),
    City(id: 14, name: 'السليل'),
    City(id: 15, name: 'ضرما'),
    City(id: 16, name: 'المزاحمية'),
    City(id: 17, name: 'رماح'),
    City(id: 18, name: 'ثادق'),
    City(id: 19, name: 'حريملاء'),
    City(id: 20, name: 'الحريق'),
  ]),
  Area(id: 2, name: 'مكة المكرمة', cities: [
    City(id: 21, name: 'مكة المكرمة'),
    City(id: 22, name: 'جدة'),
    City(id: 23, name: 'الطائف'),
    City(id: 24, name: 'القنفذة'),
    City(id: 25, name: 'الليث'),
    City(id: 26, name: 'رابغ'),
    City(id: 27, name: 'خليص'),
    City(id: 28, name: 'الخرمة'),
    City(id: 29, name: 'رنية'),
    City(id: 30, name: 'تربة'),
    City(id: 31, name: 'الجموم'),
    City(id: 32, name: 'الكامل'),
    City(id: 33, name: 'المويه'),
    City(id: 34, name: 'ميسان'),
    City(id: 35, name: 'أضم'),
    City(id: 36, name: 'العرضيات'),
    City(id: 37, name: 'بحرة'),
  ]),
  Area(id: 3, name: 'المدينة المنورة', cities: [
    City(id: 38, name: 'المدينة المنورة'),
    City(id: 39, name: 'ينبع'),
    City(id: 40, name: 'العلا'),
    City(id: 41, name: 'المهد'),
    City(id: 42, name: 'الحناكية'),
    City(id: 43, name: 'بدر'),
    City(id: 44, name: 'خيبر'),
    City(id: 45, name: 'العيص'),
    City(id: 46, name: 'وادي الفرع'),
  ]),
  // Additional areas truncated for brevity...
];
