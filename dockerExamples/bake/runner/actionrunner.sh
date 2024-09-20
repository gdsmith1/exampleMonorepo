#!/bin/bash
cd /home/gha/actions-runner


# Find and remove any existing runners
for ID in $(curl -s -H "Authorization: token $TOKEN" https://api.github.com/repos/gdsmith1/spring-petclinic/actions/runners | jq -r '.runners[] | .id'); do
    curl -s -X DELETE -H "Authorization: token $TOKEN" https://api.github.com/repos/gdsmith1/spring-petclinic/actions/runners/$ID
done

# Register the new runner
./config.sh --url https://github.com/gdsmith1/spring-petclinic --token $(curl -L -X POST -H 'Accept: application/vnd.github+json' -H 'Authorization: Bearer $TOKEN' -H 'X-GitHub-Api-Version: 2022-11-28' https://api.github.com/repos/gdsmith1/spring-petclinic/actions/runners/registration-token | jq -r '.token')

# Run the runner
./run.sh
