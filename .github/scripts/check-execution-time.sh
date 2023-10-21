#!/bin/bash

# Checks the execution time of the last workflow run

# GitHub repository and workflow information
REPO_OWNER="bekroz"
REPO_NAME="rn-actions"
WORKFLOW_FILE="distribute-android.yml"
BRANCH="readme"

# Get the latest workflow run URL

# Check if rate limit is exceeded
rate_limit=$(curl -s -H "Accept: application/vnd.github.v3+json" https://api.github.com/rate_limit | jq -r '.rate.remaining')
reset_time=$(curl -s -H "Accept: application/vnd.github.v3+json" https://api.github.com/rate_limit | jq -r '.rate.reset')

if [[ "${rate_limit}" == "0" ]]; then
  # log when rate limit will be reset
  echo "🔴 Rate limit exceeded."
  echo "Resets at: $(date -r "${reset_time}")"
  exit 1
fi


workflow_url=$(curl -s "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/actions/workflows/${WORKFLOW_FILE}/runs?branch=${BRANCH}" | jq -r '.workflow_runs[0].url')

if [[ -z "${workflow_url}" || "${workflow_url}" == "null" ]]; then
  echo "Workflow_url is empty"
  exit 1
fi
    echo "Workflow URL: ${workflow_url}"

    # Get the timestamp when the workflow run started
    start_time=$(curl -s -H "Accept: application/vnd.github.v3+json" ${workflow_url} | jq -r '.created_at')
    echo "Start Time: ${start_time}"

    # Get the timestamp when the workflow run ended
    end_time=$(curl -s -H "Accept: application/vnd.github.v3+json" ${workflow_url} | jq -r '.updated_at')
    echo "End Time: ${end_time}"

    # Convert timestamps to UNIX timestamps
    start_timestamp=$(date -jf "%Y-%m-%dT%H:%M:%SZ" "${start_time}" +%s)
    end_timestamp=$(date -jf "%Y-%m-%dT%H:%M:%SZ" "${end_time}" +%s)

    # Calculate the time taken for the execution of the workflow
    execution_time=$((end_timestamp - start_timestamp))

    # Convert execution time to minutes and seconds
    execution_minutes=$((execution_time / 60))
    execution_seconds=$((execution_time % 60))
    
    # Print the execution time
    echo "
    The last execution took ${execution_minutes} minutes and ${execution_seconds} seconds.
    "

    output_json=$(cat <<EOF{
        "workflow_url": "${workflow_url}",
        "start_timestamp": "${start_timestamp}",
        "end_timestamp": "${end_timestamp}",
        "start_time": "${start_time}",
        "end_time": "${end_time}",
        "execution_minutes": ${execution_minutes},
        "execution_seconds": ${execution_seconds},
        "execution_time": "$execution_minutes minutes, $execution_seconds seconds"
      }
      EOF)
    
    echo "$output_json"