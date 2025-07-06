# Set common git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global pull.rebase true
git config --global init.defaultBranch master

# Configure identification
echo -e "\nEnter identification for git..."
export GIT_USER_NAME=$(gum input --placeholder "Enter full name" --prompt "Name> ")
export GIT_USER_EMAIL=$(gum input --placeholder "Enter email address" --prompt "Email> ")

# Set identification from install inputs
if [[ -n "${GIT_USER_NAME//[[:space:]]/}" ]]; then
  git config --global user.name "$GIT_USER_NAME"
fi

if [[ -n "${GIT_USER_EMAIL//[[:space:]]/}" ]]; then
  git config --global user.email "$GIT_USER_EMAIL"
fi