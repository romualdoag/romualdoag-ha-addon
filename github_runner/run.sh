#!/usr/bin/with-contenv bashio

if ! test -w /var/run/docker.sock
then
  # This process does not have write access to the Docker socket. This needs to
  # be fixed.
  #
  # Look up which group (by id) owns the Docker socket
  docker_gid="$(stat -c '%g' /var/run/docker.sock)"

  # Now create a group in this container with that gid, called 'docker'
  sudo groupadd --gid "$docker_gid" docker

  # Add the runner user (which executes this script) to that group
  sudo adduser runner docker

  # Adding the user to the group is not effective for the bash process that is
  # executing this script. Lets call this script again through sudo. We set the
  # user to 'runner' again, but sudo looks up which groups this user is in and
  # equips the new process accordingly.
  exec sudo --preserve-env --user=runner "$0" "$@"
fi

cd

config_opts=()

if test -n "$RUNNER_NAME"
then
  config_opts+=(--name "$RUNNER_NAME")
elif test -n "$RUNNER_NAME_PREFIX"
then
  DOCKER_CONTAINER_ID="$(basename "$(cat /proc/1/cpuset)")"
  config_opts+=(--name "$RUNNER_NAME_PREFIX (${DOCKER_CONTAINER_ID:0:10})")
fi

test -z "$RUNNER_LABELS" || config_opts+=(--labels "$RUNNER_LABELS")

echo '*** Configuring Runner ***'
./config.sh \
    --unattended \
    --url "$(bashio::config 'url')" \
    --token "$(bashio::config 'token')" \
    "${config_opts[@]}"

cleanup () {
  echo '*** Removing Runner ***'
  ./config.sh remove --unattended --token "$(get_token remove)"
}

trap 'cleanup' EXIT

# The runner process might exit when it updates itself to a newer version. We
# just wait five seconds and then restart.
while sleep 5
do
  echo '*** Starting Runner ***'
  if ./run.sh
  then
    echo '*** Runner exited ***'
  else
    echo '*** Runner died ($?) ***'
  fi
done