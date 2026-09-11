// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ebook_page_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EbookPageDto _$EbookPageDtoFromJson(Map<String, dynamic> json) =>
    _EbookPageDto(
      pageNumber: (json['pageNumber'] as num).toInt(),
      url: json['url'] as String,
    );

Map<String, dynamic> _$EbookPageDtoToJson(_EbookPageDto instance) =>
    <String, dynamic>{'pageNumber': instance.pageNumber, 'url': instance.url};

_EbookPagesResponseDto _$EbookPagesResponseDtoFromJson(
  Map<String, dynamic> json,
) => _EbookPagesResponseDto(
  pages: (json['pages'] as List<dynamic>)
      .map((e) => EbookPageDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  expiresInSeconds: (json['expiresInSeconds'] as num).toInt(),
);

Map<String, dynamic> _$EbookPagesResponseDtoToJson(
  _EbookPagesResponseDto instance,
) => <String, dynamic>{
  'pages': instance.pages,
  'expiresInSeconds': instance.expiresInSeconds,
};
