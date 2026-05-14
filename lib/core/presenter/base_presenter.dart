import 'package:flutter/widgets.dart';

// ─────────────────────────────────────────────────────────────────
// BASE VIEW  — generic abstract interface every screen implements
// ─────────────────────────────────────────────────────────────────
//
// Pattern:
//   • Presenter calls view.setUI(model) whenever data changes.
//   • [M] is the screen's typed model (e.g. HomeModel).
//   • The screen's State implements this and calls setState inside setUI.
//
abstract class BaseView<M> {
  /// Called by the presenter to push a fully-built [model] to the screen.
  /// The screen MUST update its local state and trigger a rebuild.
  void setUI(M model);
}

// ─────────────────────────────────────────────────────────────────
// BASE PRESENTER — abstract class every presenter extends
// ─────────────────────────────────────────────────────────────────
//
// Pattern in every screen's initState:
//   _presenter = XPresenter(view: this, ...);
//   _presenter.getUI(context);   ← single entry point
//
// The presenter:
//   1. Reads providers/services via [context].
//   2. Builds the typed model.
//   3. Calls view.setUI(model).
//
abstract class BasePresenter<V extends BaseView<dynamic>> {
  BasePresenter({required this.view});
  final V view;

  /// Entry point called from every screen's initState.
  void getUI(BuildContext context);

  /// Called when something external changes (language switch, provider update).
  void refresh(BuildContext context) => getUI(context);

  /// Release all listeners and resources.
  void dispose() {}
}
