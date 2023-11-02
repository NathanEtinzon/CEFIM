$Commit_name = Read-Host -Prompt 'Entrez le nom du commit'
git add .
git commit -m '$Commit_name'
git push CEFIM master
mkdocs gh-deploy -r CEFIM