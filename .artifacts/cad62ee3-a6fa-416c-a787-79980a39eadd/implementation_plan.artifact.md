# Refactorización del Sistema de Diseño y Corrección de ColorScheme

Este plan detalla la corrección de la inversión de colores en el `ColorScheme` de la aplicación y la actualización del widget `CustomButton` para asegurar el cumplimiento de las guías de Material 3 y mejorar el contraste.

## User Review Required

> [!IMPORTANT]
> Se han definido colores específicos para el Modo Claro y Oscuro. Por favor, verifique que los valores hexadecimales coincidan con la identidad visual deseada.
> Se eliminará el TODO en `AppThemeData` para implementar las variantes solicitadas.

## Proposed Changes

### Core Theme

#### [MODIFY] [app_theme.dart](file:///C:/Users/Migue/UAM/IU/cuaji_report/lib/core/theme/app_theme.dart)
- Actualizar `_lightTheme()` con el mapeo exacto proporcionado.
- Implementar `_darkTheme()` con el mapeo exacto proporcionado.
- Actualizar `getTheme(AppTheme theme)` para devolver el tema correspondiente (mapeando `dark`, `highContrast` y `neon` al nuevo tema oscuro por ahora, o según se requiera).

### Widgets

#### [MODIFY] [custom_button.dart](file:///C:/Users/Migue/UAM/IU/cuaji_report/lib/widgets/custom_button.dart)
- Corregir la asignación de `backgroundColor` y `foregroundColor` en las variantes `primary` y `secondary`.
- Asegurar que `danger` y `outline` sigan la lógica solicitada.
- Eliminar la variante `dangersecondary` si no es necesaria o unificarla con `danger` según las instrucciones (el usuario pidió `danger` específicamente).

## Verification Plan

### Manual Verification
- Inspección visual del código para asegurar que `primary` -> `onPrimary`, etc., no estén invertidos.
- Ejecutar la aplicación (si es posible en el entorno del usuario) y alternar entre modo claro y oscuro.
- Verificar que los botones `CustomButton` en sus diferentes variantes tengan el contraste correcto (texto legible sobre fondo).

### Automated Tests
- Se podrían agregar pruebas unitarias simples que verifiquen los valores de `ThemeData.colorScheme` para cada modo si el proyecto tiene infraestructura de tests.
