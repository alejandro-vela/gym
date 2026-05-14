/// Complete typed data model for all app strings and image paths.
/// Every field maps 1-to-1 with a key in the JSON files.
/// No strings should ever be hardcoded in widgets — always use this model.
library;

// ─── Root model ───────────────────────────────────────────────────
class AppLocalizations {

  const AppLocalizations({
    required this.app,
    required this.images,
    required this.nav,
    required this.common,
    required this.home,
    required this.machines,
    required this.addMachine,
    required this.routine,
    required this.addExercise,
    required this.workoutSession,
    required this.progress,
    required this.health,
    required this.achievements,
    required this.recovery,
    required this.overload,
    required this.errors,
    required this.workoutTypes,
  });

  factory AppLocalizations.fromJson(Map<String, dynamic> json) {
    return AppLocalizations(
      app: AppStrings.fromJson(json['app'] as Map<String, dynamic>),
      images: ImagePaths.fromJson(json['images'] as Map<String, dynamic>),
      nav: NavStrings.fromJson(json['nav'] as Map<String, dynamic>),
      common: CommonStrings.fromJson(json['common'] as Map<String, dynamic>),
      home: HomeStrings.fromJson(json['home'] as Map<String, dynamic>),
      machines:
          MachinesStrings.fromJson(json['machines'] as Map<String, dynamic>),
      addMachine: AddMachineStrings.fromJson(
          json['add_machine'] as Map<String, dynamic>,),
      routine: RoutineStrings.fromJson(json['routine'] as Map<String, dynamic>),
      addExercise: AddExerciseStrings.fromJson(
          json['add_exercise'] as Map<String, dynamic>,),
      workoutSession: WorkoutSessionStrings.fromJson(
          json['workout_session'] as Map<String, dynamic>,),
      progress:
          ProgressStrings.fromJson(json['progress'] as Map<String, dynamic>),
      health: HealthStrings.fromJson(json['health'] as Map<String, dynamic>),
      achievements: AchievementsStrings.fromJson(
          json['achievements'] as Map<String, dynamic>,),
      recovery:
          RecoveryStrings.fromJson(json['recovery'] as Map<String, dynamic>),
      overload:
          OverloadStrings.fromJson(json['overload'] as Map<String, dynamic>),
      errors: ErrorStrings.fromJson(json['errors'] as Map<String, dynamic>),
      workoutTypes: WorkoutTypesStrings.fromJson(
          json['workout_types'] as Map<String, dynamic>,),
    );
  }
  final AppStrings app;
  final ImagePaths images;
  final NavStrings nav;
  final CommonStrings common;
  final HomeStrings home;
  final MachinesStrings machines;
  final AddMachineStrings addMachine;
  final RoutineStrings routine;
  final AddExerciseStrings addExercise;
  final WorkoutSessionStrings workoutSession;
  final ProgressStrings progress;
  final HealthStrings health;
  final AchievementsStrings achievements;
  final RecoveryStrings recovery;
  final OverloadStrings overload;
  final ErrorStrings errors;
  final WorkoutTypesStrings workoutTypes;
}

// ─── App ─────────────────────────────────────────────────────────
class AppStrings {
  const AppStrings(
      {required this.title, required this.tagline, required this.version,});
  factory AppStrings.fromJson(Map<String, dynamic> j) => AppStrings(
        title: j['title'] as String,
        tagline: j['tagline'] as String,
        version: j['version'] as String,
      );
  final String title;
  final String tagline;
  final String version;
}

// ─── Images ──────────────────────────────────────────────────────
class ImagePaths {

  const ImagePaths({
    required this.logo,
    required this.placeholderMachine,
    required this.placeholderAvatar,
    required this.bodyFront,
    required this.bodyBack,
    required this.appleWatchIcon,
    required this.emptyWorkout,
  });

  factory ImagePaths.fromJson(Map<String, dynamic> j) => ImagePaths(
        logo: j['logo'] as String,
        placeholderMachine: j['placeholder_machine'] as String,
        placeholderAvatar: j['placeholder_avatar'] as String,
        bodyFront: j['body_front'] as String,
        bodyBack: j['body_back'] as String,
        appleWatchIcon: j['apple_watch_icon'] as String,
        emptyWorkout: j['empty_workout'] as String,
      );
  final String logo;
  final String placeholderMachine;
  final String placeholderAvatar;
  final String bodyFront;
  final String bodyBack;
  final String appleWatchIcon;
  final String emptyWorkout;
}

// ─── Navigation ──────────────────────────────────────────────────
class NavStrings {
  const NavStrings({
    required this.home,
    required this.machines,
    required this.routine,
    required this.progress,
    required this.watch,
  });
  factory NavStrings.fromJson(Map<String, dynamic> j) => NavStrings(
        home: j['home'] as String,
        machines: j['machines'] as String,
        routine: j['routine'] as String,
        progress: j['progress'] as String,
        watch: j['watch'] as String,
      );
  final String home;
  final String machines;
  final String routine;
  final String progress;
  final String watch;
}

// ─── Common ──────────────────────────────────────────────────────
class CommonStrings {

  const CommonStrings({
    required this.save,
    required this.cancel,
    required this.delete,
    required this.edit,
    required this.add,
    required this.confirm,
    required this.back,
    required this.retry,
    required this.continueStr,
    required this.finish,
    required this.close,
    required this.skip,
    required this.next,
    required this.previous,
    required this.yes,
    required this.no,
    required this.loading,
    required this.error,
    required this.requiredField,
    required this.optional,
    required this.swipeToDelete,
    required this.camera,
    required this.gallery,
    required this.selectPhoto,
    required this.tapToAddPhoto,
    required this.tapToChangePhoto,
    required this.sets,
    required this.reps,
    required this.kg,
    required this.min,
    required this.hours,
    required this.days,
    required this.kcal,
    required this.bpm,
    required this.cm,
    required this.notes,
    required this.optionalNotes,
  });

  factory CommonStrings.fromJson(Map<String, dynamic> j) => CommonStrings(
        save: j['save'] as String,
        cancel: j['cancel'] as String,
        delete: j['delete'] as String,
        edit: j['edit'] as String,
        add: j['add'] as String,
        confirm: j['confirm'] as String,
        back: j['back'] as String,
        retry: j['retry'] as String,
        continueStr: j['continue'] as String,
        finish: j['finish'] as String,
        close: j['close'] as String,
        skip: j['skip'] as String,
        next: j['next'] as String,
        previous: j['previous'] as String,
        yes: j['yes'] as String,
        no: j['no'] as String,
        loading: j['loading'] as String,
        error: j['error'] as String,
        requiredField: j['required_field'] as String,
        optional: j['optional'] as String,
        swipeToDelete: j['swipe_to_delete'] as String,
        camera: j['camera'] as String,
        gallery: j['gallery'] as String,
        selectPhoto: j['select_photo'] as String,
        tapToAddPhoto: j['tap_to_add_photo'] as String,
        tapToChangePhoto: j['tap_to_change_photo'] as String,
        sets: j['sets'] as String,
        reps: j['reps'] as String,
        kg: j['kg'] as String,
        min: j['min'] as String,
        hours: j['hours'] as String,
        days: j['days'] as String,
        kcal: j['kcal'] as String,
        bpm: j['bpm'] as String,
        cm: j['cm'] as String,
        notes: j['notes'] as String,
        optionalNotes: j['optional_notes'] as String,
      );
  final String save;
  final String cancel;
  final String delete;
  final String edit;
  final String add;
  final String confirm;
  final String back;
  final String retry;
  final String continueStr;
  final String finish;
  final String close;
  final String skip;
  final String next;
  final String previous;
  final String yes;
  final String no;
  final String loading;
  final String error;
  final String requiredField;
  final String optional;
  final String swipeToDelete;
  final String camera;
  final String gallery;
  final String selectPhoto;
  final String tapToAddPhoto;
  final String tapToChangePhoto;
  final String sets;
  final String reps;
  final String kg;
  final String min;
  final String hours;
  final String days;
  final String kcal;
  final String bpm;
  final String cm;
  final String notes;
  final String optionalNotes;
}

// ─── Home ────────────────────────────────────────────────────────
class TipData {
  const TipData(
      {required this.icon,
      required this.title,
      required this.body,
      required this.color,});
  factory TipData.fromJson(Map<String, dynamic> j) => TipData(
        icon: j['icon'] as String,
        title: j['title'] as String,
        body: j['body'] as String,
        color: j['color'] as String,
      );
  final String icon;
  final String title;
  final String body;
  final String color;
}

class HomeStrings {

  const HomeStrings({
    required this.welcome,
    required this.appName,
    required this.todayLabel,
    required this.statMachines,
    required this.statWorkouts,
    required this.statTodayExercises,
    required this.startWorkout,
    required this.activeSessionTitle,
    required this.activeSessionElapsed,
    required this.restDayTitle,
    required this.restDayHint,
    required this.quickLinkRecovery,
    required this.quickLinkPrs,
    required this.tipOfDay,
    required this.tips,
  });

  factory HomeStrings.fromJson(Map<String, dynamic> j) => HomeStrings(
        welcome: j['welcome'] as String,
        appName: j['app_name'] as String,
        todayLabel: j['today_label'] as String,
        statMachines: j['stat_machines'] as String,
        statWorkouts: j['stat_workouts'] as String,
        statTodayExercises: j['stat_today_exercises'] as String,
        startWorkout: j['start_workout'] as String,
        activeSessionTitle: j['active_session_title'] as String,
        activeSessionElapsed: j['active_session_elapsed'] as String,
        restDayTitle: j['rest_day_title'] as String,
        restDayHint: j['rest_day_hint'] as String,
        quickLinkRecovery: j['quick_link_recovery'] as String,
        quickLinkPrs: j['quick_link_prs'] as String,
        tipOfDay: j['tip_of_day'] as String,
        tips: (j['tips'] as List<dynamic>)
            .map((dynamic t) => TipData.fromJson(t as Map<String, dynamic>))
            .toList(),
      );
  final String welcome;
  final String appName;
  final String todayLabel;
  final String statMachines;
  final String statWorkouts;
  final String statTodayExercises;
  final String startWorkout;
  final String activeSessionTitle;
  final String activeSessionElapsed;
  final String restDayTitle;
  final String restDayHint;
  final String quickLinkRecovery;
  final String quickLinkPrs;
  final String tipOfDay;
  final List<TipData> tips;
}

// ─── Machines ────────────────────────────────────────────────────
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

// ─── Add Machine ─────────────────────────────────────────────────
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

// ─── Routine ─────────────────────────────────────────────────────
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

// ─── Add Exercise ────────────────────────────────────────────────
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

// ─── Workout Session ─────────────────────────────────────────────
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

// ─── Progress ────────────────────────────────────────────────────
class ProgressStrings {

  const ProgressStrings({
    required this.title,
    required this.tabMeasurements,
    required this.tabHistory,
    required this.statWorkouts,
    required this.statMinutes,
    required this.sectionWeightChart,
    required this.sectionLatest,
    required this.sectionHistory,
    required this.addMeasurement,
    required this.emptyMeasurementsTitle,
    required this.emptyMeasurementsBody,
    required this.emptyHistoryTitle,
    required this.emptyHistoryBody,
    required this.workoutCompleted,
    required this.caloriesTotal,
    required this.fieldWeight,
    required this.fieldBodyFat,
    required this.fieldChest,
    required this.fieldWaist,
    required this.fieldHips,
    required this.fieldLeftArm,
    required this.fieldRightArm,
    required this.fieldLeftThigh,
    required this.fieldRightThigh,
    required this.measurementWeight,
    required this.measurementBodyFat,
    required this.measurementChest,
    required this.measurementWaist,
    required this.measurementArmLeft,
    required this.measurementArmRight,
  });

  factory ProgressStrings.fromJson(Map<String, dynamic> j) => ProgressStrings(
        title: j['title'] as String,
        tabMeasurements: j['tab_measurements'] as String,
        tabHistory: j['tab_history'] as String,
        statWorkouts: j['stat_workouts'] as String,
        statMinutes: j['stat_minutes'] as String,
        sectionWeightChart: j['section_weight_chart'] as String,
        sectionLatest: j['section_latest'] as String,
        sectionHistory: j['section_history'] as String,
        addMeasurement: j['add_measurement'] as String,
        emptyMeasurementsTitle: j['empty_measurements_title'] as String,
        emptyMeasurementsBody: j['empty_measurements_body'] as String,
        emptyHistoryTitle: j['empty_history_title'] as String,
        emptyHistoryBody: j['empty_history_body'] as String,
        workoutCompleted: j['workout_completed'] as String,
        caloriesTotal: j['calories_total'] as String,
        fieldWeight: j['field_weight'] as String,
        fieldBodyFat: j['field_body_fat'] as String,
        fieldChest: j['field_chest'] as String,
        fieldWaist: j['field_waist'] as String,
        fieldHips: j['field_hips'] as String,
        fieldLeftArm: j['field_left_arm'] as String,
        fieldRightArm: j['field_right_arm'] as String,
        fieldLeftThigh: j['field_left_thigh'] as String,
        fieldRightThigh: j['field_right_thigh'] as String,
        measurementWeight: j['measurement_weight'] as String,
        measurementBodyFat: j['measurement_body_fat'] as String,
        measurementChest: j['measurement_chest'] as String,
        measurementWaist: j['measurement_waist'] as String,
        measurementArmLeft: j['measurement_arm_left'] as String,
        measurementArmRight: j['measurement_arm_right'] as String,
      );
  final String title;
  final String tabMeasurements;
  final String tabHistory;
  final String statWorkouts;
  final String statMinutes;
  final String sectionWeightChart;
  final String sectionLatest;
  final String sectionHistory;
  final String addMeasurement;
  final String emptyMeasurementsTitle;
  final String emptyMeasurementsBody;
  final String emptyHistoryTitle;
  final String emptyHistoryBody;
  final String workoutCompleted;
  final String caloriesTotal;
  final String fieldWeight;
  final String fieldBodyFat;
  final String fieldChest;
  final String fieldWaist;
  final String fieldHips;
  final String fieldLeftArm;
  final String fieldRightArm;
  final String fieldLeftThigh;
  final String fieldRightThigh;
  final String measurementWeight;
  final String measurementBodyFat;
  final String measurementChest;
  final String measurementWaist;
  final String measurementArmLeft;
  final String measurementArmRight;
}

// ─── Health ──────────────────────────────────────────────────────
class HealthStrings {

  const HealthStrings({
    required this.title,
    required this.syncedAt,
    required this.syncing,
    required this.refresh,
    required this.caloriesActive,
    required this.caloriesBasal,
    required this.caloriesTotal,
    required this.calorieGoal,
    required this.calorieProgressPct,
    required this.setGoalTitle,
    required this.setGoalHint,
    required this.statSteps,
    required this.statDistance,
    required this.statExercise,
    required this.heartRateTitle,
    required this.hrCurrent,
    required this.hrAvg,
    required this.hrMax,
    required this.hrChartHint,
    required this.zoneRest,
    required this.zoneNormal,
    required this.zoneModerate,
    required this.zoneIntense,
    required this.sleepTitle,
    required this.sleepOptimal,
    required this.sleepRegular,
    required this.sleepInsufficient,
    required this.sleepLastNight,
    required this.workoutsTitle,
    required this.noWorkoutsTitle,
    required this.noWorkoutsBody,
    required this.permissionTitle,
    required this.permissionSubtitle,
    required this.permissionFeatures,
    required this.permissionCta,
    required this.permissionPrivacy,
    required this.permissionDeniedTitle,
    required this.permissionDeniedBody,
    required this.errorTitle,
  });

  factory HealthStrings.fromJson(Map<String, dynamic> j) => HealthStrings(
        title: j['title'] as String,
        syncedAt: j['synced_at'] as String,
        syncing: j['syncing'] as String,
        refresh: j['refresh'] as String,
        caloriesActive: j['calories_active'] as String,
        caloriesBasal: j['calories_basal'] as String,
        caloriesTotal: j['calories_total'] as String,
        calorieGoal: j['calorie_goal'] as String,
        calorieProgressPct: j['calorie_progress_pct'] as String,
        setGoalTitle: j['set_goal_title'] as String,
        setGoalHint: j['set_goal_hint'] as String,
        statSteps: j['stat_steps'] as String,
        statDistance: j['stat_distance'] as String,
        statExercise: j['stat_exercise'] as String,
        heartRateTitle: j['heart_rate_title'] as String,
        hrCurrent: j['hr_current'] as String,
        hrAvg: j['hr_avg'] as String,
        hrMax: j['hr_max'] as String,
        hrChartHint: j['hr_chart_hint'] as String,
        zoneRest: j['zone_rest'] as String,
        zoneNormal: j['zone_normal'] as String,
        zoneModerate: j['zone_moderate'] as String,
        zoneIntense: j['zone_intense'] as String,
        sleepTitle: j['sleep_title'] as String,
        sleepOptimal: j['sleep_optimal'] as String,
        sleepRegular: j['sleep_regular'] as String,
        sleepInsufficient: j['sleep_insufficient'] as String,
        sleepLastNight: j['sleep_last_night'] as String,
        workoutsTitle: j['workouts_title'] as String,
        noWorkoutsTitle: j['no_workouts_title'] as String,
        noWorkoutsBody: j['no_workouts_body'] as String,
        permissionTitle: j['permission_title'] as String,
        permissionSubtitle: j['permission_subtitle'] as String,
        permissionFeatures: List<String>.from(j['permission_features'] as List<dynamic>),
        permissionCta: j['permission_cta'] as String,
        permissionPrivacy: j['permission_privacy'] as String,
        permissionDeniedTitle: j['permission_denied_title'] as String,
        permissionDeniedBody: j['permission_denied_body'] as String,
        errorTitle: j['error_title'] as String,
      );
  final String title;
  final String syncedAt;
  final String syncing;
  final String refresh;
  final String caloriesActive;
  final String caloriesBasal;
  final String caloriesTotal;
  final String calorieGoal;
  final String calorieProgressPct;
  final String setGoalTitle;
  final String setGoalHint;
  final String statSteps;
  final String statDistance;
  final String statExercise;
  final String heartRateTitle;
  final String hrCurrent;
  final String hrAvg;
  final String hrMax;
  final String hrChartHint;
  final String zoneRest;
  final String zoneNormal;
  final String zoneModerate;
  final String zoneIntense;
  final String sleepTitle;
  final String sleepOptimal;
  final String sleepRegular;
  final String sleepInsufficient;
  final String sleepLastNight;
  final String workoutsTitle;
  final String noWorkoutsTitle;
  final String noWorkoutsBody;
  final String permissionTitle;
  final String permissionSubtitle;
  final List<String> permissionFeatures;
  final String permissionCta;
  final String permissionPrivacy;
  final String permissionDeniedTitle;
  final String permissionDeniedBody;
  final String errorTitle;

  String syncedTime(String time) => syncedAt.replaceAll('{time}', time);
  String caloriesTotalValue(String value) =>
      caloriesTotal.replaceAll('{value}', value);
  String calorieGoalValue(String value) =>
      calorieGoal.replaceAll('{value}', value);
  String progressPct(int pct) => calorieProgressPct.replaceAll('{pct}', '$pct');
}

// ─── Achievements ────────────────────────────────────────────────
class StreakMilestone {
  const StreakMilestone(
      {required this.days, required this.label, required this.emoji,});
  factory StreakMilestone.fromJson(Map<String, dynamic> j) => StreakMilestone(
        days: j['days'] as int,
        label: j['label'] as String,
        emoji: j['emoji'] as String,
      );
  final int days;
  final String label;
  final String emoji;
}

class AchievementsStrings {

  const AchievementsStrings({
    required this.title,
    required this.tabPrs,
    required this.tabStreak,
    required this.tabAchievements,
    required this.prsEmptyTitle,
    required this.prsEmptyBody,
    required this.prsBestLabel,
    required this.prsTapHint,
    required this.prs1rmLabel,
    required this.prsChartTitle,
    required this.streakCurrent,
    required this.streakBest,
    required this.streakMilestones,
    required this.streakMotivation0,
    required this.streakMotivation3,
    required this.streakMotivation7,
    required this.streakMotivation14,
    required this.streakMotivation30,
    required this.streakMotivationMax,
    required this.achievementsCollection,
    required this.achievementsUnlocked,
    required this.achievementsLocked,
    required this.prBannerTitle,
    required this.prBanner1rm,
  });

  factory AchievementsStrings.fromJson(Map<String, dynamic> j) =>
      AchievementsStrings(
        title: j['title'] as String,
        tabPrs: j['tab_prs'] as String,
        tabStreak: j['tab_streak'] as String,
        tabAchievements: j['tab_achievements'] as String,
        prsEmptyTitle: j['prs_empty_title'] as String,
        prsEmptyBody: j['prs_empty_body'] as String,
        prsBestLabel: j['prs_best_label'] as String,
        prsTapHint: j['prs_tap_hint'] as String,
        prs1rmLabel: j['prs_1rm_label'] as String,
        prsChartTitle: j['prs_chart_title'] as String,
        streakCurrent: j['streak_current'] as String,
        streakBest: j['streak_best'] as String,
        streakMilestones: (j['streak_milestones'] as List<dynamic>)
            .map((dynamic m) => StreakMilestone.fromJson(m as Map<String, dynamic>))
            .toList(),
        streakMotivation0: j['streak_motivation_0'] as String,
        streakMotivation3: j['streak_motivation_3'] as String,
        streakMotivation7: j['streak_motivation_7'] as String,
        streakMotivation14: j['streak_motivation_14'] as String,
        streakMotivation30: j['streak_motivation_30'] as String,
        streakMotivationMax: j['streak_motivation_max'] as String,
        achievementsCollection: j['achievements_collection'] as String,
        achievementsUnlocked: j['achievements_unlocked'] as String,
        achievementsLocked: j['achievements_locked'] as String,
        prBannerTitle: j['pr_banner_title'] as String,
        prBanner1rm: j['pr_banner_1rm'] as String,
      );
  final String title;
  final String tabPrs;
  final String tabStreak;
  final String tabAchievements;
  final String prsEmptyTitle;
  final String prsEmptyBody;
  final String prsBestLabel;
  final String prsTapHint;
  final String prs1rmLabel;
  final String prsChartTitle;
  final String streakCurrent;
  final String streakBest;
  final List<StreakMilestone> streakMilestones;
  final String streakMotivation0;
  final String streakMotivation3;
  final String streakMotivation7;
  final String streakMotivation14;
  final String streakMotivation30;
  final String streakMotivationMax;
  final String achievementsCollection;
  final String achievementsUnlocked;
  final String achievementsLocked;
  final String prBannerTitle;
  final String prBanner1rm;

  String streakBestDays(int days) => streakBest.replaceAll('{days}', '$days');
  String chartTitle(String exercise) =>
      prsChartTitle.replaceAll('{exercise}', exercise);
  String motivation(int streak) {
    if (streak == 0) {
      return streakMotivation0;
    }
    if (streak < 3) {
      return streakMotivation3;
    }
    if (streak < 7) {
      return streakMotivation7;
    }
    if (streak < 14) {
      return streakMotivation14;
    }
    if (streak < 30) {
      return streakMotivation30;
    }
    return streakMotivationMax.replaceAll('{days}', '$streak');
  }

  String banner1rm(String value) => prBanner1rm.replaceAll('{value}', value);
}

// ─── Recovery ────────────────────────────────────────────────────
class RecoveryStrings {

  const RecoveryStrings({
    required this.title,
    required this.frontView,
    required this.backView,
    required this.tapHint,
    required this.detailTitle,
    required this.legendFresh,
    required this.legendRecovering,
    required this.legendFatigued,
    required this.statusFresh,
    required this.statusRecovering,
    required this.statusFatigued,
    required this.noRecent,
    required this.alertFatiguedTitle,
    required this.alertFatiguedBody,
    required this.alertRecoveringTitle,
    required this.alertRecoveringBody,
    required this.alertFreshTitle,
    required this.alertFreshBody,
    required this.muscleNames,
  });

  factory RecoveryStrings.fromJson(Map<String, dynamic> j) => RecoveryStrings(
        title: j['title'] as String,
        frontView: j['front_view'] as String,
        backView: j['back_view'] as String,
        tapHint: j['tap_hint'] as String,
        detailTitle: j['detail_title'] as String,
        legendFresh: j['legend_fresh'] as String,
        legendRecovering: j['legend_recovering'] as String,
        legendFatigued: j['legend_fatigued'] as String,
        statusFresh: j['status_fresh'] as String,
        statusRecovering: j['status_recovering'] as String,
        statusFatigued: j['status_fatigued'] as String,
        noRecent: j['no_recent'] as String,
        alertFatiguedTitle: j['alert_fatigued_title'] as String,
        alertFatiguedBody: j['alert_fatigued_body'] as String,
        alertRecoveringTitle: j['alert_recovering_title'] as String,
        alertRecoveringBody: j['alert_recovering_body'] as String,
        alertFreshTitle: j['alert_fresh_title'] as String,
        alertFreshBody: j['alert_fresh_body'] as String,
        muscleNames: Map<String, String>.from(j['muscle_names'] as Map<dynamic, dynamic>),
      );
  final String title;
  final String frontView;
  final String backView;
  final String tapHint;
  final String detailTitle;
  final String legendFresh;
  final String legendRecovering;
  final String legendFatigued;
  final String statusFresh;
  final String statusRecovering;
  final String statusFatigued;
  final String noRecent;
  final String alertFatiguedTitle;
  final String alertFatiguedBody;
  final String alertRecoveringTitle;
  final String alertRecoveringBody;
  final String alertFreshTitle;
  final String alertFreshBody;
  final Map<String, String> muscleNames;

  String statusRecoveringHours(int hours) =>
      statusRecovering.replaceAll('{hours}', '$hours');
  String fatiguedBody(String muscles) =>
      alertFatiguedBody.replaceAll('{muscles}', muscles);
  String recoveringBody(String muscles) =>
      alertRecoveringBody.replaceAll('{muscles}', muscles);
  String muscleName(String key) => muscleNames[key] ?? key;
}

// ─── Overload ────────────────────────────────────────────────────
class OverloadStrings {

  const OverloadStrings({
    required this.suggestionIncrease,
    required this.suggestionMaintain,
    required this.increaseLabel,
  });

  factory OverloadStrings.fromJson(Map<String, dynamic> j) => OverloadStrings(
        suggestionIncrease: j['suggestion_increase'] as String,
        suggestionMaintain: j['suggestion_maintain'] as String,
        increaseLabel: j['increase_label'] as String,
      );
  final String suggestionIncrease;
  final String suggestionMaintain;
  final String increaseLabel;

  String increase(double value) =>
      increaseLabel.replaceAll('{value}', '$value');
}

// ─── Errors ──────────────────────────────────────────────────────
class ErrorStrings {

  const ErrorStrings({
    required this.generic,
    required this.healthLoad,
    required this.deleteConfirmTitle,
    required this.noConnection,
  });

  factory ErrorStrings.fromJson(Map<String, dynamic> j) => ErrorStrings(
        generic: j['generic'] as String,
        healthLoad: j['health_load'] as String,
        deleteConfirmTitle: j['delete_confirm_title'] as String,
        noConnection: j['no_connection'] as String,
      );
  final String generic;
  final String healthLoad;
  final String deleteConfirmTitle;
  final String noConnection;

  String healthLoadDetail(String detail) =>
      healthLoad.replaceAll('{detail}', detail);
}

// ─── Workout Types ───────────────────────────────────────────────
class WorkoutTypesStrings {

  const WorkoutTypesStrings({
    required this.strength,
    required this.functional,
    required this.running,
    required this.cycling,
    required this.walking,
    required this.swimming,
    required this.yoga,
    required this.hiit,
    required this.elliptical,
    required this.rowing,
    required this.stairClimbing,
    required this.defaultType,
  });

  factory WorkoutTypesStrings.fromJson(Map<String, dynamic> j) =>
      WorkoutTypesStrings(
        strength: j['strength'] as String,
        functional: j['functional'] as String,
        running: j['running'] as String,
        cycling: j['cycling'] as String,
        walking: j['walking'] as String,
        swimming: j['swimming'] as String,
        yoga: j['yoga'] as String,
        hiit: j['hiit'] as String,
        elliptical: j['elliptical'] as String,
        rowing: j['rowing'] as String,
        stairClimbing: j['stair_climbing'] as String,
        defaultType: j['default'] as String,
      );
  final String strength;
  final String functional;
  final String running;
  final String cycling;
  final String walking;
  final String swimming;
  final String yoga;
  final String hiit;
  final String elliptical;
  final String rowing;
  final String stairClimbing;
  final String defaultType;
}
