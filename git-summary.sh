#!/bin/bash

################################################################################
# Git Summary & Merge Request Generator
# 
# Usage:
#   ./git-summary.sh [start_date] [end_date]
#   ./git-summary.sh 2025-10-17 2025-10-18
#   ./git-summary.sh                          # Uses yesterday to today
#
# Date format: YYYY-MM-DD
################################################################################

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Default dates if not provided
if [ -z "$1" ]; then
    # Check if running on macOS or Linux
    if [[ "$OSTYPE" == "darwin"* ]]; then
        START_DATE=$(date -v-1d +%Y-%m-%d)
    else
        START_DATE=$(date -d "yesterday" +%Y-%m-%d)
    fi
else
    START_DATE=$1
fi

if [ -z "$2" ]; then
    END_DATE=$(date +%Y-%m-%d)
else
    END_DATE=$2
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

echo -e "${BOLD}${CYAN}========================================${NC}"
echo -e "${BOLD}${CYAN}  Git Summary Report${NC}"
echo -e "${BOLD}${CYAN}========================================${NC}"
echo -e "${YELLOW}Branch:${NC} ${GREEN}${CURRENT_BRANCH}${NC}"
echo -e "${YELLOW}Period:${NC} ${START_DATE} to ${END_DATE}"
echo ""

# Check if there are any commits in the date range
COMMIT_COUNT=$(git log --since="${START_DATE}" --until="${END_DATE} 23:59:59" --oneline | wc -l | xargs)

if [ "$COMMIT_COUNT" -eq 0 ]; then
    echo -e "${RED}No commits found in the specified date range.${NC}"
    exit 0
fi

echo -e "${BOLD}${BLUE}📊 Commits (${COMMIT_COUNT}):${NC}"
echo -e "${CYAN}----------------------------------------${NC}"
git log --since="${START_DATE}" --until="${END_DATE} 23:59:59" \
    --pretty=format:"%C(yellow)%h%C(reset) - %C(green)%an%C(reset), %C(cyan)%ar%C(reset)%n  %s%n" \
    --abbrev-commit
echo ""

echo -e "${BOLD}${BLUE}📁 Files Changed:${NC}"
echo -e "${CYAN}----------------------------------------${NC}"
git log --since="${START_DATE}" --until="${END_DATE} 23:59:59" \
    --stat --pretty=format:"" | grep -E "^\s.*\|" | sort | uniq
echo ""
echo ""

echo -e "${BOLD}${BLUE}📈 Statistics:${NC}"
echo -e "${CYAN}----------------------------------------${NC}"
STATS=$(git log --since="${START_DATE}" --until="${END_DATE} 23:59:59" \
    --shortstat --pretty=format:"" | \
    awk '{files+=$1; inserted+=$4; deleted+=$6} END \
    {print "Files changed: " files "\nLines inserted: " inserted "\nLines deleted: " deleted}')
echo "${STATS}"
echo ""
echo ""

# Get list of modified files
MODIFIED_FILES=$(git log --since="${START_DATE}" --until="${END_DATE} 23:59:59" \
    --name-only --pretty=format:"" | sort | uniq | grep -v "^$")

# Get commit messages
COMMIT_MESSAGES=$(git log --since="${START_DATE}" --until="${END_DATE} 23:59:59" \
    --pretty=format:"%s" | sed 's/^/- /')

# Analyze changes to suggest title
FIRST_COMMIT_MSG=$(git log --since="${START_DATE}" --until="${END_DATE} 23:59:59" \
    --pretty=format:"%s" --reverse | head -n 1)

# Generate suggested MR title and description
echo -e "${BOLD}${GREEN}========================================${NC}"
echo -e "${BOLD}${GREEN}  Suggested Merge Request${NC}"
echo -e "${BOLD}${GREEN}========================================${NC}"
echo ""

echo -e "${BOLD}${YELLOW}📝 Title (Simple & Direct):${NC}"
echo -e "${CYAN}----------------------------------------${NC}"
if [ "$COMMIT_COUNT" -eq 1 ]; then
    echo "${FIRST_COMMIT_MSG}"
else
    echo "Multiple updates: ${FIRST_COMMIT_MSG} and more"
fi
echo ""

echo -e "${BOLD}${YELLOW}📄 Description (Simple & Direct):${NC}"
echo -e "${CYAN}----------------------------------------${NC}"
cat << 'DESCRIPTION_END'
## Changes
DESCRIPTION_END
echo "${COMMIT_MESSAGES}"
echo ""
echo "## Modified Files"
echo "${MODIFIED_FILES}" | sed 's/^/- /'
echo ""
echo "## Branch"
echo "${CURRENT_BRANCH}"
echo ""
echo "## Period"
echo "${START_DATE} to ${END_DATE}"
echo ""
echo ""

# Generate alternative comprehensive description
echo -e "${BOLD}${YELLOW}📄 Alternative Description (Comprehensive):${NC}"
echo -e "${CYAN}----------------------------------------${NC}"
cat << 'ALT_DESC_END'
## Summary
[Add brief summary of what these changes accomplish]

## Changes
ALT_DESC_END
echo "${COMMIT_MESSAGES}"
echo ""
echo "## Modified Files"
git log --since="${START_DATE}" --until="${END_DATE} 23:59:59" --stat --pretty=format:"" | \
  grep -E "^\s.*\|" | sort | uniq
echo ""
echo ""
cat << 'ALT_DESC_END2'
## Testing Notes
- [ ] Tested functionality works as expected
- [ ] No breaking changes introduced
- [ ] Code reviewed and documented

## Impact
[Describe the business or technical impact of these changes]
ALT_DESC_END2
echo ""
echo ""

# Show example usage
echo -e "${BOLD}${CYAN}========================================${NC}"
echo -e "${BOLD}${CYAN}  Usage Examples${NC}"
echo -e "${BOLD}${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}1. Summary for yesterday to today:${NC}"
echo "   ./git-summary.sh"
echo ""
echo -e "${YELLOW}2. Summary for specific date range:${NC}"
echo "   ./git-summary.sh 2025-10-17 2025-10-18"
echo ""
echo -e "${YELLOW}3. Summary for last week:${NC}"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "   ./git-summary.sh \$(date -v-7d +%Y-%m-%d) \$(date +%Y-%m-%d)"
else
    echo "   ./git-summary.sh \$(date -d '7 days ago' +%Y-%m-%d) \$(date +%Y-%m-%d)"
fi
echo ""

# Option to save to file
echo -e "${YELLOW}💾 Save description to file:${NC}"
echo "   ./git-summary.sh $START_DATE $END_DATE > merge-request-$(date +%Y%m%d).txt"
echo ""

echo -e "${BOLD}${GREEN}✅ Summary Complete${NC}"
echo ""
