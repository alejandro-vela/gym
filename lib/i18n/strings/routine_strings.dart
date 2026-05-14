class RoutineStrings {
  const RoutineStrings({
    required this.title,
    required this.addExercise,
    required this.startTraining,
    required this.swipeToDeleteHint,
    required this.days,
    required this.daysShort,
    required this.emptyDayTitle,
    required this.emptyDayBody,
    required this.summaryExercises,
    required this.summarySets,
    required this.summaryTotalReps,
  });

  factory RoutineStrings.fromJson(Map<String, dynamic> j) => RoutineStrings(
        title: j['title'] as String,
        addExercise: j['add_exercise'] as String,
        startTraining: j['start_training'] as String,
        swipeToDeleteHint: j['swipe_to_delete_hint'] as String,
        days: List<String>.from(j['days'] as List<dynamic>),
        daysShort: List<String>.from(j['days_short'] as List<dynamic>),
        emptyDayTitle: j['empty_day_title'] as String,
        emptyDayBody: j['empty_day_body'] as String,
        summaryExercises: j['summary_exercises'] as String,
        summarySets: j['summary_sets'] as String,
        summaryTotalReps: j['summary_total_reps'] as String,
      );

  final String title;
  final String addExercise;
  final String startTraining;
  final String swipeToDeleteHint;
  final List<String> days;
  final List<String> daysShort;
  final String emptyDayTitle;
  final String emptyDayBody;
  final String summaryExercises;
  final String summarySets;
  final String summaryTotalReps;

  String dayName(int weekday) => days[weekday];
  String dayShort(int weekday) => daysShort[weekday];
  String emptyTitle(String dayName) =>
      emptyDayTitle.replaceAll('{day}', dayName);
  String exercisesCount(int count) =>
      summaryExercises.replaceAll('{count}', '$count');
  String setsCount(int sets) => summarySets.replaceAll('{sets}', '$sets');
  String totalReps(int reps) => summaryTotalReps.replaceAll('{reps}', '$reps');
}

class AddExerciseStrings {
  const AddExerciseStrings({
    required this.titleNew,
    required this.titleEdit,
    required this.linkMachineLabel,
    required this.noMachine,
    required this.fieldName,
    required this.sectionParams,
    required this.fieldSets,
    required this.fieldReps,
    required this.fieldWeight,
    required this.weightHelper,
    required this.fieldNotes,
    required this.notesHint,
  });

  factory AddExerciseStrings.fromJson(Map<String, dynamic> j) =>
      AddExerciseStrings(
        titleNew: j['title_new'] as String,
        titleEdit: j['title_edit'] as String,
        linkMachineLabel: j['link_machine_label'] as String,
        noMachine: j['no_machine'] as String,
        fieldName: j['field_name'] as String,
        sectionParams: j['section_params'] as String,
        fieldSets: j['field_sets'] as String,
        fieldReps: j['field_reps'] as String,
        fieldWeight: j['field_weight'] as String,
        weightHelper: j['weight_helper'] as String,
        fieldNotes: j['field_notes'] as String,
        notesHint: j['notes_hint'] as String,
      );

  final String titleNew;
  final String titleEdit;
  final String linkMachineLabel;
  final String noMachine;
  final String fieldName;
  final String sectionParams;
  final String fieldSets;
  final String fieldReps;
  final String fieldWeight;
  final String weightHelper;
  final String fieldNotes;
  final String notesHint;
}

class WorkoutSessionStrings {
  const WorkoutSessionStrings({
    required this.title,
    required this.elapsed,
    required this.exercisesCount,
    required this.finishButton,
    required this.finishDialogTitle,
    required this.finishDialogBody,
    required this.leaveDialogTitle,
    required this.leaveDialogBody,
    required this.leaveConfirm,
    required this.restTimerLabel,
    required this.completeCelebration,
    required this.setLabel,
    required this.weightLabel,
    required this.repsLabel,
    required this.restHint,
  });

  factory WorkoutSessionStrings.fromJson(Map<String, dynamic> j) =>
      WorkoutSessionStrings(
        title: j['title'] as String,
        elapsed: j['elapsed'] as String,
        exercisesCount: j['exercises_count'] as String,
        finishButton: j['finish_button'] as String,
        finishDialogTitle: j['finish_dialog_title'] as String,
        finishDialogBody: j['finish_dialog_body'] as String,
        leaveDialogTitle: j['leave_dialog_title'] as String,
        leaveDialogBody: j['leave_dialog_body'] as String,
        leaveConfirm: j['leave_confirm'] as String,
        restTimerLabel: j['rest_timer_label'] as String,
        completeCelebration: j['complete_celebration'] as String,
        setLabel: j['set_label'] as String,
        weightLabel: j['weight_label'] as String,
        repsLabel: j['reps_label'] as String,
        restHint: j['rest_hint'] as String,
      );

  final String title;
  final String elapsed;
  final String exercisesCount;
  final String finishButton;
  final String finishDialogTitle;
  final String finishDialogBody;
  final String leaveDialogTitle;
  final String leaveDialogBody;
  final String leaveConfirm;
  final String restTimerLabel;
  final String completeCelebration;
  final String setLabel;
  final String weightLabel;
  final String repsLabel;
  final String restHint;

  String count(int current, int total) => exercisesCount
      .replaceAll('{current}', '$current')
      .replaceAll('{total}', '$total');
  String finishBody(String duration) =>
      finishDialogBody.replaceAll('{duration}', duration);
}
