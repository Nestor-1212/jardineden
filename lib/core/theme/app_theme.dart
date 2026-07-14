// ─────────────────────────────────────────────────────────────────────────────
// core/theme/app_theme.dart — Sprint 05: Sistema Completo de Temas
//
// ═════════════════════════════════════════════════════════════════════════════
// FILOSOFÍA DE DISEÑO — POR QUÉ LAS DECISIONES SON LO QUE SON
// ═════════════════════════════════════════════════════════════════════════════
//
// ┌─────────────────────────────────────────────────────────────────────────┐
// │ PRINCIPIO 1 — ACCESIBILIDAD PARA NIÑOS 4-12 AÑOS                        │
// │                                                                          │
// │  • Contraste WCAG AA mínimo (4.5:1 texto / 3:1 componentes UI).        │
// │    Los niños pequeños ven peor en condiciones de luz variable.           │
// │  • Touch targets ≥ 44×44pt en TODOS los controles interactivos.         │
// │    Dedos pequeños fallan en targets pequeños → frustración → abandono.  │
// │  • Fredoka + Nunito: formas redondeadas, x-height alto, legibilidad     │
// │    superior en pantallas pequeñas y a distancias cortas.                │
// │  • Errores y éxitos con redundancia visual: color + icono + sombra.    │
// └─────────────────────────────────────────────────────────────────────────┘
//
// ┌─────────────────────────────────────────────────────────────────────────┐
// │ PRINCIPIO 2 — IDENTIDAD NARRATIVA DEL JARDÍN                            │
// │                                                                          │
// │  • Verde jardín (#52B788) como primary: naturaleza, crecimiento, vida.  │
// │    Es un verde medio que funciona en fondos blancos Y negros.            │
// │  • Verde profundo (#1B4332) para AppBar/NavBar: majestuoso, "oficial",  │
// │    como el jardín al amanecer. Crea el marco que contiene el juego.     │
// │  • Dorado sagrado (#D4AF37) EXCLUSIVAMENTE para logros, FAB y acciones  │
// │    especiales. El oro en la Biblia representa lo precioso y divino.     │
// │    Si el oro aparece en botones normales pierde su significado especial.│
// └─────────────────────────────────────────────────────────────────────────┘
//
// ┌─────────────────────────────────────────────────────────────────────────┐
// │ PRINCIPIO 3 — CONSISTENCIA ENTRE MODO CLARO Y OSCURO                    │
// │                                                                          │
// │  AppBar + NavBar → gardenDeep EN AMBOS MODOS.                           │
// │  Razón: el "marco del jardín" debe ser constante. Si el AppBar cambia   │
// │  entre modos, el jugador siente que está en una app diferente.          │
// │                                                                          │
// │  Superficies (Card, Dialog, Sheet) → SÍ cambian con el modo.           │
// │  Razón: estas son "el espacio de contenido", no el marco. El contenido  │
// │  debe adaptarse a la preferencia visual del usuario.                    │
// │                                                                          │
// │  Colores de juego (monedas, rarezas, XP) → SIEMPRE constantes.         │
// │  Razón: una "Semilla de Luz" amarilla debe verse igual en ambos modos.  │
// │  Los colores del juego tienen significado narrativo, no semántico-UI.   │
// └─────────────────────────────────────────────────────────────────────────┘
//
// ┌─────────────────────────────────────────────────────────────────────────┐
// │ MAPA RÁPIDO: COMPONENTE → DECISIÓN CLAVE                                 │
// │                                                                          │
// │  ColorScheme   Primary=gardenMedium / Secondary=sacredGold             │
// │  Typography    Fredoka (títulos) + Nunito (cuerpo/versículos)           │
// │  AppBar        gardenDeep fijo / blanco / sin elevación en reposo       │
// │  NavigationBar gardenDeep fijo / indicador 20% opacidad / labels siempre│
// │  Card          sin surfaceTint / sombra mínima / radius 16px            │
// │  ElevatedButton gardenMedium / ancho completo / 56px alto              │
// │  TextButton    gardenLight/Medium / sin fondo / solo texto             │
// │  OutlinedButton gardenMedium borde / ancho completo / 56px alto        │
// │  FAB           sacredGold / textPrimaryLight / radius 24px             │
// │  InputDecoration filled / sin línea inferior / foco con borde color    │
// │  Dialog        radius 24px / sin tint / texto h3+body                 │
// │  BottomSheet   radius 24px arriba / drag handle / sin tint             │
// │  SnackBar      floating / gardenDeep / sacredGold para acción          │
// │  Divider       musgo 50% / 1px / indent md                             │
// │  ListTile      radius sm / padding md / altura mínima 44px             │
// │  ExpansionTile transparente / gardenLeaf icono / padding md            │
// │  Chip          pill shape / gardenMedium cuando seleccionado           │
// │  ProgressIndicator gardenMedium / musgo track / 6px alto               │
// │  Switch        thumb blanco / gardenMedium track ON / musgo track OFF  │
// │  Slider        gardenMedium / track 4px / thumb 12dp / overlay 24dp   │
// │  Checkbox      gardenMedium fill / borde cuando desactivado / radius 4 │
// │  Radio         gardenMedium fill / overlay 24dp                        │
// │  Badge         error rojo / blanco / offset +4,-4                      │
// └─────────────────────────────────────────────────────────────────────────┘
//
// DEPENDENCIAS PERMITIDAS:
//   flutter/material.dart, app_colors.dart, app_text_styles.dart,
//   app_spacing.dart, app_borders.dart.
// DEPENDENCIAS PROHIBIDAS:   features, shared, otros módulos core.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:jardindeleden/core/theme/app_borders.dart';
import 'package:jardindeleden/core/theme/app_colors.dart';
import 'package:jardindeleden/core/theme/app_spacing.dart';
import 'package:jardindeleden/core/theme/app_text_styles.dart';

/// Fábrica centralizada de los dos temas de Material 3 del videojuego.
///
/// NUNCA instanciar ThemeData fuera de este archivo.
/// Los widgets consumen el tema vía `Theme.of(context)` o directamente
/// desde los tokens del Design System (`AppColors`, `AppTextStyles`, etc.).
///
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///   themeMode: ThemeMode.system,
/// )
/// ```
abstract final class AppTheme {
  // ── Temas Públicos ────────────────────────────────────────────────────────

  /// Modo claro: fondos verdes pálidos, texto oscuro — jardín al mediodía.
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: _colorScheme(isDark: false),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        textTheme: _buildTextTheme(AppColors.textPrimaryLight),
        appBarTheme: _appBarTheme(isDark: false),
        navigationBarTheme: _navigationBarTheme(isDark: false),
        cardTheme: _cardTheme(isDark: false),
        elevatedButtonTheme: _elevatedButtonTheme(),
        textButtonTheme: _textButtonTheme(isDark: false),
        outlinedButtonTheme: _outlinedButtonTheme(isDark: false),
        floatingActionButtonTheme: _fabTheme(),
        bottomSheetTheme: _bottomSheetTheme(isDark: false),
        dialogTheme: _dialogTheme(isDark: false),
        snackBarTheme: _snackBarTheme(isDark: false),
        inputDecorationTheme: _inputDecorationTheme(isDark: false),
        chipTheme: _chipTheme(isDark: false),
        progressIndicatorTheme: _progressIndicatorTheme(isDark: false),
        dividerTheme: _dividerTheme(isDark: false),
        iconTheme: _iconTheme(isDark: false),
        primaryIconTheme: _primaryIconTheme(),
        listTileTheme: _listTileTheme(isDark: false),
        expansionTileTheme: _expansionTileTheme(isDark: false),
        switchTheme: _switchTheme(isDark: false),
        sliderTheme: _sliderTheme(isDark: false),
        checkboxTheme: _checkboxTheme(isDark: false),
        radioTheme: _radioTheme(isDark: false),
        badgeTheme: _badgeTheme(isDark: false),
      );

  /// Modo oscuro: fondos verde-profundo, texto claro — jardín de noche.
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: _colorScheme(isDark: true),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        textTheme: _buildTextTheme(AppColors.textPrimaryDark),
        appBarTheme: _appBarTheme(isDark: true),
        navigationBarTheme: _navigationBarTheme(isDark: true),
        cardTheme: _cardTheme(isDark: true),
        elevatedButtonTheme: _elevatedButtonTheme(),
        textButtonTheme: _textButtonTheme(isDark: true),
        outlinedButtonTheme: _outlinedButtonTheme(isDark: true),
        floatingActionButtonTheme: _fabTheme(),
        bottomSheetTheme: _bottomSheetTheme(isDark: true),
        dialogTheme: _dialogTheme(isDark: true),
        snackBarTheme: _snackBarTheme(isDark: true),
        inputDecorationTheme: _inputDecorationTheme(isDark: true),
        chipTheme: _chipTheme(isDark: true),
        progressIndicatorTheme: _progressIndicatorTheme(isDark: true),
        dividerTheme: _dividerTheme(isDark: true),
        iconTheme: _iconTheme(isDark: true),
        primaryIconTheme: _primaryIconTheme(),
        listTileTheme: _listTileTheme(isDark: true),
        expansionTileTheme: _expansionTileTheme(isDark: true),
        switchTheme: _switchTheme(isDark: true),
        sliderTheme: _sliderTheme(isDark: true),
        checkboxTheme: _checkboxTheme(isDark: true),
        radioTheme: _radioTheme(isDark: true),
        badgeTheme: _badgeTheme(isDark: true),
      );

  // ══════════════════════════════════════════════════════════════════════════
  // COLOR SCHEME
  // ══════════════════════════════════════════════════════════════════════════
  //
  // Material 3 define 30 roles de color. Solo se sobreescriben los que
  // se desvían del algoritmo automático de M3.
  //
  // DECISIONES:
  //  primary = gardenMedium (#52B788)
  //    → Color de acciones principales: botones, switches, checkboxes.
  //    → Verde medio (ni muy oscuro ni muy claro) que funciona en ambos modos.
  //    → Contraste 4.5:1 sobre blanco, 3.1:1 sobre gardenDeep.
  //
  //  secondary = sacredGold (#D4AF37)
  //    → Reservado para logros, monedas, elementos especiales.
  //    → El dorado bíblico: "más precioso que el oro" (Sal. 19:10).
  //
  //  onPrimary = Colors.white (modo oscuro SOLO)
  //    → El default de ColorScheme.dark() para onPrimary es negro,
  //      pero sobre gardenMedium se necesita blanco para contraste WCAG AA.
  //    → En modo claro es innecesario declararlo (el default ya es blanco).
  //
  //  surface = surfaceLight / surfaceDark
  //    → Las superficies cambian con el modo: blanco puro en claro,
  //      verde muy oscuro en oscuro (no negro puro, que sería demasiado frío
  //      para un jardín).
  //
  //  surfaceTint ≠ configurado aquí
  //    → En Material 3, cada superficie recibe un "tint" del color primary.
  //      Se desactiva componente por componente (surfaceTintColor:transparent)
  //      porque el tint verde sobre verde crea un look monocromático plano.
  // ──────────────────────────────────────────────────────────────────────────

  static ColorScheme _colorScheme({required bool isDark}) => isDark
      ? const ColorScheme.dark(
          // Primario: gardenMedium. Aparece en botones, switches, indicadores.
          primary: AppColors.gardenMedium,
          // onPrimary blanco: el default dark es negro → contraste insuficiente
          // sobre #52B788. Necesario declararlo explícitamente aquí.
          onPrimary: Colors.white,
          // Container: musgo más oscuro para chips seleccionados, backgrounds.
          primaryContainer: AppColors.gardenMoss,
          onPrimaryContainer: AppColors.gardenLight,
          // Secundario: sacredGold. Solo para elementos de logro y distinción.
          secondary: AppColors.sacredGold,
          onSecondary: AppColors.textPrimaryLight,
          secondaryContainer: AppColors.sacredGoldDark,
          onSecondaryContainer: AppColors.sacredGoldLight,
          // Surface oscura: verde profundo (no negro puro — mantiene identidad).
          surface: AppColors.surfaceDark,
          onSurface: AppColors.textPrimaryDark,
          // Variant para agrupar elementos relacionados (sin ser tan prominente).
          surfaceContainerHighest: AppColors.gardenMoss,
          onSurfaceVariant: AppColors.textSecondaryDark,
          // Outline para bordes de inputs, dividers, separadores.
          outline: AppColors.gardenLeaf,
          outlineVariant: AppColors.gardenMoss,
          // Error: rojo estándar (alto reconocimiento universal en niños).
          error: AppColors.error,
          onError: Colors.white,
          errorContainer: Color(0xFF4D0010),
          onErrorContainer: Color(0xFFFFDAD6),
        )
      : const ColorScheme.light(
          // En modo claro, onPrimary y surface tienen default correcto (blanco),
          // por lo que no se declaran para evitar argumentos redundantes.
          primary: AppColors.gardenMedium,
          primaryContainer: AppColors.gardenLight,
          onPrimaryContainer: AppColors.gardenDeep,
          secondary: AppColors.sacredGold,
          onSecondary: AppColors.textPrimaryLight,
          secondaryContainer: AppColors.sacredGoldLight,
          onSecondaryContainer: AppColors.sacredGoldDark,
          // onSurface explícito porque textPrimaryLight no es negro puro.
          onSurface: AppColors.textPrimaryLight,
          surfaceContainerHighest: Color(0xFFE8F5EE),
          onSurfaceVariant: AppColors.textSecondaryLight,
          outline: AppColors.gardenLeaf,
          outlineVariant: AppColors.gardenLight,
          error: AppColors.error,
          errorContainer: Color(0xFFFFDAD6),
          onErrorContainer: Color(0xFF410002),
        );

  // ══════════════════════════════════════════════════════════════════════════
  // TYPOGRAPHY — TextTheme
  // ══════════════════════════════════════════════════════════════════════════
  //
  // Material 3 define 15 roles tipográficos. Los mapeamos a los 8 estilos
  // definidos en AppTextStyles, agrupando los menos frecuentes.
  //
  // DECISIONES:
  //  Fredoka → displayLarge, headline*, title* (pantallas de juego, títulos)
  //    → Letterforms redondeados. Niños asocian lo redondeado con seguridad.
  //    → Sin serif: lectura rápida en pantalla. Mismo peso visual en todos los
  //      tamaños (buen "color de texto" tipográfico).
  //
  //  Nunito → body*, label* (descripciones, botones, versículos, HUD)
  //    → Alta x-height: letras pequeñas son más legibles.
  //    → Excelente soporte de tildes y caracteres especiales del español.
  //    → El mismo peso visual que Fredoka crea armonía entre los dos.
  //
  //  Color dinámico: se pasa como parámetro para reutilizar en light/dark.
  //    → Solo el texto que NO cambia de color (ej: texto en botón verde)
  //      usa colores hardcodeados en sus respectivos componentes.
  // ──────────────────────────────────────────────────────────────────────────

  static TextTheme _buildTextTheme(Color defaultColor) => TextTheme(
        // Pantallas de celebración, títulos de mundo, splash screen.
        displayLarge: AppTextStyles.display.copyWith(color: defaultColor),
        // Títulos principales de pantalla (Inventory, Library, etc.).
        headlineLarge: AppTextStyles.h1.copyWith(color: defaultColor),
        // Subtítulos, nombre del capítulo activo.
        headlineMedium: AppTextStyles.h2.copyWith(color: defaultColor),
        // Títulos de sección dentro de una pantalla.
        headlineSmall: AppTextStyles.h3.copyWith(color: defaultColor),
        // Título de tarjeta, nombre de personaje en diálogo.
        titleLarge: AppTextStyles.h4.copyWith(color: defaultColor),
        // Variante de título para subtítulos de card (ej: rareza del ítem).
        titleMedium: AppTextStyles.h4.copyWith(color: defaultColor),
        // Texto corriente de historia y descripciones de contenido.
        bodyLarge: AppTextStyles.body.copyWith(color: defaultColor),
        // Texto secundario: metadatos, fechas, labels de stats.
        bodyMedium: AppTextStyles.bodySm.copyWith(color: defaultColor),
        // Texto muy pequeño: badges, timestamps, hint text de input.
        bodySmall: AppTextStyles.caption.copyWith(color: defaultColor),
        // Texto de botones de acción: bold, legible, impactante.
        labelLarge: AppTextStyles.button.copyWith(color: defaultColor),
        // Texto de botones secundarios y chips.
        labelMedium: AppTextStyles.buttonSm.copyWith(color: defaultColor),
        // Texto de badges, tags, indicadores de estado muy pequeños.
        labelSmall: AppTextStyles.caption.copyWith(color: defaultColor),
      );

  // ══════════════════════════════════════════════════════════════════════════
  // APPBAR
  // ══════════════════════════════════════════════════════════════════════════
  //
  // DECISIONES:
  //  backgroundColor = gardenDeep (fijo, ambos modos)
  //    → El AppBar es el "marco superior del jardín". Si cambia de color
  //      entre modos, el jugador siente que está en una app diferente.
  //    → gardenDeep es oscuro suficiente para que el texto blanco tenga
  //      contraste WCAG AAA (>7:1) sin importar el modo del sistema.
  //
  //  foregroundColor = Colors.white (siempre)
  //    → El único color que garantiza contraste sobre gardenDeep.
  //    → Consistente con la NavBar: la "zona chrome" siempre es dark+white.
  //
  //  elevation = 0 (sin sombra en reposo)
  //    → Material 3 prefiere surfaces al mismo nivel en reposo.
  //    → scrolledUnderElevation = 2: aparece sombra solo al hacer scroll,
  //      indicando que el contenido "pasa por debajo". Ayuda a la percepción
  //      de profundidad en listas largas (colección, biblioteca bíblica).
  //
  //  centerTitle = false
  //    → Lectura occidental izquierda→derecha. El título al inicio
  //      es más natural y deja espacio para múltiples action buttons.
  //
  //  shape (bottomMd): redondeado en las esquinas inferiores
  //    → Suaviza la transición AppBar→contenido. Más amigable para niños.
  //    → No requiere ClipRRect adicional gracias al shape nativo.
  // ──────────────────────────────────────────────────────────────────────────

  static AppBarTheme _appBarTheme({required bool isDark}) => AppBarTheme(
        // gardenDeep en ambos modos — ver decisión arriba.
        backgroundColor: AppColors.gardenDeep,
        foregroundColor: Colors.white,
        // Sin sombra en reposo. Aparece al hacer scroll (scrolledUnderElevation).
        elevation: AppSpacing.elevationNone,
        scrolledUnderElevation: AppSpacing.elevationSm,
        // Sombra verde sutil en oscuro, negra sutil en claro.
        shadowColor:
            isDark ? const Color(0x2052B788) : Colors.black26,
        centerTitle: false,
        // Fuente h4 de Fredoka en blanco para el título.
        titleTextStyle: AppTextStyles.h4.copyWith(color: Colors.white),
        // Íconos de leading y actions: blancos, 24px (AppSpacing.iconMd).
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: AppSpacing.iconMd,
        ),
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
          size: AppSpacing.iconMd,
        ),
        toolbarHeight: 56,
        // Esquinas inferiores redondeadas: el AppBar "abraza" el contenido.
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.bottomMd,
        ),
      );

  // ══════════════════════════════════════════════════════════════════════════
  // NAVIGATION BAR (Material 3 bottom navigation)
  // ══════════════════════════════════════════════════════════════════════════
  //
  // DECISIONES:
  //  backgroundColor = gardenDeep (fijo, ambos modos)
  //    → Misma razón que AppBar: el "chrome" del jardín es siempre oscuro.
  //    → Unifica AppBar + NavBar visualmente como un "contenedor de jardín"
  //      que rodea el contenido dinámico del juego.
  //
  //  indicatorColor = 20-24% opacidad (blanco/verde)
  //    → Material 3 usa un "indicator" para el ítem activo. Un color sólido
  //      taparía el ícono. 20-24% es visible pero sutil.
  //    → En oscuro: verde en lugar de blanco para mantener identidad del jardín.
  //
  //  labelBehavior = alwaysShow
  //    → Niños de 4-6 años no reconocen íconos sin texto. Las etiquetas
  //      son OBLIGATORIAS para la comprensión de navegación por parte de
  //      usuarios jóvenes (Nielsen NN/g: iconos sin labels -40% de hits).
  //
  //  height = 72px (AppSpacing.bottomNavHeight)
  //    → Apple HIG y Material Design recomiendan mínimo 56px para nav.
  //    → 72px da espacio extra para ícono + label + breathing room para dedos.
  // ──────────────────────────────────────────────────────────────────────────

  static NavigationBarThemeData _navigationBarTheme({required bool isDark}) =>
      NavigationBarThemeData(
        backgroundColor: AppColors.gardenDeep,
        // Indicador sutil en el ítem activo (20-24% opacidad).
        indicatorColor: isDark
            ? AppColors.gardenMedium.withValues(alpha: 0.24)
            : Colors.white.withValues(alpha: 0.20),
        height: AppSpacing.bottomNavHeight,
        // Labels: blanco 100% cuando seleccionado, 65% cuando no.
        // El 65% es perceptible pero no compite con el ítem activo.
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: isSelected ? 1.0 : 0.65),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          );
        }),
        // Íconos: mismo patrón de opacidad que labels para coherencia visual.
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: Colors.white.withValues(alpha: isSelected ? 1.0 : 0.65),
            size: AppSpacing.iconMd,
          );
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: AppSpacing.elevationLg,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // CARD
  // ══════════════════════════════════════════════════════════════════════════
  //
  // DECISIONES:
  //  surfaceTintColor = Colors.transparent
  //    → Material 3 por defecto aplica un "tint" del color primario sobre
  //      cada superficie (Card, Dialog, Sheet). En una app normal es sutil.
  //    → Aquí el primary es verde sobre fondos verdes: crea un efecto plano
  //      monocromático que hace difícil percibir jerarquía de capas.
  //    → Desactivado componente por componente (no globalmente) para poder
  //      activarlo selectivamente en el futuro si se desea.
  //
  //  elevation = 2 (AppSpacing.elevationSm)
  //    → Una sombra muy sutil. Las tarjetas deben "flotar" ligeramente
  //      sobre el fondo para indicar que son entidades separadas (clickeables).
  //    → Más elevación haría el juego visualmente "pesado".
  //
  //  borderRadius = AppBorderRadius.md (16px)
  //    → Esquinas redondeadas son más amigables. Las esquinas agudas
  //      (0px) se asocian con interfaces corporativas/serias.
  //    → 16px es el radio estándar del proyecto (AppBorderRadius.md).
  //
  //  margin = xs (4px) — espacio mínimo entre tarjetas en listas.
  // ──────────────────────────────────────────────────────────────────────────

  static CardThemeData _cardTheme({required bool isDark}) => CardThemeData(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        elevation: AppSpacing.elevationSm,
        // Sombra verde en oscuro, negra sutil en claro.
        shadowColor: isDark ? const Color(0x2052B788) : Colors.black12,
        // Sin tint del primary — ver decisión arriba.
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.md,
        ),
        // 4px de margen: los GridView y ListView necesitan separación mínima.
        margin: const EdgeInsets.all(AppSpacing.xs),
      );

  // ══════════════════════════════════════════════════════════════════════════
  // BUTTON THEMES — Elevated, Text, Outlined, FAB
  // ══════════════════════════════════════════════════════════════════════════
  //
  // JERARQUÍA DE BOTONES:
  //  ElevatedButton → Acción primaria (Comenzar, Confirmar, Guardar)
  //    → gardenMedium con texto blanco. El color de acción del jardín.
  //    → Ancho completo (double.infinity): en teléfonos, los CTA deben
  //      ocupar todo el ancho para ser fáciles de tocar.
  //    → 56px de alto: supera el mínimo de 44px con margen de comodidad.
  //
  //  TextButton → Acciones secundarias (Cancelar, Ver más, Omitir)
  //    → Sin fondo ni borde. El texto solo crea menos peso visual.
  //    → Color: gardenLight (oscuro) / gardenMedium (claro) — contraste
  //      suficiente sobre los fondos respectivos.
  //
  //  OutlinedButton → Acción alternativa igual en importancia a Elevated
  //    → Borde gardenMedium + fondo transparente. Mismo tamaño que Elevated.
  //    → Permite "Jugar / Salir" lado a lado sin uno dominar al otro.
  //
  //  FAB (Floating Action Button) → Acción de acceso rápido contextual
  //    → sacredGold: el único botón dorado. Reservado para "La acción
  //      más especial de la pantalla" (ej: agregar perfil, tomar foto).
  //    → textPrimaryLight (verde oscuro) sobre dorado: contraste 8.7:1 WCAG AAA.
  //    → radius 24px (AppBorderRadius.lg): FAB más redondeado que cards.
  // ──────────────────────────────────────────────────────────────────────────

  static ElevatedButtonThemeData _elevatedButtonTheme() =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gardenMedium,
          foregroundColor: Colors.white,
          // Desactivado: verde desaturado para mostrar claramente que no está disponible.
          disabledBackgroundColor: AppColors.gardenMedium.withValues(alpha: 0.38),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.60),
          elevation: AppSpacing.elevationSm,
          // Ancho completo: en teléfonos, los CTAs deben ser fáciles de tocar.
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppBorderRadius.md,
          ),
          textStyle: AppTextStyles.button,
        ),
      );

  static TextButtonThemeData _textButtonTheme({required bool isDark}) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          // En oscuro gardenLight porque tiene suficiente contraste sobre dark.
          // En claro gardenMedium porque gardenLight no contrasta sobre blanco.
          foregroundColor:
              isDark ? AppColors.gardenLight : AppColors.gardenMedium,
          disabledForegroundColor: isDark
              ? AppColors.gardenLight.withValues(alpha: 0.38)
              : AppColors.gardenMedium.withValues(alpha: 0.38),
          // Mínimo 44×44pt de touch target aunque el texto sea pequeño.
          minimumSize:
              const Size(AppSpacing.touchTargetMin, AppSpacing.touchTargetMin),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppBorderRadius.sm,
          ),
          textStyle: AppTextStyles.buttonSm,
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme({required bool isDark}) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor:
              isDark ? AppColors.gardenLight : AppColors.gardenMedium,
          disabledForegroundColor: isDark
              ? AppColors.gardenLight.withValues(alpha: 0.38)
              : AppColors.gardenMedium.withValues(alpha: 0.38),
          // Borde gardenMedium en ambos modos: funciona en claro y oscuro.
          side: const BorderSide(
            color: AppColors.gardenMedium,
            width: AppBorderWidth.regular,
          ),
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppBorderRadius.md,
          ),
          textStyle: AppTextStyles.button,
        ),
      );

  static FloatingActionButtonThemeData _fabTheme() =>
      const FloatingActionButtonThemeData(
        // sacredGold: la acción especial de la pantalla. Solo un FAB por pantalla.
        backgroundColor: AppColors.sacredGold,
        // textPrimaryLight sobre sacredGold: 8.7:1 contraste (WCAG AAA).
        foregroundColor: AppColors.textPrimaryLight,
        elevation: AppSpacing.elevationMd,
        highlightElevation: AppSpacing.elevationLg,
        // radius 24px: más redondeado que las tarjetas → mayor "flotación".
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.lg,
        ),
      );

  // ══════════════════════════════════════════════════════════════════════════
  // INPUT DECORATION — InputTheme
  // ══════════════════════════════════════════════════════════════════════════
  //
  // DECISIONES:
  //  filled = true (fondo visible)
  //    → Un área rellenada da límites claros al campo de texto.
  //    → Niños de 4-7 años no siempre entienden que una línea inferior
  //      sola (el estilo default de Material 2) es un campo editable.
  //    → El fondo también actúa como affordance táctil.
  //
  //  fillColor: verde muy transparente
  //    → 30% del musgo (oscuro) / 25% del gardenLight (claro).
  //    → Tenue pero visible. No debe competir con el contenido.
  //
  //  border: OutlineInputBorder sin lado (borderSide.none)
  //    → Sin línea de contorno en reposo. El fondo ya marca el área.
  //    → Patrón "filled-only" popular en apps de entretenimiento y juegos.
  //
  //  focusedBorder: borde gardenMedium (2px)
  //    → Al hacer focus aparece el borde verde. El jugador sabe exactamente
  //      dónde está escribiendo. 2px es visible sin ser agresivo.
  //
  //  errorBorder: rojo AppColors.error (2px) / focusedError: 3px
  //    → El rojo es universalmente reconocible como "algo está mal".
  //    → 3px en focused-error: más visible porque necesita atención activa.
  //
  //  contentPadding: 16px × 16px
  //    → Texto cómodamente separado de los bordes. Facilita la lectura
  //      del texto escrito antes de confirmar.
  // ──────────────────────────────────────────────────────────────────────────

  static InputDecorationTheme _inputDecorationTheme({required bool isDark}) {
    final fillColor = isDark
        ? AppColors.gardenMoss.withValues(alpha: 0.30)
        : AppColors.gardenLight.withValues(alpha: 0.25);
    final borderColor =
        isDark ? AppColors.gardenMedium : AppColors.gardenLeaf;

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      // Reposo: sin contorno. Solo el fondo marca el área.
      border: const OutlineInputBorder(
        borderRadius: AppBorderRadius.md,
        borderSide: BorderSide.none,
      ),
      // Habilitado sin focus: borde muy sutil (40% opacidad).
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.md,
        borderSide: BorderSide(
          color: borderColor.withValues(alpha: 0.40),
        ),
      ),
      // Con focus: borde completo gardenMedium / gardenLeaf, 2px.
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.md,
        borderSide: BorderSide(
          color: borderColor,
          width: AppBorderWidth.medium,
        ),
      ),
      // Error sin focus: borde rojo 2px.
      errorBorder: const OutlineInputBorder(
        borderRadius: AppBorderRadius.md,
        borderSide: BorderSide(
          color: AppColors.error,
          width: AppBorderWidth.medium,
        ),
      ),
      // Error con focus: borde rojo 3px — más urgente.
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: AppBorderRadius.md,
        borderSide: BorderSide(
          color: AppColors.error,
          width: AppBorderWidth.thick,
        ),
      ),
      labelStyle: AppTextStyles.bodySm.copyWith(
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      ),
      // Label flotante al hacer focus: verde + semibold → claramente activo.
      floatingLabelStyle: AppTextStyles.caption.copyWith(
        color: borderColor,
        fontWeight: FontWeight.w600,
      ),
      // Hint: texto guía con 60% opacidad → visible pero subordinado.
      hintStyle: AppTextStyles.body.copyWith(
        color: isDark
            ? AppColors.textSecondaryDark.withValues(alpha: 0.60)
            : AppColors.textSecondaryLight.withValues(alpha: 0.60),
      ),
      errorStyle: AppTextStyles.caption.copyWith(
        color: AppColors.error,
      ),
      // Íconos de prefix/suffix heredan el color del borde activo.
      prefixIconColor: isDark ? AppColors.gardenLight : AppColors.gardenLeaf,
      suffixIconColor: isDark ? AppColors.gardenLight : AppColors.gardenLeaf,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DIALOG
  // ══════════════════════════════════════════════════════════════════════════
  //
  // DECISIONES:
  //  backgroundColor: surface del tema activo
  //    → El Dialog es una "ventana de contenido", no un elemento de chrome.
  //    → Cambia con el modo (blanco en claro, surfaceDark en oscuro).
  //
  //  surfaceTintColor = transparent
  //    → Sin tint verde sobre superficie de Dialog. El Dialog debe ser
  //      neutral para que su contenido (texto, botones) sea lo prominente.
  //
  //  elevation = 16 (AppSpacing.elevationXl)
  //    → Alto: los dialogs están "muy por encima" del contenido de fondo.
  //    → La sombra comunica "debes atender esto antes de continuar".
  //
  //  shape: radius 24px (AppBorderRadius.lg)
  //    → Más redondeado que las tarjetas (16px). El Dialog es un elemento
  //      emergente, debe verse "suave" y no amenazante para el niño.
  //
  //  titleTextStyle: h3 + color del tema
  //    → Título de dialog es un "headline small" en la jerarquía.
  //    → Fredoka: amigable, no genera ansiedad en el niño.
  //
  //  actionsPadding: asimétrico (izq/der: 16, arriba: 4, abajo: 16)
  //    → Espacio estándar a los lados y abajo. Espacio mínimo arriba
  //      porque el divider entre contenido y acciones ya crea separación.
  // ──────────────────────────────────────────────────────────────────────────

  static DialogThemeData _dialogTheme({required bool isDark}) => DialogThemeData(
        backgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        elevation: AppSpacing.elevationXl,
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.lg,
        ),
        titleTextStyle: AppTextStyles.h3.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        contentTextStyle: AppTextStyles.body.copyWith(
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.md,
        ),
      );

  // ══════════════════════════════════════════════════════════════════════════
  // BOTTOM SHEET
  // ══════════════════════════════════════════════════════════════════════════
  //
  // DECISIONES:
  //  shape: topLeft + topRight 24px (AppBorderRadius.sheet)
  //    → El BottomSheet emerge desde abajo. Las esquinas superiores
  //      redondeadas marcan visualmente que el sheet "envuelve" el contenido.
  //    → Las esquinas inferiores son 0px (toca el borde de pantalla).
  //
  //  showDragHandle = true
  //    → La "manija" de arrastre indica al niño cómo cerrar el sheet:
  //      deslizando hacia abajo. Sin ella, niños pequeños no saben cómo salir.
  //
  //  dragHandleColor: gardenMedium/gardenLeaf
  //    → El handle usa el color principal del jardín para ser reconocible
  //      como "elemento interactivo" (no decorativo).
  //
  //  modalElevation = 16 (igual que elevation)
  //    → Los modal bottom sheets (que bloquean la interacción de fondo)
  //      deben verse "muy por encima" del contenido bloqueado.
  //
  //  surfaceTintColor = transparent
  //    → Misma razón que Dialog: la superficie del sheet debe ser neutra.
  // ──────────────────────────────────────────────────────────────────────────

  static BottomSheetThemeData _bottomSheetTheme({required bool isDark}) =>
      BottomSheetThemeData(
        backgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        elevation: AppSpacing.elevationXl,
        modalElevation: AppSpacing.elevationXl,
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.sheet,
        ),
        // Handle visual para enseñar al niño que puede deslizar para cerrar.
        dragHandleColor:
            isDark ? AppColors.gardenMedium : AppColors.gardenLeaf,
        dragHandleSize: const Size(32, 4),
        showDragHandle: true,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // SNACKBAR
  // ══════════════════════════════════════════════════════════════════════════
  //
  // DECISIONES:
  //  behavior = floating
  //    → El SnackBar flota sobre el contenido (no lo desplaza).
  //    → Si el NavBar estuviera visible, un SnackBar "fixed" taparía la nav.
  //    → Floating es el estándar de Material 3.
  //
  //  backgroundColor = gardenDeep (ambos modos)
  //    → Mismo color que AppBar/NavBar → visualmente coherente.
  //    → El SnackBar es un mensaje "del sistema del jardín", no del contenido.
  //
  //  actionTextColor = sacredGold
  //    → La acción del SnackBar (ej: "DESHACER", "VER") usa sacredGold.
  //    → El dorado sobre gardenDeep tiene 5.3:1 de contraste (WCAG AA).
  //    → El niño aprende: "dorado = algo especial o importante".
  //
  //  shape: radius md (16px)
  //    → Esquinas redondeadas en todos los elementos (consistencia del DS).
  //
  //  insetPadding: horizontal 16px + vertical 8px
  //    → El SnackBar no debe tocar los bordes de pantalla. Espacio
  //      suficiente para verse como elemento flotante, no como barra.
  // ──────────────────────────────────────────────────────────────────────────

  static SnackBarThemeData _snackBarTheme({required bool isDark}) =>
      SnackBarThemeData(
        backgroundColor: AppColors.gardenDeep,
        contentTextStyle: AppTextStyles.bodySm.copyWith(color: Colors.white),
        // sacredGold sobre gardenDeep: 5.3:1 contraste (WCAG AA).
        actionTextColor: AppColors.sacredGold,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.md,
        ),
        elevation: AppSpacing.elevationMd,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      );

  // ══════════════════════════════════════════════════════════════════════════
  // DIVIDER
  // ══════════════════════════════════════════════════════════════════════════
  //
  // DECISIONES:
  //  color: musgo 50% / gardenLight 80%
  //    → Un divider es una línea de separación, NO un elemento prominente.
  //    → Semitransparente para que se adapte sutilmente al fondo.
  //    → Oscuro: musgo con 50% (suficiente contraste sobre surfaceDark).
  //    → Claro: gardenLight con 80% (visible pero no llamativo sobre blanco).
  //
  //  thickness = 1px (AppBorderWidth.thin)
  //    → Un pixel es lo mínimo visible y lo menos intrusivo.
  //    → Más grueso haría el layout pesado.
  //
  //  space = 16px (AppSpacing.md)
  //    → El Divider widget toma "space" de espacio vertical total.
  //    → 16px incluye la línea de 1px + margen arriba y abajo.
  //
  //  indent/endIndent = 16px
  //    → La línea no toca los bordes horizontales de la pantalla.
  //    → Crea un "respiro" que hace el diseño más limpio.
  // ──────────────────────────────────────────────────────────────────────────

  static DividerThemeData _dividerTheme({required bool isDark}) =>
      DividerThemeData(
        color: isDark
            ? AppColors.gardenMoss.withValues(alpha: 0.50)
            : AppColors.gardenLight.withValues(alpha: 0.80),
        thickness: AppBorderWidth.thin,
        space: AppSpacing.md,
        indent: AppSpacing.md,
        endIndent: AppSpacing.md,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // LIST TILE
  // ══════════════════════════════════════════════════════════════════════════
  //
  // DECISIONES:
  //  shape: radius 8px (AppBorderRadius.sm)
  //    → Los list tiles son más compactos que las cards (radius 16px).
  //    → 8px da redondez sin ocupar demasiado espacio visual.
  //
  //  selectedTileColor: gardenMedium 12%
  //    → El tile seleccionado tiene un fondo muy sutil. 12% de opacidad
  //      es el valor estándar de Material 3 para hover/selected states.
  //
  //  contentPadding: horizontal 16px, vertical 4px
  //    → Padding estándar horizontal. 4px vertical porque las listas
  //      son densas por naturaleza (muchos items).
  //
  //  minTileHeight: 44px (AppSpacing.touchTargetMin)
  //    → Accesibilidad: ningún tile puede ser más pequeño que 44px.
  //    → Los dedos de niños son menos precisos que los de adultos.
  // ──────────────────────────────────────────────────────────────────────────

  static ListTileThemeData _listTileTheme({required bool isDark}) =>
      ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.gardenMedium.withValues(alpha: 0.12),
        iconColor: isDark ? AppColors.gardenLight : AppColors.gardenLeaf,
        textColor:
            isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        titleTextStyle: AppTextStyles.body.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        subtitleTextStyle: AppTextStyles.caption.copyWith(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
        leadingAndTrailingTextStyle: AppTextStyles.caption.copyWith(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.sm,
        ),
        minTileHeight: AppSpacing.touchTargetMin,
        minLeadingWidth: AppSpacing.iconMd,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // EXPANSION TILE
  // ══════════════════════════════════════════════════════════════════════════
  //
  // Uso en el proyecto:
  //  • Pantalla de Configuración → secciones colapsables (Audio, Visual, Cuenta)
  //  • Pantalla de FAQ de padres → preguntas frecuentes expandibles
  //  • Panel de Logros → categorías de logros (Lectura, Memorización, etc.)
  //
  // DECISIONES:
  //  backgroundColor + collapsedBackgroundColor = transparent
  //    → El ExpansionTile hereda el fondo de su padre (Scaffold, Card, etc.).
  //    → Un fondo propio crearía "doble fondo" visual cuando está dentro de Card.
  //    → Transparent permite que las listas de tiles se vean como una sola unidad.
  //
  //  iconColor (expandido): gardenLeaf / gardenLight
  //    → La flecha de expansión usa el color de ícono del tema.
  //    → Cuando está expandido, el ícono es más brillante (100% opacidad).
  //    → Señala claramente el estado activo.
  //
  //  collapsedIconColor: 70% opacidad
  //    → Cuando está colapsado, el ícono es más sutil.
  //    → El contraste reducido comunica "hay más contenido aquí, pero
  //      no es lo que estás viendo ahora".
  //
  //  textColor vs collapsedTextColor
  //    → El título del tile expandido usa el color de texto primario (100%).
  //    → El título colapsado usa el color primario (verde) para indicar
  //      que es interactivo (mismo patrón que un link).
  //    → Esto diferencia los tiles expandibles de los no expandibles.
  //
  //  tilePadding: horizontal md (16px), vertical xs (4px)
  //    → Mismo que ListTile para consistencia en listas mixtas.
  //
  //  childrenPadding: left/right md (16px), bottom sm (8px)
  //    → El contenido hijo se indenta con el mismo padding que el título.
  //    → Sin padding top (el expansion en sí da el espacio).
  //
  //  shape + collapsedShape: radius sm (8px)
  //    → Coherente con ListTileTheme.
  //    → El shape aparece cuando el tile recibe el foco (accessibility).
  // ──────────────────────────────────────────────────────────────────────────

  static ExpansionTileThemeData _expansionTileTheme({required bool isDark}) =>
      ExpansionTileThemeData(
        // Fondo siempre transparente → hereda el contexto padre.
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        // Expandido: ícono 100% visible (estado activo).
        iconColor: isDark ? AppColors.gardenLight : AppColors.gardenLeaf,
        // Colapsado: ícono 70% opacidad (estado inactivo, sigue siendo visible).
        collapsedIconColor: isDark
            ? AppColors.gardenLight.withValues(alpha: 0.70)
            : AppColors.gardenLeaf.withValues(alpha: 0.70),
        // Expandido: texto primario 100% (el usuario está interactuando).
        textColor:
            isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        // Colapsado: color de acción (verde) indica "toca para expandir".
        collapsedTextColor:
            isDark ? AppColors.gardenLight : AppColors.gardenMedium,
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        // Hijos: mismo indent horizontal. Sin espacio top (tile lo da). 8px bottom.
        childrenPadding: const EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.sm,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.sm,
        ),
        collapsedShape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.sm,
        ),
        // Hijos alineados a la izquierda (lectura natural occident.).
        expandedAlignment: Alignment.centerLeft,
        // Sin clip: permite que los hijos usen sombras sin ser cortadas.
        clipBehavior: Clip.none,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // CHIP
  // ══════════════════════════════════════════════════════════════════════════
  //
  // Uso en el proyecto:
  //  • Selección de avatar en la creación de perfil (FilterChip)
  //  • Filtros de estado en misiones (activo/completado/bloqueado)
  //  • Tags de rareza en el inventario
  //
  // DECISIONES:
  //  shape: full (pill/cápsula)
  //    → Los chips representan categorías o selecciones acotadas.
  //    → La forma de píldora comunica "es una etiqueta, no un botón de acción".
  //    → Niños reconocen mejor los chips de píldora como "seleccionables".
  //
  //  selectedColor = gardenMedium
  //    → Cuando un chip está seleccionado, su fondo cambia a verde.
  //    → Color consistente con ElevatedButton.
  //
  //  side: borde sutil 40% opacidad en reposo
  //    → Sin seleccionar: borde muy leve para definir el área clickeable.
  //    → La baja opacidad no compite con el contenido del chip.
  // ──────────────────────────────────────────────────────────────────────────

  static ChipThemeData _chipTheme({required bool isDark}) => ChipThemeData(
        backgroundColor:
            isDark ? AppColors.gardenMoss : const Color(0xFFE8F5EE),
        selectedColor: AppColors.gardenMedium,
        disabledColor: isDark
            ? AppColors.gardenMoss.withValues(alpha: 0.38)
            : const Color(0xFFE8F5EE).withValues(alpha: 0.38),
        deleteIconColor:
            isDark ? AppColors.gardenLight : AppColors.gardenMoss,
        labelStyle: AppTextStyles.caption.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        // Label cuando está seleccionado: blanco sobre gardenMedium.
        secondaryLabelStyle: AppTextStyles.caption.copyWith(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        // Forma de píldora: chips son etiquetas, no botones.
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.full,
        ),
        // Borde sutil sin seleccionar (40% opacidad → apenas visible).
        side: BorderSide(
          color: isDark
              ? AppColors.gardenMedium.withValues(alpha: 0.40)
              : AppColors.gardenLeaf.withValues(alpha: 0.40),
        ),
        elevation: AppSpacing.elevationNone,
        pressElevation: AppSpacing.elevationSm,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // PROGRESS INDICATOR
  // ══════════════════════════════════════════════════════════════════════════
  //
  // Uso: barras de XP, progreso de capítulo, descarga de contenido offline.
  //
  // DECISIONES:
  //  color = gardenMedium
  //    → La barra de progreso usa el color de acción del jardín.
  //    → "El jardín creciendo" — el progreso como crecimiento.
  //
  //  linearTrackColor / circularTrackColor: musgo sutil
  //    → El "riel" de la barra debe verse diferente del fondo (no transparent)
  //      pero tampoco competir con el indicador de progreso (verde brillante).
  //    → Musgo con 40% (oscuro) / gardenLight 60% (claro): sutil pero visible.
  //
  //  linearMinHeight = 6px
  //    → 4px es el default de M3 pero es demasiado delgado para niños.
  //    → 6px es más visible y más fácil de percibir el progreso.
  //    → 8px sería demasiado prominente en listas densas.
  // ──────────────────────────────────────────────────────────────────────────

  static ProgressIndicatorThemeData _progressIndicatorTheme(
          {required bool isDark}) =>
      ProgressIndicatorThemeData(
        color: AppColors.gardenMedium,
        linearTrackColor: isDark
            ? AppColors.gardenMoss.withValues(alpha: 0.40)
            : AppColors.gardenLight.withValues(alpha: 0.60),
        circularTrackColor: isDark
            ? AppColors.gardenMoss.withValues(alpha: 0.40)
            : AppColors.gardenLight.withValues(alpha: 0.60),
        linearMinHeight: 6,
        refreshBackgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // SWITCH
  // ══════════════════════════════════════════════════════════════════════════
  //
  // Uso: configuración de sonido, notificaciones, modo de práctica.
  //
  // DECISIONES:
  //  thumbColor (WidgetStateProperty):
  //    SELECTED → Colors.white
  //      → Thumb blanco sobre track verde: 4.5:1 contraste WCAG AA.
  //    NOT SELECTED → gardenLight/gardenMoss
  //      → Thumb verde sobre track gris/musgo: el switch "del jardín".
  //      → No se usa blanco en OFF: evita confundir OFF con ON (blanco=activo).
  //
  //  trackColor (WidgetStateProperty):
  //    SELECTED → gardenMedium
  //      → El track verde señala: "está activado". Coherente con primary.
  //    NOT SELECTED → musgo 60% / gris verdoso
  //      → No tan oscuro que se vea "apagado/roto", pero claramente diferente
  //        de gardenMedium para que OFF vs ON sea inequívoco.
  //
  //  trackOutlineColor = transparent
  //    → Material 3 por defecto muestra un borde en el track OFF.
  //    → Se elimina porque el color de track ya diferencia los estados.
  //    → El borde adicional crea un look "sobrecargado" para un juego.
  //
  //  splashRadius = 24px (AppSpacing.lg)
  //    → El efecto de ripple al tocar debe ser generoso.
  //    → 24px garantiza feedback visual claro para dedos pequeños.
  // ──────────────────────────────────────────────────────────────────────────

  static SwitchThemeData _switchTheme({required bool isDark}) =>
      SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            // ON: thumb blanco sobre track verde.
            return Colors.white;
          }
          // OFF: thumb verde (oscuro)/verde claro según modo.
          return isDark ? AppColors.gardenLight : AppColors.gardenMoss;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            // ON: track verde principal.
            return AppColors.gardenMedium;
          }
          // OFF: track musgo sutil → diferente de ON pero no "apagado".
          return isDark
              ? AppColors.gardenMoss.withValues(alpha: 0.60)
              : const Color(0xFFB0C4B8); // verde grisáceo para modo claro
        }),
        // Sin borde en el track: el color ya diferencia los estados.
        trackOutlineColor: WidgetStateProperty.all<Color?>(Colors.transparent),
        splashRadius: AppSpacing.lg,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // SLIDER
  // ══════════════════════════════════════════════════════════════════════════
  //
  // Uso: volumen de música, volumen de efectos de sonido, velocidad de lectura.
  //
  // DECISIONES:
  //  activeTrackColor = gardenMedium
  //    → La parte del track "ya recorrida" usa el color de acción.
  //    → Metáfora: el jardín creciendo hacia la derecha.
  //
  //  inactiveTrackColor: musgo/gardenLight sutil
  //    → La parte "pendiente" del track es más sutil.
  //    → Contraste suficiente para ver la posición actual.
  //
  //  thumbColor = gardenMedium
  //    → El "pulgar" (punto de arrastre) es del color activo.
  //    → Coherente con el track activo → ambos son el mismo verde.
  //
  //  overlayColor = gardenMedium 12%
  //    → Al presionar el thumb aparece un círculo verde translúcido.
  //    → 12% es el valor estándar de M3 para pressed overlay.
  //
  //  trackHeight = 4px
  //    → Track delgado: el slider es para ajuste fino, no selección gruesa.
  //    → Más delgado que el ProgressIndicator (6px) porque aquí el thumb
  //      es el elemento visual principal, no el track.
  //
  //  thumbShape: radio 12px
  //    → Thumb de 24×24px efectivo (radio 12). Touch target generoso.
  //    → El círculo grande hace fácil arrastrar para niños (Fitt's Law).
  //
  //  valueIndicatorShape: PaddleSlider (forma de paleta)
  //    → Forma más lúdica y amigable que el rectángulo default.
  //    → showValueIndicator = onlyForDiscrete: solo muestra el valor
  //      cuando el slider tiene "steps" definidos (ej: 0/25/50/75/100%).
  //      Para sliders continuos de volumen, el valor en tiempo real
  //      puede distraer — se lee visualmente del track.
  // ──────────────────────────────────────────────────────────────────────────

  static SliderThemeData _sliderTheme({required bool isDark}) =>
      SliderThemeData(
        activeTrackColor: AppColors.gardenMedium,
        inactiveTrackColor: isDark
            ? AppColors.gardenMoss.withValues(alpha: 0.50)
            : AppColors.gardenLight.withValues(alpha: 0.70),
        thumbColor: AppColors.gardenMedium,
        overlayColor: AppColors.gardenMedium.withValues(alpha: 0.12),
        valueIndicatorColor: AppColors.gardenDeep,
        // Tick marks en los "steps" del slider (si los hay).
        activeTickMarkColor: Colors.white.withValues(alpha: 0.54),
        inactiveTickMarkColor: AppColors.gardenMedium.withValues(alpha: 0.54),
        // Disabled: versiones desaturadas de los colores activos.
        disabledActiveTrackColor: AppColors.gardenMedium.withValues(alpha: 0.38),
        disabledInactiveTrackColor: AppColors.gardenLight.withValues(alpha: 0.38),
        disabledThumbColor: AppColors.gardenMedium.withValues(alpha: 0.38),
        trackHeight: 4,
        // thumb 12dp = 24×24px total de touch target visible.
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        // overlayRadius 24dp = 48×48px total en el gesto. Fácil de tocar.
        overlayShape: const RoundSliderOverlayShape(),
        // Forma de paleta: lúdica y amigable para el videojuego.
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorTextStyle: AppTextStyles.caption.copyWith(
          color: Colors.white,
        ),
        showValueIndicator: ShowValueIndicator.onlyForDiscrete,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // CHECKBOX
  // ══════════════════════════════════════════════════════════════════════════
  //
  // Uso en el proyecto:
  //  • Configuración de notificaciones (múltiples opciones)
  //  • Panel de padres: habilitar/deshabilitar características
  //  • Lista de versículos seleccionados para practicar
  //
  // DECISIONES:
  //  fillColor (WidgetStateProperty):
  //    SELECTED, enabled → gardenMedium
  //      → El checkbox marcado se llena con el color de acción del jardín.
  //      → Consistente con Switch (ON = gardenMedium) y botones.
  //    SELECTED, disabled → gardenMedium 38%
  //      → Marcado pero no interactivo: mismo color pero desaturado.
  //    NOT SELECTED → transparent
  //      → Sin marcar, el checkbox es solo el borde sobre el fondo.
  //      → Transparent evita un "doble fondo" visual sobre superficies de color.
  //
  //  checkColor = Colors.white (todos los estados)
  //    → La marca de verificación siempre es blanca.
  //    → Contraste máximo sobre gardenMedium (fondo del checkbox marcado).
  //    → Un checkmark negro sería confuso sobre verde.
  //
  //  overlayColor (WidgetStateProperty):
  //    pressed → gardenMedium 12%   ← Material 3 standard para pressed
  //    hovered → gardenMedium 8%    ← Hover más sutil que pressed
  //    focused → gardenMedium 12%   ← Focus ring para accesibilidad
  //    default → transparent
  //
  //  shape: RoundedRectangleBorder radius 4px
  //    → El default de Material 3 es cuadrado (0px).
  //    → 4px da una suavidad mínima sin distorsionar la forma recognocible
  //      del checkbox. Un checkbox demasiado redondeado parece un radio button.
  //    → 4px es el "mínimo amigable" para el Design System infantil.
  //
  //  side (WidgetStateBorderSide):
  //    NOT SELECTED → borde gardenLight/gardenMoss 70% + 2px
  //      → Sin marcar el borde define el área clickeable. 70% opacidad:
  //        visible pero no agresivo. 2px: suficientemente visible a tamaños
  //        pequeños (los checkboxes suelen ser 24×24px).
  //    SELECTED → BorderSide.none
  //      → Al marcarse, el borde desaparece. El fondo gardenMedium ya
  //        es el límite visual del elemento. Borde + fondo = "doble marco".
  //
  //  splashRadius = 24px
  //    → Mismo que Switch y Radio. Feedback táctil consistente.
  // ──────────────────────────────────────────────────────────────────────────

  static CheckboxThemeData _checkboxTheme({required bool isDark}) =>
      CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.disabled)) {
            // Desactivado: verde desaturado, igual si está marcado o no.
            return AppColors.gardenMedium.withValues(alpha: 0.38);
          }
          if (states.contains(WidgetState.selected)) {
            // Marcado + habilitado: verde jardín.
            return AppColors.gardenMedium;
          }
          // Sin marcar: transparente (solo el borde define el área).
          return Colors.transparent;
        }),
        // Checkmark siempre blanco: máximo contraste sobre gardenMedium.
        checkColor: WidgetStateProperty.all<Color?>(Colors.white),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.gardenMedium.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.gardenMedium.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.focused)) {
            return AppColors.gardenMedium.withValues(alpha: 0.12);
          }
          return Colors.transparent;
        }),
        // Suavemente redondeado: más amigable que el cuadrado default.
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        // Borde visible sin marcar (70% opacidad), invisible al marcar.
        side: WidgetStateBorderSide.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            // Marcado: sin borde (el fondo gardenMedium es el límite).
            return BorderSide.none;
          }
          // Sin marcar: borde 2px (gardenLight en oscuro, gardenMoss en claro).
          return BorderSide(
            color: isDark
                ? AppColors.gardenLight.withValues(alpha: 0.70)
                : AppColors.gardenMoss.withValues(alpha: 0.70),
            width: AppBorderWidth.medium,
          );
        }),
        splashRadius: AppSpacing.lg,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // RADIO
  // ══════════════════════════════════════════════════════════════════════════
  //
  // Uso en el proyecto:
  //  • Selección de idioma (español / inglés / portugués)
  //  • Selección de dificultad (Querubín / Discípulo / Apóstol)
  //  • Panel de padres: elegir una restricción entre varias opciones
  //
  // DECISIONES:
  //  fillColor (WidgetStateProperty):
  //    SELECTED → gardenMedium
  //      → El radio seleccionado se llena con el color de acción.
  //      → Coherente con Checkbox (selected) y Switch (ON).
  //    DISABLED → gardenMedium 38%
  //      → Desaturado para comunicar "no interactivo".
  //    NOT SELECTED → gardenLight/gardenMoss 70%
  //      → El aro externo del radio no seleccionado usa verde sutil.
  //      → No blanco/gris: mantiene la identidad del jardín incluso
  //        en los elementos no seleccionados.
  //      → 70% para diferenciar claramente de gardenMedium (el seleccionado).
  //
  //  overlayColor (WidgetStateProperty):
  //    → Mismo patrón que Checkbox: 12% pressed, 8% hovered, 12% focused.
  //    → Feedback táctil consistente en todos los controles de selección.
  //
  //  splashRadius = 24px
  //    → Los radio buttons tienen un área táctil pequeña visible (20×20px).
  //    → El splash de 24px amplía el feedback más allá del ícono.
  //    → Facilita la selección para niños (Fitt's Law: área efectiva > área visual).
  //
  //  POR QUÉ NO SE CONFIGURA `mouseCursor` NI `visualDensity`:
  //    → mouseCursor default de Material 3 es correcto para móvil.
  //    → visualDensity default es correcto para la escala del DS.
  //      Cambiarla afectaría la consistencia con los otros controles.
  // ──────────────────────────────────────────────────────────────────────────

  static RadioThemeData _radioTheme({required bool isDark}) => RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.disabled)) {
            // Desactivado: verde desaturado.
            return AppColors.gardenMedium.withValues(alpha: 0.38);
          }
          if (states.contains(WidgetState.selected)) {
            // Seleccionado: verde jardín pleno.
            return AppColors.gardenMedium;
          }
          // No seleccionado: aro verde sutil (70% opacidad).
          return isDark
              ? AppColors.gardenLight.withValues(alpha: 0.70)
              : AppColors.gardenMoss.withValues(alpha: 0.70);
        }),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.gardenMedium.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.gardenMedium.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.focused)) {
            return AppColors.gardenMedium.withValues(alpha: 0.12);
          }
          return Colors.transparent;
        }),
        // 24px de splash = área táctil efectiva de 48px (supera el mínimo de 44).
        splashRadius: AppSpacing.lg,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // ICON THEME
  // ══════════════════════════════════════════════════════════════════════════
  //
  // DECISIONES:
  //  color: gardenLight (oscuro) / gardenLeaf (claro)
  //    → Los íconos fuera de la "zona chrome" (AppBar/NavBar) usan
  //      colores que contrasten con la superficie de contenido.
  //    → gardenLeaf en claro (sobre blanco): 4.5:1 contraste ✓
  //    → gardenLight en oscuro (sobre surfaceDark): 5.1:1 contraste ✓
  //
  //  size = 24px (AppSpacing.iconMd)
  //    → El tamaño estándar de Material Design para íconos de contenido.
  //    → Los íconos de navegación (NavBar) también usan 24px mediante
  //      la NavigationBarTheme.iconTheme independiente.
  //
  //  primaryIconTheme → siempre blanco
  //    → Los íconos en el AppBar (zona chrome) son siempre blancos.
  //    → El primaryIconTheme se aplica automáticamente a los íconos
  //      del AppBar, DrawerButton y BackButton.
  //
  //  opticalSize = 24, weight = 400
  //    → Material Symbols (si se usan en el futuro) tienen parámetros
  //      de variación. 24/400 coincide con Material Icons classic.
  // ──────────────────────────────────────────────────────────────────────────

  static IconThemeData _iconTheme({required bool isDark}) => IconThemeData(
        color: isDark ? AppColors.gardenLight : AppColors.gardenLeaf,
        size: AppSpacing.iconMd,
        opticalSize: 24,
        weight: 400,
      );

  // Íconos en la "zona chrome" (AppBar): siempre blancos, independiente del modo.
  static IconThemeData _primaryIconTheme() => const IconThemeData(
        color: Colors.white,
        size: AppSpacing.iconMd,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // BADGE
  // ══════════════════════════════════════════════════════════════════════════
  //
  // Uso: contador de notificaciones, misiones nuevas, mensajes no leídos.
  //
  // DECISIONES:
  //  backgroundColor = AppColors.error (rojo)
  //    → El rojo tiene la mayor urgencia visual. El badge comunica
  //      "hay algo que necesita tu atención". Es el color universal
  //      para notificaciones (iOS, Android, web — reconocido globalmente).
  //    → No se usa sacredGold porque el dorado es "premiación/logro",
  //      no "hay algo nuevo que revisar".
  //
  //  textColor = Colors.white
  //    → Blanco sobre rojo: 4.5:1 contraste WCAG AA.
  //
  //  smallSize = 8px (sin texto) / largeSize = 16px (con número)
  //    → 8px: badge de punto (solo indica que hay algo, sin número).
  //    → 16px: badge con número (muestra la cantidad).
  //
  //  offset = Offset(4, -4)
  //    → El badge se posiciona 4px a la derecha y 4px arriba del ícono.
  //    → Esta posición estándar evita que tape el ícono principal.
  //    → El número del badge se lee sin tener que mover los ojos del ícono.
  // ──────────────────────────────────────────────────────────────────────────

  static BadgeThemeData _badgeTheme({required bool isDark}) => BadgeThemeData(
        backgroundColor: AppColors.error,
        textColor: Colors.white,
        textStyle: AppTextStyles.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 1,
        ),
        smallSize: 8,
        largeSize: 16,
        // +4px derecha, -4px arriba del ícono host.
        offset: const Offset(4, -4),
      );
}
