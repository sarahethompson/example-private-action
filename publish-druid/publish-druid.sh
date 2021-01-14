#!/usr/bin/env bash
set -euo pipefail

function verify_pipeline {
  # Arguments:
  #   $1 - Publish ID

  local SHA=$1

  result=""

  TIMEOUT=0
  until [[ ! -z "$result" ]]
  do
      command=$(curl -s --retry 5 --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://gitlab.com/api/v4/projects/23592332/pipelines" | jq ".[] | select(.sha==\"$SHA\" and .status==\"success\")") || return 1
      result=$(echo "${command}"| jq .id)
	  if (( $TIMEOUT == 300 ))
      then
        echo "Pipeline was not successful"
        echo "$command"
        return 1
      else
        sleep $(( TIMEOUT++ ))
      fi
  done

  echo "Pipeline successful."
  echo "$command"
  return 0

}

$*
