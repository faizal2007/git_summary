# Git Summary Script

Automatically generate git commit summaries and merge request descriptions for a specified date range.

## Features

- ✅ Colored terminal output for easy reading
- ✅ Lists all commits in date range
- ✅ Shows file changes with statistics
- ✅ Auto-generates merge request title and description
- ✅ Provides both "Simple & Direct" and "Comprehensive" description formats
- ✅ Cross-platform support (macOS and Linux)
- ✅ Save output to file

## Installation

The script is already created and executable in `/var/www/git-summary.sh`

If needed, make it executable:
```bash
chmod +x git-summary.sh
```

## Usage

### Basic Usage

```bash
# Summary for yesterday to today (default)
./git-summary.sh

# Summary for specific date range
./git-summary.sh 2025-10-17 2025-10-18

# Summary for last 7 days
./git-summary.sh $(date -d '7 days ago' +%Y-%m-%d) $(date +%Y-%m-%d)

# On macOS
./git-summary.sh $(date -v-7d +%Y-%m-%d) $(date +%Y-%m-%d)
```

### Save to File

```bash
# Save output to a text file
./git-summary.sh 2025-10-17 2025-10-18 > merge-request-20251018.txt

# Save with automatic date in filename
./git-summary.sh 2025-10-17 2025-10-18 > merge-request-$(date +%Y%m%d).txt
```

## Output Format

The script provides:

1. **Git Summary Report**
   - Current branch
   - Date range
   - Commit list with authors and timestamps
   - Files changed
   - Statistics (files changed, lines inserted/deleted)

2. **Suggested Merge Request**
   - **Title** - Auto-generated based on commits
   - **Description (Simple & Direct)** - Based on your preference (Option 3)
     - Changes list
     - Modified files
     - Branch name
     - Period
   - **Alternative Description (Comprehensive)** - For more detailed MRs
     - Summary section (fill in manually)
     - Changes list
     - Modified files with statistics
     - Testing checklist
     - Impact section (fill in manually)

## Example Output

```
========================================
  Git Summary Report
========================================
Branch: fix_mature_report
Period: 2025-10-17 to 2025-10-18

📊 Commits (2):
----------------------------------------
9f44d71 - Mohd Faizal Mohamed Sadri, 19 minutes ago
  temporary increase php ini limits

c6f3775 - Mohd Faizal Mohamed Sadri, 2 hours ago
  add tonne to maturity report

📁 Files Changed:
----------------------------------------
 app/Http/Controllers/EstateReportController.php
 resources/views/estates/admin/reports/reportsItemise.blade.php
 resources/views/estates/admin/reports/survey.blade.php

📈 Statistics:
----------------------------------------
Files changed: 4
Lines inserted: 660
Lines deleted: 162

========================================
  Suggested Merge Request
========================================

📝 Title (Simple & Direct):
----------------------------------------
Multiple updates: add tonne to maturity report and more

📄 Description (Simple & Direct):
----------------------------------------
## Changes
- temporary increase php ini limits
- add tonne to maturity report

## Modified Files
- app/Http/Controllers/EstateReportController.php
- resources/views/estates/admin/reports/reportsItemise.blade.php
- resources/views/estates/admin/reports/survey.blade.php

## Branch
fix_mature_report

## Period
2025-10-17 to 2025-10-18
```

## Tips

1. **Quick Daily Summary**
   ```bash
   # Add alias to your ~/.zshrc or ~/.bashrc
   alias gitsummary='/var/www/git-summary.sh'
   
   # Then just run:
   gitsummary
   ```

2. **Copy for GitLab/GitHub**
   - Run the script
   - Copy the "Description (Simple & Direct)" section
   - Paste into your merge/pull request description field

3. **Customize Output**
   - Edit the script to change description format
   - Modify the color scheme
   - Add additional git information

## Date Format

Always use **YYYY-MM-DD** format for dates:
- ✅ Correct: `2025-10-17`
- ❌ Wrong: `17-10-2025`, `10/17/2025`

## Troubleshooting

**No commits found**
- Check your date range
- Verify you're on the correct branch
- Ensure commits exist in the specified period

**Permission denied**
```bash
chmod +x git-summary.sh
```

**Date command not working**
- The script auto-detects macOS vs Linux
- If issues persist, always specify dates explicitly

## Future Enhancements

Potential additions:
- Export to Markdown file
- Integration with GitLab/GitHub API
- Template customization
- Multi-branch comparison
- Jira ticket linking

---

**Created:** October 18, 2025  
**Author:** Based on git commit analysis workflow  
**Version:** 1.0
