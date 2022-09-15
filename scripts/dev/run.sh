#!/bin/bash
# Get env name value by source folder
SOURCE="${BASH_SOURCE[0]}"
echo $SOURCE

DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

ENV=`basename $DIR`

# Go out to root of git folder
cd ../../

# Set test result folder path
RESULT_FOLDER="results/"$ENV

# Create result folder
mkdir -p $RESULT_FOLDER

# Change directory to result folder
cd $RESULT_FOLDER

# Set testcase folder path when standing at result folder.
# That's why we need to go back twice when running robot testcase
TESTCASE_FOLDER='../../testcases/'


echo "=== $(date) - TECHTALK REPOS - RUNNING ON $ENV ENV ==="
echo "=== $(date) - TECHTALK REPOS - START RUNNING MAIN JOB ==="
python3 -m robot.run -L TRACE -v env:$ENV -e not_ready -e not-ready -e ignore $TESTCASE_FOLDER
echo "=== $(date) - TECHTALK REPOS - FINISH RUNNING MAIN JOB ==="

#echo "=== $(date) - TECHTALK REPOS - START RE-RUN JOB ==="
#python3 -m robot.run -v env:$ENV --rerunfailed output.xml --output rerun.xml $TESTCASE_FOLDER
#echo "=== $(date) - TECHTALK REPOS - FINISH RE-RUN JOB ==="
#
#echo "=== $(date) - TECHTALK REPOS - START MERGING MAIN AND RERUN RESULTS ==="
#python3 -m robot.rebot --merge --output output.xml output.xml rerun.xml
#echo "=== $(date) - TECHTALK REPOS - FINISH MERGING MAIN AND RERUN RESULTS ==="

# For do not let Jenkins mark failed from shell script.
exit 0
