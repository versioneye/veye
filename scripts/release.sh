
VERSION_FILE=lib/veye/version.rb
VEYE_VERSION="$(cat $VERSION_FILE | awk '/VERSION/{print}' | awk '{print $3}')"

echo "releasing new version $VEYE_VERSION"

git tag -a $VEYE_VERSION -m "v$VEYE_VERSION" && \
  git push origin --tags && \
  gem push veye-$(VEYE_VERSION).gem
