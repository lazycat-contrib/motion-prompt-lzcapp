#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
upstream_dir="$(mktemp -d)"
source_dir="${UPSTREAM_SOURCE_DIR:-}"

cleanup() {
  rm -rf "${upstream_dir}"
}
trap cleanup EXIT

# Upstream publishes no release tags and no build artefacts: the repository is
# the site, and tools/build.mjs regenerates the derived files in place. Track
# main and rebuild those derived files here.
if [[ -z "${source_dir}" ]]; then
  upstream_sha="$(
    git ls-remote https://github.com/showheyohtaki/motion-prompt.git \
      refs/heads/main | awk '{print $1}'
  )"
  test -n "${upstream_sha}"

  source_dir="${upstream_dir}/source"
  mkdir -p "${source_dir}"
  curl --fail --location --retry 3 --retry-all-errors \
    "https://codeload.github.com/showheyohtaki/motion-prompt/tar.gz/${upstream_sha}" \
    | tar -xz --strip-components=1 -C "${source_dir}"
else
  source_dir="$(cd "${source_dir}" && pwd)"
  upstream_sha="$(git -C "${source_dir}" rev-parse HEAD)"
fi

test -f "${source_dir}/tools/build.mjs"
cd "${source_dir}"
printf "Building upstream commit %s\n" "${upstream_sha}"
node tools/build.mjs

# The site is served straight from the repository root, minus the files that
# exist only for GitHub, for authoring, or for the build itself.
rm -rf "${project_root}/dist"
mkdir -p "${project_root}/dist"
for entry in index.html found.html api assets packs examples make-your-own skills .nojekyll; do
  if [[ -e "${source_dir}/${entry}" ]]; then
    cp -a "${source_dir}/${entry}" "${project_root}/dist/"
  fi
done
