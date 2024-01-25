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

for n in $(jq '.|select(.type=="suite" and .event=="ok") .passed' "$FILE")
do
	passed=$((passed+n))
done

# xargs used to remove spaces from wc output
ignored=$(jq -c '.|select(.type=="test" and .event=="ignored")' "$FILE" |wc -l|xargs)

time=$(jq '.|select(.type=="suite" and .event=="ok") .exec_time' /tmp/test.json|awk '{sum+=$1};END {print sum}')
secs=$(printf "%.0f" "$time")

# Output in Markdown format
echo "### Tests results $FEATURE"

echo "| Test result | Passed ✅ | Failed ❌ | Skipped ⏭️  |  Time duration ⏰ |"
echo "|-------------|-----------|-----------|-------------|------------------|"
printf "| 🟢 Pass | %d | 0 | %d | %d minutes %d seconds |\n" "$passed" "$ignored" $((secs/60)) $((secs%60))

if [ "$ignored" -ne 0 ]; then
    printf "\n#### Tests skipped\n"
    jq '.|select(.type=="test" and .event=="ignored")| .name' /tmp/test.json |tr '$' ' '| sed -e 's/"//g'|sed -e 's/^/- /'
fi

echo
