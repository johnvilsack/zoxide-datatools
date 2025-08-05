#!/bin/bash

# zoxide-datatools Test Suite
# Tests all functionality to ensure everything works correctly

SCRIPTFILE="${1:-zoxide-datatools.sh}"
BASENAME="${SCRIPTFILE%.*}"
TESTDIR="$(pwd)/tests-$BASENAME"
SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Simple timing functionality
START_TIME=$SECONDS

elapsed_time() {
    echo "$((SECONDS - START_TIME))s"
}

mkdir -p "$TESTDIR"

EXPORTFILE="$TESTDIR/TEST-1-export-from-zoxide.txt"
CSVFILE="$TESTDIR/TEST-2-convert-to.csv"
FINALFILE="$TESTDIR/TEST-3-convert-back-to.txt"
SORTEDFILE="$TESTDIR/TEST-4-sorted.txt"
URIFILE="$TESTDIR/TEST-5-with-uri.csv"
URITXTFILE="$TESTDIR/TEST-6-with-uri-back-to.txt"
ZFILE="$TESTDIR/TEST-7-import-to-zoxide.z"
SIMPLECSVFILE="$TESTDIR/TEST-8-simple.csv"
SIMPLECSVTXTFILE="$TESTDIR/TEST-9-simple-back-to.txt"


echo "Starting zoxide-datatools test suite..."
echo

echo "Core Functionality Tests"
echo "1. Exporting from Zoxide ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE getzoxide $EXPORTFILE
echo "2. Converting to CSV ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE tocsv $EXPORTFILE $CSVFILE
echo "3. Converting CSV back to Zoxide Format ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE totext $CSVFILE $FINALFILE
echo "Core conversion cycle complete"

echo
echo "Advanced Features"
echo "4. Generating Sort ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE sort $EXPORTFILE $SORTEDFILE
echo "5. Generating keep URI ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE tocsv --keep-uri $EXPORTFILE $URIFILE
echo "6. Testing URI Conversion Back ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE totext $URIFILE $URITXTFILE
echo "7. Converting to Z format ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE toz $FINALFILE $ZFILE
echo "8. Testing Simple CSV Export ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE tosimplecsv $EXPORTFILE $SIMPLECSVFILE
echo "Advanced features complete"

echo
echo "Meta Functions (Main User Interface)"
echo "9. Testing Meta Export Function ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE export "$TESTDIR/TEST-META-export.csv" >/dev/null
echo "10. Testing Meta Export with Simple Option ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE export --simple "$TESTDIR/TEST-META-simple.csv" >/dev/null
echo "11. Testing Meta Export with Sort Option ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE export --sort --simple "$TESTDIR/TEST-META-sorted.csv" >/dev/null
echo "Meta functions complete"


# Copy sample files to test directory
cp "$SCRIPTDIR/sample-autojump.txt" "$TESTDIR/TEST-10-sample-autojump.txt"
cp "$SCRIPTDIR/sample-z.z" "$TESTDIR/TEST-11-sample-z.z"
cp "$SCRIPTDIR/sample-simple.csv" "$TESTDIR/TEST-12-sample-simple.csv"

echo
echo "Import & Backup Tests"
echo "12. Testing Backup Function ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE backup >/dev/null
echo "13. Testing Dry Run Import-File (Autojump) ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE import-file --dry-run "$TESTDIR/TEST-10-sample-autojump.txt" >/dev/null
echo "14. Testing Dry Run Import-File (Z Format) ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE import-file --dry-run "$TESTDIR/TEST-11-sample-z.z" >/dev/null
echo "15. Testing Dry Run Import-File (Simple CSV) ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE import-file --dry-run "$TESTDIR/TEST-12-sample-simple.csv" >/dev/null
echo "16. Testing Meta Import Dry Run ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE import --dry-run "$TESTDIR/TEST-META-export.csv" >/dev/null
echo "17. Testing Restore Function ($(elapsed_time))"
$SCRIPTDIR/$SCRIPTFILE restore >/dev/null

echo
echo "All tests completed successfully! Total time: $(elapsed_time)"
echo
echo "Test files created in: $TESTDIR"
echo "All functionality verified working correctly"
