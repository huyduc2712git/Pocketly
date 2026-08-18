# Project Audit & Architecture Review

## 1. Executive Summary
- **Project Name**: Pocketly (Finly)
- **Architecture**: Feature-First + Clean Architecture (`domain`, `data`, `presentation`)
- **State Management**: Riverpod (`StateNotifierProvider`, `StreamProvider`, `Provider`)
- **Database**: Drift SQLite (10 tables with foreign keys and sync queue)
- **Navigation**: GoRouter (`StatefulShellRoute` with 5 persistent tabs)
- **Current Health**: 41/41 passing unit/integration tests, 0 analysis errors.

---

## 2. Findings & Optimization Opportunities

### 2.1 Import Path Fragility (High Priority)
- **Finding**: Many files across `features/` and `shared/` use deep relative imports (e.g. `../../../../core/utils/currency_formatter.dart`).
- **Risk**: Refactoring folder hierarchy easily breaks relative links.
- **Action**: Standardize all imports to package imports (`package:pocketly/...` / `package:finly/...`).

### 2.2 Localization Centralization (High Priority)
- **Finding**: User-facing strings in widgets, dialogs, snackbars, and insight generators are hard-coded in Vietnamese.
- **Risk**: Difficult to maintain, translate to English, or update wording consistently.
- **Action**: Implement Flutter official ARB localization (`lib/l10n/app_vi.arb` and `lib/l10n/app_en.arb`) with `context.l10n` extension.

### 2.3 Semantic Icon System (Medium Priority)
- **Finding**: Icons are currently mapped via Material Icons in `IconHelper`, but need a single coherent icon dictionary with semantic constants (e.g. `AppIcons.dashboard`, `AppIcons.income`, `AppIcons.expense`, `AppIcons.transfer`, `AppIcons.warning`, `AppIcons.subscription`).
- **Action**: Centralize all icons into an `AppIcons` design token class with standardized stroke/sizing rules and semantic accessibility labels.

### 2.4 Design System & Accessibility (Medium Priority)
- **Finding**: Touch targets and semantic labels need verification across all action buttons and icon buttons (ensuring minimum 48x48dp touch targets and WCAG AA contrast).
- **Action**: Update `AppCard`, `AppButton`, `AppBottomSheet`, and all icon buttons with proper `semanticsLabel` and minimum touch padding.

### 2.5 Security & Sensitive Logging (Medium Priority)
- **Finding**: Financial data, tokens, and payloads should never be exposed in unredacted console logs.
- **Action**: Audit `LoggingInterceptor` and `AppLogger` to enforce automatic redaction of monetary values, authorization headers, and sensitive notes.
