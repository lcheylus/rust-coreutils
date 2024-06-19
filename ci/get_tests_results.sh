#! /bin/sh
# Generare Markdown report from JSON result file

# Check if jq is available
if ! [ -x "$(command -v jq)" ];
then
	echo "jq command not found"
	exit 1
fi

# Check args
if [ $# -lt 1 ]; then
	echo "ERROR: JSON result file undefined"
	exit 1
fi

FILE=$1
FEATURE=$2

if ! test -f "$FILE"; then
	echo "ERROR: $FILE file not found"
	exit 1
fi

passed=0

for n in $(jq '.|select(.type=="suite" and (.event=="ok" or .event=="failed")) .passed' "$FILE")
do
	passed=$((passed+n))
done

# xargs used to remove spaces from wc output
failed=$(jq -c '.|select(.type=="test" and .event=="failed")' "$FILE"|wc -l|xargs)
ignored=$(jq -c '.|select(.type=="test" and .event=="ignored")' "$FILE"|wc -l|xargs)

time=$(jq '.|select(.type=="suite" and (.event=="ok" or .event=="failed")) .exec_time' "$FILE"|awk '{sum+=$1};END {print sum}')
secs=$(printf "%.0f" "$time")

status=""
if [ "$failed" -ne 0 ]; then
	status="🔴 Fail"
else
	status="🟢 Pass"
fi

# Output in Markdown format
if [ "$FEATURE" = "uucore" ]; then
    echo "### Tests results - uucore"
else
    echo "### Tests results - feature = $FEATURE"
fi

echo "| Test result | Passed ✅ | Failed ❌ | Skipped ⏭️  |  Time duration ⏰ |"
echo "|-------------|-----------|-----------|-------------|-------------------|"
printf "| %s | %d | %d | %d | %d minutes %d seconds |\n" "$status" "$passed" "$failed" "$ignored" $((secs/60)) $((secs%60))


if [ "$failed" -ne 0 ]; then
    printf "\n#### Tests failed\n"
    jq '.|select(.type=="test" and .event=="failed")| .name' "$FILE"|tr '$' ' '| sed -e 's/"//g'|sed -e 's/#.$//'|sed -e 's/^/- \`/'|sed -e 's/$/\`/'
fi

if [ "$ignored" -ne 0 ]; then
    printf "\n#### Tests skipped\n"
    jq '.|select(.type=="test" and .event=="ignored")| .name' "$FILE"|tr '$' ' '| sed -e 's/"//g'|sed -e 's/^/- \`/'|sed -e 's/$/\`/'
fi

echo
