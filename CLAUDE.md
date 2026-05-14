# GymTrack Pro — CLAUDE.md

## Proyecto

App Flutter de seguimiento de gimnasio (GymTrack Pro). Flutter 3.35.7 via FVM.

## Comandos esenciales

> ⚠️ El entorno tiene `PUB_HOSTED_URL` apuntando a un servidor corporativo con error TLS.
> Siempre prefija los comandos `flutter` con `PUB_HOSTED_URL=https://pub.dev`:

```bash
PUB_HOSTED_URL=https://pub.dev fvm flutter run
PUB_HOSTED_URL=https://pub.dev fvm flutter analyze
PUB_HOSTED_URL=https://pub.dev fvm flutter pub get
dart analyze   # este no requiere el prefijo
```

## Arquitectura — MVP + Provider

Cada pantalla sigue el patrón **Model → Presenter → View**:

```
lib/screens/<feature>/
  <feature>_screen.dart      ← StatefulWidget, implementa BaseView<XModel>
  <feature>_presenter.dart   ← extiende BasePresenter<XView>, llama view.setUI()
```

- El **Presenter** lee providers/services vía `context`, construye el modelo tipado y llama `view.setUI(model)`.
- El **Screen** implementa `setUI` y llama `setState` ahí dentro.
- El entry point siempre es `_presenter.getUI(context)` en `initState`.
- `BasePresenter` y `BaseView` están en [lib/core/presenter/base_presenter.dart](lib/core/presenter/base_presenter.dart).

**No mezcles lógica de negocio en los Widgets.** Si algo no cabe en el presenter, va en un `Service`.

## Capas

| Capa      | Dónde                                            | Qué hace                                           |
| --------- | ------------------------------------------------ | -------------------------------------------------- |
| UI        | `lib/screens/`                                   | Solo rendering y eventos de usuario                |
| Presenter | `lib/screens/<feature>/<feature>_presenter.dart` | Lógica de presentación, construye el modelo        |
| Provider  | `lib/providers/`                                 | Estado compartido entre pantallas (ChangeNotifier) |
| Service   | `lib/services/`                                  | Acceso a DB, salud, auth, lógica de dominio        |
| Model     | `lib/models/`                                    | DTOs puros, sin lógica                             |

## Estándares de código Dart/Flutter

### Tipos y nulabilidad

- Siempre declarar tipos explícitos (`always_specify_types` activo).
- Nunca usar `dynamic` salvo que sea inevitable — y si lo es, documenta por qué.
- Preferir `final` para variables locales y campos (`prefer_final_locals`, `prefer_final_fields`).
- Usar `late` solo para campos privados que se inicializan antes de su primer uso.

### Estilo

- Single quotes para strings: `'texto'`, no `"texto"`.
- Trailing commas en listas/constructores multilinea (`require_trailing_commas`).
- Siempre declarar tipo de retorno en funciones.
- No usar `print()` — si necesitas log, usa un servicio o elimínalo antes de commit.
- Llaves siempre en control flow (`curly_braces_in_flow_control_structures`).

### Widgets

- `const` siempre que sea posible (`prefer_const_constructors`).
- `Key` en todos los widgets públicos (`use_key_in_widget_constructors`).
- No devolver widgets desde métodos — extrae en clases Widget (`avoid-returning-widgets`).
- No anidar condicionales (`avoid-nested-conditional-expressions`).
- `SizedBox` para espacios, no `Container` vacíos.

### Async

- Siempre `await` los futures o envuelve con `unawaited()` si es intencional.
- No usar `void` en funciones `async` que deberían retornar `Future`.

### Organización de imports

Orden: dart → flutter → packages externos → imports internos del proyecto.

## Linting

El proyecto tiene reglas estrictas en [analysis_options.yaml](analysis_options.yaml).
Antes de terminar cualquier cambio: `fvm flutter analyze` debe pasar limpio (0 warnings nuevos introducidos por los cambios).

Métricas clave (dart_code_metrics):

- Complejidad ciclomática máx: 11
- Anidamiento máx: 3
- Métodos por clase máx: 3
- Parámetros por función máx: 4
- SLOC por archivo máx: 250

## Base de datos

SQLite via `sqflite`. Singleton en [lib/services/database_service.dart](lib/services/database_service.dart).
No hacer queries directas en Widgets ni Presenters — todo pasa por `DatabaseService`.

## Autenticación

Firebase Auth con email, Google Sign-In y Sign in with Apple. Lógica en [lib/services/auth_service.dart](lib/services/auth_service.dart).

## i18n — Sistema de textos (regla obligatoria)

**Ningún texto visible al usuario puede estar hardcodeado en un Widget.** Todo pasa por el sistema de localización.

### Flujo completo

```
assets/i18n/{lang}.json  →  LanguageProvider (carga en startup)
  ↓  context.read<LanguageProvider>().strings  (en el Presenter)
  AppLocalizations → sección tipada (e.g. s.login)
  ↓  Presenter construye UiModel con los campos de texto
  view.setUI(model)
  ↓  Widget usa _model.someLabel en build()
```

### Reglas

1. **Un JSON por idioma** (`es.json`, `en.json`) en `assets/i18n/`.  
   Cada feature tiene su propia sección raíz: `"login": { ... }`, `"home": { ... }`.

2. **Clase tipada por sección**: cada sección JSON tiene su clase `XxxStrings` en  
   [lib/i18n/app_localizations.dart](lib/i18n/app_localizations.dart).  
   La clase se registra en `AppLocalizations` (constructor + `fromJson`).

3. **El Presenter lee los textos**, los mete en el UiModel y llama `view.setUI(model)`.  
   El Widget no accede a `LanguageProvider` directamente.

4. **El UiModel contiene los strings** como campos `final String`:  
   ```dart
   class LoginModel {
     const LoginModel({required this.titleGoogle, ...});
     final String titleGoogle;
   }
   ```

5. Mensajes de error, labels de botones, títulos de dialogs: **todo en JSON**.

### Para agregar textos de una nueva feature

```
1. Agregar sección en assets/i18n/es.json y en.json
2. Crear clase XxxStrings con fromJson en app_localizations.dart
3. Registrar en AppLocalizations (constructor + fromJson + campo final)
4. En el Presenter: final s = context.read<LanguageProvider>().strings.xxx;
5. Incluir en el UiModel y pasar al Widget via setUI
```

## Lo que NO hacer

- No agregar lógica de negocio en Widgets.
- No crear nuevos providers si un Service alcanza.
- No usar `!` (non-null assertion) sin justificación — regla `avoid-non-null-assertion` activa.
- No hacer `setState` fuera de `setUI` en screens que usan el patrón MVP.
- No commitear con warnings nuevos en `flutter analyze`.
- No agregar comentarios innesesarios
