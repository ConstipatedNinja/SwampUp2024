# Path to the projects JSON file
project_file="./project.json"
# Fetch the projectKey from projects.json
project_key=$(jq -r '.projectKey' "$project_file")

# Loop through each repository entry in local-repos.json
for row in $(jq -r '.[] | @base64' ./remote-repos.json); do
    _jq() {
        echo "${row}" | base64 --decode | jq -r "${1}"
    }

    # Get the repository key from remote-repos.json
    repo_key=$(_jq '.key')

    # Combine project_key and repo_key with a hyphen
    prefixed_repo_name="${project_key}-${repo_key}"

    # Create the repository with the prefixed repo name and other variables
    jf rt repo-create template-remote-rescue.json --vars "repo-name=$prefixed_repo_name;package-type=$(_jq '.packageType');repo-type=$(_jq '.rclass');project-key=$project_key;url=$(_jq '.url');repo-layout=$(_jq '.repoLayoutRef');env=$(_jq '.environments');xray-enable=$(_jq '.xrayIndex')"
done