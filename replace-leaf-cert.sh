#!/bin/bash

# 🔧 Pfad zur PEM-Datei (3CX)
PEM_DIR="/var/lib/3cxpbx/Bin/nginx/conf/Instance1"

# 🔍 Finde erste .pem-Datei im Verzeichnis
PEM_FILE=$(find "$PEM_DIR" -maxdepth 1 -type f -name "*.pem" | head -n 1)

if [[ -z "$PEM_FILE" ]]; then
    echo "❌ Keine .pem-Datei in $PEM_DIR gefunden."
    exit 1
fi

echo "🔧 Zertifikatsdatei: $PEM_FILE"

# 📦 Neues Zertifikat inline
read -r -d '' NEW_CERT <<'EOF'
-----BEGIN CERTIFICATE-----
MIIGNjCCBR6gAwIBAgIQBsAsI9DBqDCSSMpexfQBgDANBgkqhkiG9w0BAQsFADCB
jzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMTcwNQYDVQQD
Ey5TZWN0aWdvIFJTQSBEb21haW4gVmFsaWRhdGlvbiBTZWN1cmUgU2VydmVyIENB
MB4XDTI1MDUxMjAwMDAwMFoXDTI2MDYxMjIzNTk1OVowGjEYMBYGA1UEAwwPKi5m
dWxkYWNsb3VkLmRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApoBd
QScACeHjGDcraNyadU2+Pi9YMauLyjo3RU1ozZi2JkDoQd1Exn0louIgtOlnph+5
S2ygG4NEi4Z40HkODCDv6NoxxhsYUNARHUcndbNYSuRxayNtV0wdODesxaugeL6P
7wT6m7Vv0eH8rJJ+t0N4q6qxDiTjVgVvvbl8ZeGMfo3FFcbs1rk0vnXZiIUdezb3
6bOw9zpuadganv1+LLC6TxBaYig2LNyhfVYIiq8zyQONKRiNHQzyksqXwcCs6DUl
QaObWWg8r2lkuaVPOwWeJlFu4qCUwQhr8dJv41C9izEgbK2AFBiMCQeFkd0KeM6B
FAWv8z6qcJ8UP8zY+wIDAQABo4IDADCCAvwwHwYDVR0jBBgwFoAUjYxexFStiuF3
6Zv5mwXhuAGNYeEwHQYDVR0OBBYEFOWxoJ5MmRgWfUlnF/HQsv9uUsCcMA4GA1Ud
DwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggr
BgEFBQcDAjBJBgNVHSAEQjBAMDQGCysGAQQBsjEBAgIHMCUwIwYIKwYBBQUHAgEW
F2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMAgGBmeBDAECATCBhAYIKwYBBQUHAQEE
eDB2ME8GCCsGAQUFBzAChkNodHRwOi8vY3J0LnNlY3RpZ28uY29tL1NlY3RpZ29S
U0FEb21haW5WYWxpZGF0aW9uU2VjdXJlU2VydmVyQ0EuY3J0MCMGCCsGAQUFBzAB
hhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTApBgNVHREEIjAggg8qLmZ1bGRhY2xv
dWQuZGWCDWZ1bGRhY2xvdWQuZGUwggF+BgorBgEEAdZ5AgQCBIIBbgSCAWoBaAB2
AJaXZL9VWJet90OHaDcIQnfp8DrV9qTzNm5GpD8PyqnGAAABlsRxFm8AAAQDAEcw
RQIgI9ii10PpHNt3hjPhlfompFqYlqE4To3yZD90jUTeSaMCIQCbHVlCVtB6F0Nr
92U9NyTVG1d1B4UsIlw3HUOQIPxcxwB2ABmG1Mcoqm/+ugNveCpNAZGqzi1yMQ+u
zl1wQS0lTMfUAAABlsRxFgcAAAQDAEcwRQIhAL0JBLorAUW+a8ixl9dwvy7vQbHi
GtrqAsaKFc1KSBQTAiBnDjaXbLn0c9T3bFK3PDA5WyPOzXNUCqlfjbndXyGdTwB2
AA5XlLzzrqk+MxssmQez95Dfm8I9cTIl3SGpJaxhxU4hAAABlsRxFggAAAQDAEcw
RQIhAKPeZdrFPvoeZMPmoFHMSTTzeY3PKCEr1/VpN3kf7KcGAiAtdfkpBBlCHXBt
YnRpJNYZsY/r4wkpOoX1NCFqmdpX4TANBgkqhkiG9w0BAQsFAAOCAQEAQqDAdIAL
1SOMATOk17Qy29m5QyBhPUGTW/q14m4F4sOQ6lac0qkl6/ml9/KHVZUKWcKHpf+i
Bx0Uufe7fEo30bbYCtJ1Q+fmIkqZ6YsRqdlh/393xJwz+skPAVET6HSt2+DxVJP5
H72efN8M+QExikvzI1xzjf2y13Chiwwrs3hqdIikcg05aQMyALA5G/WNJ6x6OrEp
HeCHmv9Kqp5fvaZZYq3IynI1kx99pAEy6X9nu9wIDTfmk7CsOOJYKE5Et1TmwEf/
pS/K+xE9GQTAMkuguqisEo9AwNQFK5IJP1KSyclrt9+aWrLPeNWgYD70FDNxQvQl
xNm3oNVzPl+8nw==
-----END CERTIFICATE-----
EOF

# 🧠 Backup erstellen
cp "$PEM_FILE" "${PEM_FILE}.bak"
echo "📝 Backup erstellt: ${PEM_FILE}.bak"

# 🔁 Leaf-Zertifikat ersetzen
awk -v newcert="$NEW_CERT" '
BEGIN { inside=0 }
/-----BEGIN CERTIFICATE-----/ && !inside {
    print newcert
    inside=1
    next
}
/-----END CERTIFICATE-----/ && inside {
    inside=0
    next
}
!inside
' "$PEM_FILE" > "${PEM_FILE}.tmp" && mv "${PEM_FILE}.tmp" "$PEM_FILE"

echo "✅ Zertifikat ersetzt."

# 🔍 NGINX-Konfiguration prüfen
echo "🔍 nginx -t läuft..."
if nginx -t; then
    echo "✅ NGINX-Konfiguration OK. Lade neu..."
    systemctl reload nginx
    echo "✅ nginx reload erfolgreich."
else
    echo "❌ FEHLER in nginx-Konfiguration! Änderungen wurden NICHT übernommen."
    echo "➡️  Stelle ggf. das Backup wieder her: cp ${PEM_FILE}.bak ${PEM_FILE}"
    exit 1
fi
