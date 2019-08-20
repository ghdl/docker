#! /bin/bash

cd "$(dirname $0)"

. "travis/utils.sh"

curbranch="$(git branch | grep \* | cut -d ' ' -f2-)"

if [ $# -le 0 ]; then
    printf "${ANSI_RED}No arguments. Please provide the name of the branches you want to rewrite/update.$ANSI_NOCOLOR\n"
    exit 1
fi

mcodegpl="sid"
mcode="buster sid ubuntu16 ubuntu18 fedora28 fedora29"
llvm="buster-7 sid-8 ubuntu16-3.9 ubuntu18-5.0 fedora28 fedora29"
gcc="stretch-5.5.0 buster-8.3.0 sid-9.1.0 fedora28-8.1.0 fedora29-8.2.0"

cp .travis.yml .travis.ref

for BRANCH in $@; do
  if [ "$(git branch | grep "$BRANCH")" = "" ]; then
    read -r -p "$(printf "${ANSI_YELLOW}Branch $BRANCH does not exist. Do you want to create it? [y/n]${ANSI_NOCOLOR} ")" c
    case "$c" in
      [yY][eE][sS]|[yY])
        git checkout -b "$BRANCH" master
        git push -u origin "$BRANCH"
      ;;
      *)
        echo "Skipping..."
        continue
    esac
  else
    git checkout "$BRANCH"
    git reset --hard master
  fi

  printf "${ANSI_DARKCYAN}[GHDL - docker] ${BRANCH}: hard reset, commit and push$ANSI_NOCOLOR\n"

  case "$BRANCH" in
    "mcode"*|"llvm"|"gcc")
      f="travis/ymls/buildtest"
    ;;
    *)
      f="travis/ymls/${BRANCH}"
    ;;
  esac

  if [ ! -f "$f" ]; then
    echo "File $f does not exist. Exiting..."
    git checkout master
    exit 1
  fi
  head -n 12 .travis.ref > .travis.yml
  cat "$f" >> .travis.yml
  sed -i.bak "s/\(branch:\s\)buildtest/branch: $BRANCH/g" .travis.yml

  for k in $(eval echo "\$$BRANCH"); do
    case "$BRANCH" in
      "mcode")
        a="$k+$BRANCH"
      ;;
      "llvm"|"gcc")
        if [ "$(echo $k | grep "-")" != "" ]; then
          a="$(echo $k | cut -d"-" -f1)+$BRANCH-$(echo $k | cut -d"-" -f2)"
        else
          a="$k+$BRANCH"
        fi
      ;;
      "mcodegpl")
        a="$k+mcode"
      ;;
      *)
        "Unknown branch type $k"
      ;;
    esac
    echo "      - IMAGE=$a" >> .travis.yml
    if [ "x$BRANCH" = "xmcodegpl" ]; then
      echo "        EXTRA=gpl" >> .travis.yml
    fi
  done

  git commit -am "$BRANCH"
  git push origin +"$BRANCH"
done

printf "${ANSI_DARKCYAN}[GHDL - docker] Return to branch <${curbranch}>$ANSI_NOCOLOR\n"
git checkout "$curbranch"
