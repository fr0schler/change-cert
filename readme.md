# Script Documentation

## Overview
This Bash script is designed to replace the first certificate block in a `.pem` file located in a specific directory. It creates a backup of the original file, replaces the certificate block, and reloads the `nginx` configuration if the changes are valid. If the configuration is invalid, the script restores the backup.

## Features
- Automatically locates the first `.pem` file in the specified directory.
- Creates a backup of the original `.pem` file.
- Replaces the first certificate block in the `.pem` file with a new certificate block.
- Validates the `nginx` configuration after the replacement.
- Reloads `nginx` if the configuration is valid.
- Restores the backup if the configuration is invalid.

## Script Details

### Variables
- `PEM_DIR`: Directory containing the `.pem` files.
- `PEM_FILE`: The first `.pem` file found in the directory.
- `BACKUP_FILE`: Backup of the original `.pem` file.
- `NEW_CERT`: The new certificate block to replace the existing one.

### Workflow
1. **Locate `.pem` File**: The script searches for the first `.pem` file in the specified directory (`PEM_DIR`) that matches certain naming patterns.
2. **Backup Creation**: A backup of the located `.pem` file is created with the `.bak` extension.
3. **Certificate Replacement**: The script uses `awk` to replace the first certificate block in the `.pem` file with the new certificate block (`NEW_CERT`).
4. **Validation**: The script runs `nginx -t` to validate the `nginx` configuration.
5. **Reload or Restore**:
    - If the configuration is valid, `nginx` is reloaded.
    - If the configuration is invalid, the backup file is restored.

### Error Handling
- If no `.pem` file is found, the script exits with an error message.
- If the `nginx` configuration is invalid, the script restores the backup and exits with an error message.

### Commands Used
- `find`: To locate `.pem` files in the directory.
- `cp`: To create a backup of the `.pem` file.
- `awk`: To replace the certificate block in the `.pem` file.
- `nginx -t`: To validate the `nginx` configuration.
- `systemctl reload nginx`: To reload the `nginx` service.

## Usage
1. Place the script in a directory with execution permissions.
2. Ensure the `PEM_DIR` variable points to the correct directory containing `.pem` files.
3. Run the script with appropriate permissions (e.g., as `root` or with `sudo`).

## Notes
- The script assumes that the `.pem` files follow a specific naming convention (`domain_cert_*.pem` or `*-crt.pem`).
- Ensure that the `nginx` service is installed and accessible on the system.
- Modify the `NEW_CERT` variable to include the desired certificate block.

## Example Output
- **Success**:
  ```
  Zertifikatsdatei: /var/lib/3cxpbx/Bin/nginx/conf/Instance1/domain_cert_example.pem
  Backup erstellt: /var/lib/3cxpbx/Bin/nginx/conf/Instance1/domain_cert_example.pem.bak
  Zertifikatsblock ersetzt in: /var/lib/3cxpbx/Bin/nginx/conf/Instance1/domain_cert_example.pem
  nginx -t ausführen...
  nginx-Konfiguration OK – führe reload aus...
  nginx erfolgreich neu geladen.
  ```
- **Error**:
  ```
  Keine .pem-Datei in /var/lib/3cxpbx/Bin/nginx/conf/Instance1 gefunden.
  ```

## Disclaimer
Use this script with caution, as it modifies critical configuration files. Always test in a staging environment before deploying to production.