// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meta_data_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Metadata _$MetadataFromJson(Map<String, dynamic> json) {
  return _Metadata.fromJson(json);
}

/// @nodoc
mixin _$Metadata {
  Map<String, Object>? get variables =>
      throw _privateConstructorUsedError; // Map of variables
  Map<String, Object>? get params =>
      throw _privateConstructorUsedError; // Map of params
  String? get body =>
      throw _privateConstructorUsedError; // Body content as a string
  Map<String, Object>? get extend => throw _privateConstructorUsedError;

  /// Serializes this Metadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetadataCopyWith<Metadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataCopyWith<$Res> {
  factory $MetadataCopyWith(Metadata value, $Res Function(Metadata) then) =
      _$MetadataCopyWithImpl<$Res, Metadata>;
  @useResult
  $Res call({
    Map<String, Object>? variables,
    Map<String, Object>? params,
    String? body,
    Map<String, Object>? extend,
  });
}

/// @nodoc
class _$MetadataCopyWithImpl<$Res, $Val extends Metadata>
    implements $MetadataCopyWith<$Res> {
  _$MetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? variables = freezed,
    Object? params = freezed,
    Object? body = freezed,
    Object? extend = freezed,
  }) {
    return _then(
      _value.copyWith(
            variables:
                freezed == variables
                    ? _value.variables
                    : variables // ignore: cast_nullable_to_non_nullable
                        as Map<String, Object>?,
            params:
                freezed == params
                    ? _value.params
                    : params // ignore: cast_nullable_to_non_nullable
                        as Map<String, Object>?,
            body:
                freezed == body
                    ? _value.body
                    : body // ignore: cast_nullable_to_non_nullable
                        as String?,
            extend:
                freezed == extend
                    ? _value.extend
                    : extend // ignore: cast_nullable_to_non_nullable
                        as Map<String, Object>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MetadataImplCopyWith<$Res>
    implements $MetadataCopyWith<$Res> {
  factory _$$MetadataImplCopyWith(
    _$MetadataImpl value,
    $Res Function(_$MetadataImpl) then,
  ) = __$$MetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Map<String, Object>? variables,
    Map<String, Object>? params,
    String? body,
    Map<String, Object>? extend,
  });
}

/// @nodoc
class __$$MetadataImplCopyWithImpl<$Res>
    extends _$MetadataCopyWithImpl<$Res, _$MetadataImpl>
    implements _$$MetadataImplCopyWith<$Res> {
  __$$MetadataImplCopyWithImpl(
    _$MetadataImpl _value,
    $Res Function(_$MetadataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? variables = freezed,
    Object? params = freezed,
    Object? body = freezed,
    Object? extend = freezed,
  }) {
    return _then(
      _$MetadataImpl(
        variables:
            freezed == variables
                ? _value._variables
                : variables // ignore: cast_nullable_to_non_nullable
                    as Map<String, Object>?,
        params:
            freezed == params
                ? _value._params
                : params // ignore: cast_nullable_to_non_nullable
                    as Map<String, Object>?,
        body:
            freezed == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                    as String?,
        extend:
            freezed == extend
                ? _value._extend
                : extend // ignore: cast_nullable_to_non_nullable
                    as Map<String, Object>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MetadataImpl implements _Metadata {
  const _$MetadataImpl({
    final Map<String, Object>? variables,
    final Map<String, Object>? params,
    this.body,
    final Map<String, Object>? extend,
  }) : _variables = variables,
       _params = params,
       _extend = extend;

  factory _$MetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetadataImplFromJson(json);

  final Map<String, Object>? _variables;
  @override
  Map<String, Object>? get variables {
    final value = _variables;
    if (value == null) return null;
    if (_variables is EqualUnmodifiableMapView) return _variables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // Map of variables
  final Map<String, Object>? _params;
  // Map of variables
  @override
  Map<String, Object>? get params {
    final value = _params;
    if (value == null) return null;
    if (_params is EqualUnmodifiableMapView) return _params;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // Map of params
  @override
  final String? body;
  // Body content as a string
  final Map<String, Object>? _extend;
  // Body content as a string
  @override
  Map<String, Object>? get extend {
    final value = _extend;
    if (value == null) return null;
    if (_extend is EqualUnmodifiableMapView) return _extend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Metadata(variables: $variables, params: $params, body: $body, extend: $extend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataImpl &&
            const DeepCollectionEquality().equals(
              other._variables,
              _variables,
            ) &&
            const DeepCollectionEquality().equals(other._params, _params) &&
            (identical(other.body, body) || other.body == body) &&
            const DeepCollectionEquality().equals(other._extend, _extend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_variables),
    const DeepCollectionEquality().hash(_params),
    body,
    const DeepCollectionEquality().hash(_extend),
  );

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataImplCopyWith<_$MetadataImpl> get copyWith =>
      __$$MetadataImplCopyWithImpl<_$MetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetadataImplToJson(this);
  }
}

abstract class _Metadata implements Metadata {
  const factory _Metadata({
    final Map<String, Object>? variables,
    final Map<String, Object>? params,
    final String? body,
    final Map<String, Object>? extend,
  }) = _$MetadataImpl;

  factory _Metadata.fromJson(Map<String, dynamic> json) =
      _$MetadataImpl.fromJson;

  @override
  Map<String, Object>? get variables; // Map of variables
  @override
  Map<String, Object>? get params; // Map of params
  @override
  String? get body; // Body content as a string
  @override
  Map<String, Object>? get extend;

  /// Create a copy of Metadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataImplCopyWith<_$MetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
