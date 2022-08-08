# /bin/sh

# Under Apache 2.0 licence
COMMIT_RANGE=${COMMIT_RANGE:-$(git merge-base origin/master HEAD)".."}
echo "RANGE: $COMMIT_RANGE"
# Go to the root of the repo
cd "$(git rev-parse --show-toplevel)"

# Get a list of the current files in package form by querying Bazel.
files=()
for file in $(git diff --name-only ${COMMIT_RANGE} ); do
  echo "FILE:: $file"
  files+=($(bazel query $file))
  echo $(bazel query $file)
done

echo "${files[@]}"

# Query for the associated buildables
buildables=$(bazel query \
    --keep_going \
    --noshow_progress \
    "kind(.*_binary, rdeps(//..., set(${files[*]})))")
echo "buildables:::, $buildables"
# Run the tests if there were results
if [[ ! -z $buildables ]]; then
  echo "Building binaries"
  bazel build $buildables
  echo "Testing"
  bazel test $buildables
fi

# tests=$(bazel query \
#     --keep_going \
#     --noshow_progress \
#     "kind(.*test, rdeps(//..., set(${files[*]}))) except attr('tags', 'manual', //...)")
# echo "tests:::, $tests"
# # Run the tests if there were results
# if [[ ! -z $tests ]]; then
#   echo "Running tests"
#   bazel test $tests
# fi 