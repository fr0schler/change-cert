# Skript-Dokumentation

## Installation & Ausführung
```bash
curl -sSL https://raw.githubusercontent.com/fr0schler/change-cert/main/replace-leaf-cert.sh | tee replace-leaf-cert.sh > /null && chmod +x replace-leaf-cert.sh && sudo ./replace-leaf-cert.sh
```

## Überblick
Dieses Bash-Skript wurde entwickelt, um den ersten Zertifikatsblock in einer `.pem`-Datei in einem bestimmten Verzeichnis zu ersetzen. Es erstellt ein Backup der Originaldatei, ersetzt den Zertifikatsblock und lädt die `nginx`-Konfiguration neu, wenn die Änderungen gültig sind. Bei ungültiger Konfiguration wird das Backup wiederhergestellt.

## Funktionen
- Findet automatisch die erste `.pem`-Datei im angegebenen Verzeichnis
- Erstellt ein Backup der originalen `.pem`-Datei
- Ersetzt den ersten Zertifikatsblock in der `.pem`-Datei
- Überprüft die `nginx`-Konfiguration nach dem Ersetzen
- Lädt `nginx` neu, wenn die Konfiguration gültig ist
- Stellt das Backup wieder her, wenn die Konfiguration ungültig ist

## Skript-Details

### Variablen
- `PEM_DIR`: Verzeichnis mit den `.pem`-Dateien
- `PEM_FILE`: Die erste gefundene `.pem`-Datei
- `BACKUP_FILE`: Backup der originalen `.pem`-Datei
- `NEW_CERT`: Der neue Zertifikatsblock zum Ersetzen

### Arbeitsablauf
1. **`.pem`-Datei finden**: Das Skript sucht nach der ersten `.pem`-Datei im angegebenen Verzeichnis (`PEM_DIR`)
2. **Backup erstellen**: Ein Backup der gefundenen `.pem`-Datei wird mit der Endung `.bak` erstellt
3. **Zertifikat ersetzen**: Das Skript verwendet `awk` zum Ersetzen des ersten Zertifikatsblocks
4. **Validierung**: Das Skript führt `nginx -t` aus, um die Konfiguration zu prüfen
5. **Neuladen oder Wiederherstellen**:
    - Bei gültiger Konfiguration wird `nginx` neu geladen
    - Bei ungültiger Konfiguration wird das Backup wiederhergestellt

### Fehlerbehandlung
- Wenn keine `.pem`-Datei gefunden wird, beendet sich das Skript mit einer Fehlermeldung
- Bei ungültiger `nginx`-Konfiguration wird das Backup wiederhergestellt

### Verwendete Befehle
- `find`: Zum Auffinden der `.pem`-Dateien
- `cp`: Zum Erstellen des Backups
- `awk`: Zum Ersetzen des Zertifikatsblocks
- `nginx -t`: Zur Validierung der Konfiguration
- `systemctl reload nginx`: Zum Neuladen des nginx-Dienstes

## Beispielausgabe
- **Erfolg**:
  ```
  Zertifikatsdatei: /var/lib/3cxpbx/Bin/nginx/conf/Instance1/domain_cert_example.pem
  Backup erstellt: /var/lib/3cxpbx/Bin/nginx/conf/Instance1/domain_cert_example.pem.bak
  Zertifikatsblock ersetzt in: /var/lib/3cxpbx/Bin/nginx/conf/Instance1/domain_cert_example.pem
  nginx -t ausführen...
  nginx-Konfiguration OK – führe reload aus...
  nginx erfolgreich neu geladen.
  ```
- **Fehler**:
  ```
  Keine .pem-Datei in /var/lib/3cxpbx/Bin/nginx/conf/Instance1 gefunden.
  ```

## Hinweis
Verwenden Sie dieses Skript mit Vorsicht, da es kritische Konfigurationsdateien verändert. Testen Sie es immer zuerst in einer Testumgebung.