# Usage

```sh
cp save_data.yml.example save_data.yml
edit save_data.yml
./save_data.rb
```

# Code edit

- ``save_data.rb`` read the configuration, instanciate the right backup classes, and execute the script
- ``backup.rb`` interface class for backups
- ``backup_mongodb.rb`` class that handle mongodb backups
