# Usage
```sh
cp save_data.yml.example save_data.yml
edit save_data.yml
./save_data.rb
```

# Code edit
- ``save_data.rb`` read the configuration, instantiate the right backup classes, and execute the script.
- ``Backup.rb`` interface class for backups.
- ``Backup/MongoDB.rb`` class that handle mongodb backups.
- ``config.yml`` default configuration file.
- ``Arguments.rb`` arguments handler

