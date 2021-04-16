import 'custom_offset.dart';

class PathStep {
  final CustomOffset start, end;

  PathStep({this.start, this.end});

  Map<String, dynamic> toJson() => {
        'start': start.toJson(),
        'end': end.toJson(),
      };

  PathStep.fromJson(Map<String, dynamic> json)
      : start = CustomOffset.fromJson(json['start']),
        end = CustomOffset.fromJson(json['end']);
}
