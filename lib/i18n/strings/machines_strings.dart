class MachinesStrings {
  const MachinesStrings({
    required this.title,
    required this.newMachine,
    required this.searchPlaceholder,
    required this.filterAll,
    required this.categories,
    required this.muscleGroups,
    required this.difficulty1,
    required this.difficulty2,
    required this.difficulty3,
    required this.emptyTitle,
    required this.emptyBody,
    required this.detailDescription,
    required this.detailHowToUse,
    required this.detailPrecautions,
    required this.detailMuscles,
    required this.confirmDeleteTitle,
    required this.confirmDeleteBody,
    required this.warningIcon,
  });

  factory MachinesStrings.fromJson(Map<String, dynamic> j) => MachinesStrings(
        title: j['title'] as String,
        newMachine: j['new_machine'] as String,
        searchPlaceholder: j['search_placeholder'] as String,
        filterAll: j['filter_all'] as String,
        categories: List<String>.from(j['categories'] as List<dynamic>),
        muscleGroups: List<String>.from(j['muscle_groups'] as List<dynamic>),
        difficulty1: j['difficulty_1'] as String,
        difficulty2: j['difficulty_2'] as String,
        difficulty3: j['difficulty_3'] as String,
        emptyTitle: j['empty_title'] as String,
        emptyBody: j['empty_body'] as String,
        detailDescription: j['detail_description'] as String,
        detailHowToUse: j['detail_how_to_use'] as String,
        detailPrecautions: j['detail_precautions'] as String,
        detailMuscles: j['detail_muscles'] as String,
        confirmDeleteTitle: j['confirm_delete_title'] as String,
        confirmDeleteBody: j['confirm_delete_body'] as String,
        warningIcon: j['warning_icon'] as String,
      );

  final String title;
  final String newMachine;
  final String searchPlaceholder;
  final String filterAll;
  final List<String> categories;
  final List<String> muscleGroups;
  final String difficulty1;
  final String difficulty2;
  final String difficulty3;
  final String emptyTitle;
  final String emptyBody;
  final String detailDescription;
  final String detailHowToUse;
  final String detailPrecautions;
  final String detailMuscles;
  final String confirmDeleteTitle;
  final String confirmDeleteBody;
  final String warningIcon;

  String difficultyLabel(int level) {
    switch (level) {
      case 1:
        return difficulty1;
      case 2:
        return difficulty2;
      case 3:
        return difficulty3;
      default:
        return difficulty1;
    }
  }
}

class AddMachineStrings {
  const AddMachineStrings({
    required this.titleNew,
    required this.titleEdit,
    required this.photoLabel,
    required this.sectionBasic,
    required this.fieldName,
    required this.fieldCategory,
    required this.sectionDifficulty,
    required this.sectionMuscles,
    required this.musclesRequiredError,
    required this.sectionDescription,
    required this.fieldDescription,
    required this.fieldHowToUse,
    required this.sectionPrecautions,
    required this.precautionPhotoLabel,
    required this.precautionPlaceholder,
    required this.sourceDialogTitle,
  });

  factory AddMachineStrings.fromJson(Map<String, dynamic> j) =>
      AddMachineStrings(
        titleNew: j['title_new'] as String,
        titleEdit: j['title_edit'] as String,
        photoLabel: j['photo_label'] as String,
        sectionBasic: j['section_basic'] as String,
        fieldName: j['field_name'] as String,
        fieldCategory: j['field_category'] as String,
        sectionDifficulty: j['section_difficulty'] as String,
        sectionMuscles: j['section_muscles'] as String,
        musclesRequiredError: j['muscles_required_error'] as String,
        sectionDescription: j['section_description'] as String,
        fieldDescription: j['field_description'] as String,
        fieldHowToUse: j['field_how_to_use'] as String,
        sectionPrecautions: j['section_precautions'] as String,
        precautionPhotoLabel: j['precaution_photo_label'] as String,
        precautionPlaceholder: j['precaution_placeholder'] as String,
        sourceDialogTitle: j['source_dialog_title'] as String,
      );

  final String titleNew;
  final String titleEdit;
  final String photoLabel;
  final String sectionBasic;
  final String fieldName;
  final String fieldCategory;
  final String sectionDifficulty;
  final String sectionMuscles;
  final String musclesRequiredError;
  final String sectionDescription;
  final String fieldDescription;
  final String fieldHowToUse;
  final String sectionPrecautions;
  final String precautionPhotoLabel;
  final String precautionPlaceholder;
  final String sourceDialogTitle;
}
