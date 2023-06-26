#!/bin/bash

# Output file for the report
REPORT_FILE="suspicious_files_report.txt"

# Check if the report file already exists and delete it
if [ -f "$REPORT_FILE" ]; then
  rm "$REPORT_FILE"
fi

# Check if search directories are provided as arguments
if [ $# -eq 0 ]; then
  echo "Please provide one or more search directories as arguments."
  exit 1
fi

# Find suspicious files and write the details to the report file
echo "Suspicious Files Report" >> "$REPORT_FILE"
echo "======================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

for SEARCH_DIRECTORY in "$@"
do
  echo "Checking for files with unusual permissions in directory: $SEARCH_DIRECTORY" >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"
  find "$SEARCH_DIRECTORY" -type f \( -perm -o+rwx -o -perm -g+rwx -o -perm /600 \) -exec ls -l {} \; 2>/dev/null >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"

  echo "Checking for files modified within the last 24 hours in directory: $SEARCH_DIRECTORY" >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"
  find "$SEARCH_DIRECTORY" -type f -mtime -1 -exec ls -l {} \; 2>/dev/null >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"
done

echo "Report generated successfully. Please check $REPORT_FILE for details."
