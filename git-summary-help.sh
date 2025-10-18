#!/bin/bash
# Quick Reference for git-summary.sh

cat << 'EOF'
╔════════════════════════════════════════════════════════════════╗
║              GIT SUMMARY SCRIPT - QUICK REFERENCE              ║
╚════════════════════════════════════════════════════════════════╝

📋 BASIC COMMANDS
─────────────────────────────────────────────────────────────────
  ./git-summary.sh                    → Yesterday to today
  ./git-summary.sh 2025-10-17         → From date to today
  ./git-summary.sh 2025-10-17 2025-10-18  → Specific range

📅 COMMON DATE RANGES
─────────────────────────────────────────────────────────────────
  Last 7 days:
    ./git-summary.sh $(date -d '7 days ago' +%Y-%m-%d) $(date +%Y-%m-%d)
  
  Last 30 days:
    ./git-summary.sh $(date -d '30 days ago' +%Y-%m-%d) $(date +%Y-%m-%d)
  
  This month:
    ./git-summary.sh $(date +%Y-%m-01) $(date +%Y-%m-%d)

💾 SAVE OUTPUT
─────────────────────────────────────────────────────────────────
  Save to file:
    ./git-summary.sh 2025-10-17 2025-10-18 > mr-description.txt
  
  Auto-dated filename:
    ./git-summary.sh 2025-10-17 2025-10-18 > mr-$(date +%Y%m%d).txt

🎯 QUICK ALIAS
─────────────────────────────────────────────────────────────────
  Add to ~/.zshrc:
    alias gsum='/var/www/git-summary.sh'
  
  Then reload:
    source ~/.zshrc
  
  Use:
    gsum 2025-10-17 2025-10-18

📖 HELP
─────────────────────────────────────────────────────────────────
  cat GIT-SUMMARY-README.md
  
  Full documentation in: /var/www/GIT-SUMMARY-README.md

╚════════════════════════════════════════════════════════════════╝
EOF
