#!/bin/bash

# 🔧 Liste deiner 3CX-FQDNs
FQDNS=(
    "https://pluspbx24.fuldacloud.de:5001/"
    "https://advisorpbx.fuldacloud.de:5001/"
    "https://ebbpbx.fuldacloud.de:5001/"
    "https://bufpbx.fuldacloud.de:5001/"
    "https://dtaxtk.fuldacloud.de:5001"
    "https://fehstpbx.fuldacloud.de:5001/"
    "https://freihofpbx.fuldacloud.de:5001/"
    "https://geierpbx.fuldacloud.de:5001/"
    "https://pbxgiese.fuldacloud.de:5001"
    "https://juptk.fuldacloud.de:5001/"
    "https://goebelpbx.fuldacloud.de/"
    "https://gumtk.fuldacloud.de:5001/"
    "https://kleinkapppbx.fuldacloud.de"
    "https://bayerntaxpbx.fuldacloud.de/"
    "https://mup3cx.fuldacloud.de:5001"
    "https://ostbgpbx.fuldacloud.de:5001"
    "https://omgnstbgpbx.fuldacloud.de:5001/"
    "https://oohstbgpbx.fuldacloud.de/"
    "https://ossigsmpbx.fuldacloud.de/"
    "https://osfstbgpbx.fuldacloud.de:5001"
    "https://prcpbx.fuldacloud.de:5001"
    "https://rauchpbx.fuldacloud.de"
    "https://reezpbx.fuldacloud.de:5001"
    "https://rrpbx.fuldacloud.de:5001/"
    "https://sauk3lpbx.fuldacloud.de:5001"
    "https://schleicherpbx.fuldacloud.de:5001"
    "https://schulthpbx.fuldacloud.de:5001"
    "https://schultzpbx.fuldacloud.de:5001/"
    "https://sgspbx.fuldacloud.de:5001/"
    "https://trafimetpbx.fuldacloud.de:5001/"
)
# 🔒 Mindestgültigkeit (z. B. Jahr 2026)
MIN_YEAR=2026

echo "🔎 Zertifikatsprüfung für 3CX-Endpunkte:"
echo "Erforderlich gültig bis mindestens: $MIN_YEAR"
echo

for entry in "${FQDNS[@]}"; do
  # Entferne "https://" oder "http://"
  hostport=$(echo "$entry" | sed -E 's|https?://||' | cut -d/ -f1)

  # Extrahiere Hostname und Port
  if [[ "$hostport" == *:* ]]; then
    host="${hostport%%:*}"
    port="${hostport##*:}"
  else
    host="$hostport"
    port=443
  fi

  echo "➡️  Prüfe: $host:$port"

  cert_output=$(echo | timeout 5 openssl s_client -connect "$host:$port" -servername "$host" -showcerts 2>/dev/null)
  cert=$(echo "$cert_output" | openssl x509 2>/dev/null)

  if [[ -z "$cert" ]]; then
    echo "❌ Keine Verbindung oder Zertifikat abrufbar."
    echo "----------------------------------------"
    continue
  fi

  expiry_raw=$(echo "$cert" | openssl x509 -noout -enddate | cut -d= -f2)
  expiry_year=$(date -d "$expiry_raw" +%Y 2>/dev/null)

  if [[ "$expiry_year" -ge "$MIN_YEAR" ]]; then
    echo "✅ Gültig bis: $expiry_raw"
  else
    echo "❌ Läuft zu früh ab: $expiry_raw"
  fi

  echo "----------------------------------------"
done