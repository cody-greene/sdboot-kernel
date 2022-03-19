#!/usr/bin/env bash
set -e

VERSION="$1"
PKGNAME=systemd-boot-kernel

usage() {
  echo "Usage: ./release.sh 1.2.3"
  exit 1
}

# verify version format: numbers & dots
[[ "$VERSION" =~ ^[0-9](\.[0-9]+)+$ ]] || usage

sha=$(git archive HEAD --format tgz --prefix "$PKGNAME-$VERSION/" | sha256sum | awk '{print $1}')

mkdir -p aur

<PKGBUILD >aur/PKGBUILD sed "
  s/^pkgver=.*/pkgver=$VERSION/
  s/^#source=/source=/
  s/^#sha256sums=.*/sha256sums=($sha)/
  s/\$startdir/\$pkgname-\$pkgver/
"

(cd aur && makepkg --printsrcinfo >.SRCINFO)

#########
# Alternative to "git subtree push --prefix"
# Commit a subdirectory to another branch while keeping the current branch clean
# Only uses plumbing commands
# Usage: grease <branch> <dir> <msg>
# Example: grease gh-pages dist v1.0.0
#########
grease() {
  local TARGET_BRANCH="refs/heads/$1"
  local TARGET_DIR="$2"
  local MESSAGE="$3"
  local parent=""
  if git show-ref --verify --quiet "$TARGET_BRANCH"; then
    parent="-p $TARGET_BRANCH"
  fi

  find "$TARGET_DIR" -type f | xargs git update-index --add
  tree_sha=$(git write-tree --prefix "$TARGET_DIR")
  find "$TARGET_DIR" -type f | xargs git update-index --force-remove
  commit_sha=$(git commit-tree -m "$MESSAGE" $parent $tree_sha)
  git update-ref $TARGET_BRANCH $commit_sha

  echo Committed "$TARGET_DIR" as "$MESSAGE" to "$TARGET_BRANCH"
  echo To undo:
  echo "  git update-ref $TARGET_BRANCH $TARGET_BRANCH~"
}

grease aurfiles aur "v${VERSION}"
git tag "v${VERSION}"

echo "Tagged HEAD as v${VERSION}"
echo "Finalize with:"
echo "  git push upstream HEAD:master v${VERSION}"
echo "  git push aur aurfiles:master"
