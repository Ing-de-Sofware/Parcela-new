import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class HostReviewModalModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  // Rating bar values for each category
  double? punctualityRating;
  double? cleanlinessRating;
  double? kindnessRating;

  // Selected aspect for the question
  String? selectedAspect;

  // Optional comment text
  FocusNode? commentFocusNode;
  TextEditingController? commentTextController;
  String? Function(BuildContext, String?)? commentTextControllerValidator;

  // Computed properties
  double get averageRating {
    if (punctualityRating == null || cleanlinessRating == null || kindnessRating == null) {
      return 0.0;
    }
    return (punctualityRating! + cleanlinessRating! + kindnessRating!) / 3.0;
  }

  bool get isFormComplete {
    bool ratingsComplete = punctualityRating != null &&
                          cleanlinessRating != null &&
                          kindnessRating != null;
    bool questionAnswered = selectedAspect != null;

    return ratingsComplete && questionAnswered;
  }

  @override
  void initState(BuildContext context) {
    commentTextController = TextEditingController();
    commentFocusNode = FocusNode();
  }

  @override
  void dispose() {
    commentFocusNode?.dispose();
    commentTextController?.dispose();
  }
}
