# Pocketly Localization Architecture

## 1. Overview
Pocketly uses Flutter's official ARB (Application Resource Bundle) localization system powered by `flutter_localizations` and `intl`.

## 2. Directory Structure
```
lib/
├── l10n/
│   ├── app_vi.arb          # Vietnamese default template
│   └── app_en.arb          # English translation
├── core/
│   └── extensions/
│       └── l10n_extension.dart  # context.l10n shorthand
l10n.yaml                   # Generator configuration
```

## 3. Naming Conventions & Key Patterns
- `common<Action>`: Reusable action buttons and general labels (`commonSave`, `commonCancel`, `commonDelete`, `commonLoading`).
- `<feature><Element>`: Feature-specific keys (`dashboardTotalBalance`, `transactionAddExpense`, `budgetMonthlyLimit`, `subscriptionDaysRemaining`).

## 4. Interpolation Examples
Dynamic numeric and string parameters are declared with typed ARB placeholders:
```json
"budgetForecastWarning": "Dự kiến cuối tháng bạn sẽ vượt ngân sách {amount}",
"@budgetForecastWarning": {
  "placeholders": {
    "amount": { "type": "String" }
  }
}
```

## 5. Usage in Flutter Widgets
```dart
import 'package:pocketly/core/extensions/l10n_extension.dart';

// Access localized strings in build method:
Text(context.l10n.dashboardTotalBalance)
```
