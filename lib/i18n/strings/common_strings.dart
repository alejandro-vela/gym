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
