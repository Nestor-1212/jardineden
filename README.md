# 🌿 Jardín del Edén

Videojuego educativo cristiano bíblico para niños de 4 a 12 años.

---

## Información del Proyecto

| Campo | Valor |
|-------|-------|
| **Nombre** | Jardín del Edén |
| **Package (Android)** | `com.jardindeleden.app` |
| **Bundle ID (iOS)** | `com.jardindeleden.app` |
| **Flutter SDK** | `>=3.41.9` |
| **Dart SDK** | `>=3.11.5 <4.0.0` |
| **Android mínimo** | API 21 (Android 5.0) |
| **iOS mínimo** | 14.0 |
| **Plataformas** | Android, iOS |
| **Versión actual** | 0.1.0+1 |
| **Estado** | Sprint 01 — Fundación |

---

## Requisitos Previos

- Flutter SDK 3.41.9+ (usar FVM: `fvm use`)
- Android Studio / Xcode
- Dart 3.11.5+

---

## Primeros Pasos

```bash
# 1. Instalar dependencias
flutter pub get

# 2. Generar localización
flutter gen-l10n

# 3. Verificar el entorno
flutter doctor

# 4. Ejecutar en debug
flutter run

# 5. Ejecutar análisis estático (debe pasar con 0 issues)
flutter analyze

# 6. Verificar formato (debe salir con código 0 antes de cada PR)
dart format --set-exit-if-changed .

# 7. Ejecutar tests
flutter test
```

---

## Arquitectura

El proyecto sigue **Clean Architecture + Feature First + Riverpod**.

```
lib/
├── core/          # Infraestructura: DI, router, DB, logging, seguridad
├── features/      # 19 features organizadas por dominio de negocio
│   ├── auth/      # Perfiles y sesiones
│   ├── world/     # Mapa de mundos
│   ├── chapter/   # Historias bíblicas
│   ├── economy/   # Monedas del juego
│   └── ...        # (16 features adicionales)
└── shared/        # Design system y utilidades reutilizables
```

Consultar el **Flutter Technical Architecture Document** para el detalle completo.

---

## Convenciones

- Archivos: `snake_case`
- Clases: `UpperCamelCase`
- `flutter analyze` debe pasar con **0 issues** antes de cada PR
- `dart format --set-exit-if-changed .` debe salir con código 0 antes de cada PR
- Commits siguen **Conventional Commits**: `feat(economy): add daily Luz ceiling`
- Rama principal: `main` (protegida)
- Rama de desarrollo: `develop`

Nomenclatura, organización de carpetas, documentación y métricas de calidad
completas: [`lib/core/quality/code_conventions.dart`](lib/core/quality/code_conventions.dart).
Convenciones de testing: [`test/test_conventions.dart`](test/test_conventions.dart).

---

## Documentación del Proyecto

Los documentos oficiales del proyecto se encuentran en la carpeta `/docs/`:

- `01_game_design_document.md`
- `02_design_system.md`
- `03_ux_flow.md`
- `04_screen_specification.md`
- `05_data_architecture.md`
- `06_flutter_technical_architecture.md`
- `07_economy_system.md`
- `08_minigames_system.md`
- `09_audio_design.md`

---

*"Toda la Escritura es inspirada por Dios..."* — 2 Timoteo 3:16 (RVR2000)
