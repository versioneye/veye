GEMSPEC_FILE=veye.gemspec
VERSION_FILE=lib/veye/version.rb
VEYE_VERSION="$(cat $VERSION_FILE | awk '/VERSION/{print}' | awk '{print $3}')"

echo "Building release for $VEYE_VERSION"
bundle install && gem build $GEMSPEC_FILE
