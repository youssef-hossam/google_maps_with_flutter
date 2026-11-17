import 'package:google_map/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Places shown on the map (Tanta, Egypt).
const LatLng kTantaCenter = LatLng(30.7955, 30.9845);

const List<PlaceModel> places = [
  PlaceModel(
    id: 1,
    name: 'مسجد السيد أحمد البدوي',
    description:
        'أشهر معالم طنطا، مسجد تاريخي بقباب ومآذن مميزة ويزوره الآلاف كل سنة في المولد.',
    address: 'ميدان السيد البدوي، وسط البلد',
    category: PlaceCategory.landmark,
    rating: 4.9,
    location: LatLng(30.783611, 30.998889),
  ),
  PlaceModel(
    id: 2,
    name: 'متحف آثار طنطا',
    description:
        'متحف بيعرض قطع أثرية من عصور مختلفة اتلقت في محافظة الغربية.',
    address: 'شارع البحر، طنطا',
    category: PlaceCategory.landmark,
    rating: 4.6,
    location: LatLng(30.79834286390387, 31.004471245006943),
  ),
  PlaceModel(
    id: 3,
    name: 'ملاهي جوكي بارك',
    description: 'ملاهي ومساحات خضرا للعيلة والأطفال، مكان مناسب للخروجات.',
    address: 'طريق طنطا – المحلة',
    category: PlaceCategory.fun,
    rating: 4.3,
    location: LatLng(30.811279116647235, 30.994027572500798),
  ),
  PlaceModel(
    id: 4,
    name: 'جامعة طنطا',
    description: 'واحدة من أكبر جامعات الدلتا، فيها كليات كتير ومستشفيات جامعية.',
    address: 'شارع الجيش، طنطا',
    category: PlaceCategory.education,
    rating: 4.5,
    location: LatLng(30.79222, 30.99917),
  ),
  PlaceModel(
    id: 5,
    name: 'مصر للبترول',
    description: 'محطة وقود مفتوحة 24 ساعة، فيها ماركت وخدمة غسيل عربيات.',
    address: 'الطريق الدائري، طنطا',
    category: PlaceCategory.services,
    rating: 4.1,
    location: LatLng(30.793516505668073, 30.96485918966277),
  ),
];
