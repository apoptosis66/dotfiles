# Local
# sudo mount /dev/sdc1 /backup
rsync -avh /media/ /backup/media/ --delete --exclude=lost+found/

# Remote
# rsync -avh apoptosis@mediacenter:/media/ /run/media/apoptosis/Backup/media/ --delete --exclude=lost+found/