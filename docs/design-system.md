# Pocketly Design System Specification

Generated with **UI/UX Pro Max** for **Pocketly (Personal Finance Tracker / Fintech)**.

---

## 1. Brand Identity & Product Personality
- **Personality**: Trustworthy, Modern, Calm, Financially Responsible, Premium yet Minimal.
- **Visual Style**: Clean Obsidian Dark Fintech with subtle glowing accents and high-contrast legible typography.
- **Anti-patterns to Avoid**: Excessive neon noise, distracting large gradients, unreadable low-contrast gray text on dark backgrounds, emojis used as interface buttons.

---

## 2. Color Palette & Science

### 2.1 Dark Surface Hierarchy (Obsidian Theme)
| Token | Hex Value | Usage |
| :--- | :--- | :--- |
| `AppColors.darkBackground` | `#0B0F19` | Main screen background |
| `AppColors.darkCard` | `#111827` | Primary card container surface |
| `AppColors.darkCardSecondary`| `#1E293B` | Nested cards, dialogs, bottom sheets |
| `AppColors.darkBorder` | `#1F2937` | Card borders, dividers, outlines |
| `AppColors.darkBorderGlow` | `#374151` | Hover / Active card borders |

### 2.2 Semantic Financial Colors
| Token | Hex Value | Purpose |
| :--- | :--- | :--- |
| `AppColors.primary` | `#6366F1` | Brand Indigo - Primary buttons, active tabs |
| `AppColors.primaryLight` | `#818CF8` | Highlights, badges, active icons |
| `AppColors.income` | `#10B981` | Emerald Green - Inflows, positive savings, profits |
| `AppColors.expense` | `#EF4444` | Crimson Red - Outflows, over-budget indicators |
| `AppColors.transfer` | `#06B6D4` | Cyan / Sky Blue - Inter-wallet transfers |
| `AppColors.warning` | `#F59E0B` | Amber - Budget risks, renewal warnings |

---

## 3. Typography Scale (Outfit Google Font)

| Style Token | Size / Weight | Line Height | Usage |
| :--- | :--- | :--- | :--- |
| `AppTypography.displayLarge` | 32sp / Bold (700) | 40sp | Total Net Worth Display |
| `AppTypography.headlineMedium` | 24sp / SemiBold (600) | 32sp | Section Headers |
| `AppTypography.titleMedium` | 16sp / SemiBold (600) | 24sp | Card Titles, Modal Headers |
| `AppTypography.bodyMedium` | 14sp / Regular (400) | 20sp | Descriptions, Transaction Notes |
| `AppTypography.labelSmall` | 11sp / Medium (500) | 16sp | Badges, Timestamp, Tooltips |

---

## 4. Spacing, Radius & Elevation Tokens

### 4.1 Spacing (8pt Grid)
- `AppSpacing.xs` = 4.0 dp
- `AppSpacing.sm` = 8.0 dp
- `AppSpacing.md` = 16.0 dp
- `AppSpacing.lg` = 24.0 dp
- `AppSpacing.xl` = 32.0 dp
- `AppSpacing.huge` = 48.0 dp

### 4.2 Border Radius
- `AppRadius.sm` = 8.0 dp (Buttons, Badges, Chips)
- `AppRadius.md` = 16.0 dp (Cards, Quick action tiles)
- `AppRadius.lg` = 24.0 dp (Bottom sheets, Dialogs)
- `AppRadius.full` = 999.0 dp (Pills, FABs, Avatars)

---

## 5. Centralized Semantic Icon System (`AppIcons`)

| Semantic Identifier | Icon Symbol | Accessibility Label |
| :--- | :--- | :--- |
| `AppIcons.dashboard` | `Icons.grid_view_rounded` | "Tổng quan tài chính" |
| `AppIcons.transactions` | `Icons.receipt_long_rounded` | "Sổ thu chi" |
| `AppIcons.budget` | `Icons.pie_chart_outline_rounded`| "Quản lý ngân sách" |
| `AppIcons.analytics` | `Icons.bar_chart_rounded` | "Báo cáo phân tích" |
| `AppIcons.profile` | `Icons.person_outline_rounded` | "Cá nhân và cài đặt" |
| `AppIcons.income` | `Icons.arrow_downward_rounded` | "Khoản thu nhập" |
| `AppIcons.expense` | `Icons.arrow_upward_rounded` | "Khoản chi tiêu" |
| `AppIcons.transfer` | `Icons.swap_horiz_rounded` | "Chuyển tiền giữa các ví" |
| `AppIcons.subscription` | `Icons.subscriptions_outlined` | "Gói thuê bao định kỳ" |
| `AppIcons.wallet` | `Icons.account_balance_wallet_outlined` | "Ví tài khoản" |
| `AppIcons.warning` | `Icons.warning_amber_rounded` | "Cảnh báo tài chính" |
| `AppIcons.sync` | `Icons.sync_rounded` | "Đồng bộ dữ liệu" |

---

## 6. Accessibility & Touch Standards
- Minimum touch target for all interactive elements: **$48 \times 48 \text{ dp}$**.
- High-contrast text compliance: White on `#0B0F19` has a contrast ratio $> 15:1$ (exceeding WCAG AAA).
- Financial values clearly distinguish type through both prefix sign (`+` / `-`) and color.
