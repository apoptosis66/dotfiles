touch ~/backup/*.hc ~/backup/*.kdbx
rsync -av --progress ~/bin/ apoptosis@mediacenter:~/bin/
rsync -av --progress ~/bin/ apoptosis@mediacenter:/media/jake/bin/
rsync -av --progress ~/backup/ apoptosis@mediacenter:/media/jake/backup/
rsync -av --progress --delete --exclude='.venv/' --exclude='__pycache__/' ~/workspace/ apoptosis@mediacenter:/media/jake/workspace/
