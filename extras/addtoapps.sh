# Useful only to me - Install in bin locations
set -euo pipefail

SCRIPTFILE="zoxide-datatools.sh"
BASENAME="${SCRIPTFILE%.*}"
SCRIPTDIR="$GITHUBPATH/$BASENAME"

pushd . > /dev/null

cp $SCRIPTDIR/$SCRIPTFILE $GITHUBPATH/macapps/bin/$BASENAME

installmacapps --local

popd > /dev/null
