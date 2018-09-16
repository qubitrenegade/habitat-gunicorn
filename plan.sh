# This file is the heart of your application's habitat.
# See full docs at https://www.habitat.sh/docs/reference/plan-syntax/
pkg_name=gunicorn
pkg_origin=qbrd
pkg_version="19.9.0"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=("Apache-2.0")
pkg_source="https://github.com/benoitc/${pkg_name}/archive/${pkg_version}.tar.gz"
pkg_filename="${pkg_name}-${pkg_version}.tar.gz"
pkg_shasum="d593aa13812eadc1f5cffe4a81ccdcbcb25528e5418af1b5138e88fd8c0c2a31"
pkg_deps=(
  core/bash
  core/python
)
pkg_lib_dirs=(lib)
pkg_bin_dirs=(bin)

# pkg_exports=(
#   [host]=srv.address
#   [port]=srv.port
#   [ssl-port]=srv.ssl.port
# )

# pkg_exposes=(port ssl-port)

# pkg_binds=(
#   [database]="port host"
# )

# pkg_binds_optional=(
#   [storage]="port host"
# )

# pkg_interpreters=(bin/bash)

pkg_svc_user="hab"
pkg_svc_group="$pkg_svc_user"

pkg_description="Python WSGI Server - https://github.com/qubitrenegade/habitat-gunicorn"
pkg_upstream_url="https://gunicorn.org"

do_unpack() {
  return 0
}

do_build() {
  return 0
}

do_install() {
  pip install --prefix="$pkg_prefix" "${HAB_CACHE_SRC_PATH}/${pkg_filename}"

  # write our wrapper script
  bash_path=$(pkg_path_for core/bash)
  for file in ${pkg_prefix}/bin/gunicorn*; do
    # Rename executable to ${file}.real"
    mv "${file}" "${file}.real"
    # Write wrapper script to replace ${file}
    cat <<EOF > "${file}"
#!${bash_path}/bin/bash
export PYTHONPATH=$PYTHONPATH:${pkg_prefix}/lib/python3.7/site-packages
exec ${file}.real "\$@"
EOF
    # set the execute bit
    chmod a+x "${file}"
done
}
