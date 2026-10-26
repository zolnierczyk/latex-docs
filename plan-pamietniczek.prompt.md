# Plan: Complete A5 Calendar/Journal with Habit Tracking and Integrated Summaries

Create a comprehensive yearly calendar/journal document with auto-generated daily pages (365), integrated weekly and monthly summaries, a split habit-tracker matrix (weeks 1–26 and 27–52), and minimalist black/white/gray design. Daily pages include freeform notes area plus mood/energy checkboxes.

## Steps

1. Set up main.tex with `scrbook` (A5, `BCOR=2cm`, `DIV=25`), `pgfcalendar` for date calculations, `tabularx` and `booktabs` for habit matrix styling, and minimal margins (8mm top/bottom/right, 10mm left binding).

2. Define `\SetYear{2026}` macro at document start for single-point year configuration; all date generation references this variable.

3. Create title page with year prominently displayed, "Pamiętniczek" title, and minimalist design (black/white/gray typography only).

4. Build full-year calendar overview page displaying all 12 months in grid layout using typography hierarchy (bold/regular font weights).

5. Add first habit-tracker matrix page (weeks 1–26): horizontal axis = week numbers, vertical axis = checkbox grid, activity names on left and right edges. Use ~6–8 activity rows for legibility on A5.

6. Loop through the year with `\pgfcalendar{cal}{2026-01-01}{2026-12-31}{}` to auto-generate content for each month:
   - Monthly plan page (month/year, date range, goal-setting area, notes section)
   - For each day: auto-generate daily page with date, day-of-week, mood/energy checkboxes (3–5 mood states), and large open notes area
   - After each Sunday (detect via `\pgfcalendarweekday`): auto-insert weekly summary page (week number, date range, achievements, lessons learned, reflection prompts)
   - After month's last day: auto-insert monthly summary page (month name, task completion stats, challenges, wins, monthly reflection)

7. Add second habit-tracker matrix page after December (weeks 27–52) with same layout as first matrix.

8. Create year summary page at document end (annual goals review, major achievements, lessons learned, year-long reflection prompts).

9. Design daily page template: date header (bold, 8pt), day-of-week label, mood/energy checkbox row (e.g., "Mood: ☐ 😞 ☐ 😐 ☐ 😊 ☐ 😄"; "Energy: ☐ Low ☐ Med ☐ High"), followed by full-page notes area with subtle gray baseline rules (4–5mm spacing) to guide handwriting without constraining it.

10. Use consistent 9pt font body text, 0.4pt gray rules throughout, and limit color palette to black text + gray rules + white background for minimalist clarity.

## Configuration Notes

- **Year:** Configurable via `\SetYear{2026}` macro at document start
- **Auto-generation:** All pages generated via `pgfcalendar` loops—no manual date entry
- **Leap year handling:** Automatic via pgfcalendar's Julian Day Number conversion
- **Page count:** ~450–460 pages total (1 title + 1 overview + 1 habit matrix weeks 1–26 + 12 monthly plans + ~365 daily + ~52 weekly summaries + 12 monthly summaries + 1 habit matrix weeks 27–52 + 1 year summary)

## Design Specifications

- **Format:** A5 (148×210mm) with 2cm binding correction (`BCOR=2cm`)
- **Margins:** 10mm left (binding), 8mm top/bottom/right
- **Font:** 9pt body text
- **Color palette:** Black text, light gray (0.7) rules, white background only
- **Lines:** 0.4pt gray rules for notes areas (4–5mm spacing)
- **No time grids:** Daily pages are freeform notes areas only

## Habit Tracker Matrix Specifications

- **Split into two pages:** Weeks 1–26 and weeks 27–52
- **Layout:** Horizontal axis = week numbers, vertical axis = checkboxes
- **Activity names:** On left and right edges
- **Activity rows:** ~6–8 per page for A5 legibility
- **Purpose:** Track completion of recurring habits/activities across the year

## Weekly & Monthly Summaries

- **Weekly summaries:** Generated after each Sunday (end of week)
- **Content:** Week number, date range, achievements, lessons learned, reflection prompts
- **Monthly summaries:** Generated after last day of each month
- **Content:** Month name, task completion stats, challenges, wins, monthly reflection

## Daily Page Content

- Date header and day-of-week label
- Mood/energy checkboxes (quick self-assessment)
- Large freeform notes area with subtle gray rules to guide handwriting
