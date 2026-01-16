#!/bin/bash

echo "=== ActiveMQ SSL STOMP Connection Diagnostics ==="
echo ""

echo "1. Test SSL handshake with OpenSSL (no client cert):"
echo "----------------------------------------------------"
timeout 5 openssl s_client -connect localhost:61612 -showcerts 2>&1 | head -30
echo ""

echo "2. Test SSL handshake WITH client certificate:"
echo "-----------------------------------------------"
timeout 5 openssl s_client -connect localhost:61612 \
  -cert client.pem \
  -key client.pem \
  -CAfile truststore.pem \
  -showcerts 2>&1 | head -40
echo ""

echo "3. Check if certificates exist and are readable:"
echo "-------------------------------------------------"
ls -lah client.pem truststore.pem 2>&1
echo ""

echo "4. Verify certificate details:"
echo "-------------------------------"
echo "Client certificate:"
openssl x509 -in client.pem -text -noout 2>&1 | grep -A2 "Validity\|Subject:"
echo ""
echo "Truststore certificate:"
openssl x509 -in truststore.pem -text -noout 2>&1 | grep -A2 "Validity\|Subject:"
echo ""

echo "5. Verify certificate chain:"
echo "-----------------------------"
openssl verify -CAfile truststore.pem client.pem 2>&1
echo ""

echo "6. Check if private key matches certificate:"
echo "---------------------------------------------"
CLIENT_CERT_HASH=$(openssl x509 -noout -modulus -in client.pem 2>/dev/null | openssl sha256)
CLIENT_KEY_HASH=$(openssl rsa -noout -modulus -in client.pem 2>/dev/null | openssl sha256)
echo "Certificate modulus hash: $CLIENT_CERT_HASH"
echo "Private key modulus hash: $CLIENT_KEY_HASH"
if [ "$CLIENT_CERT_HASH" = "$CLIENT_KEY_HASH" ]; then
    echo "✓ Certificate and private key MATCH"
else
    echo "✗ Certificate and private key DO NOT MATCH"
fi
echo ""

echo "7. Test with verbose Python SSL:"
echo "---------------------------------"
python3 << 'PYEOF'
import ssl
import socket
import sys

try:
    context = ssl.create_default_context(cafile='truststore.pem')
    context.check_hostname = False
    context.load_cert_chain(certfile='client.pem', keyfile='client.pem')
    
    # Enable debugging
    context.set_ciphers('DEFAULT')
    print(f"Protocol: {ssl.PROTOCOL_TLS}")
    print(f"Verify mode: {context.verify_mode}")
    
    try:
        with socket.create_connection(('localhost', 61612), timeout=5) as sock:
            print("✓ TCP connection successful")
            with context.wrap_socket(sock, server_hostname='localhost') as ssock:
                print(f"✓ SSL connection successful")
                print(f"  Cipher: {ssock.cipher()}")
                print(f"  Protocol: {ssock.version()}")
                cert = ssock.getpeercert()
                print(f"  Peer cert subject: {cert.get('subject', 'N/A')}")
    except Exception as e:
        print(f"✗ Connection failed: {e}")
        import traceback
        traceback.print_exc()
except FileNotFoundError as e:
    print(f"✗ Certificate file not found: {e}")
except ssl.SSLError as e:
    print(f"✗ SSL Error: {e}")
    import traceback
    traceback.print_exc()
except Exception as e:
    print(f"✗ Unexpected error: {e}")
    import traceback
    traceback.print_exc()
PYEOF
echo ""

echo "8. Check ActiveMQ broker SSL configuration:"
echo "--------------------------------------------"
echo "Look for these in activemq.xml:"
echo "  - transportConnector with stomp+ssl://"
echo "  - needClientAuth setting"
echo "  - SSL keyStore and trustStore paths"
echo ""

echo "9. Summary - Run these commands manually for more info:"
echo "--------------------------------------------------------"
echo "  openssl s_client -connect localhost:61612 -showcerts"
echo "  openssl s_client -connect localhost:61612 -cert client.pem -key client.pem -CAfile truststore.pem"
echo "  openssl verify -CAfile truststore.pem client.pem"
echo "  tail -100 /path/to/activemq/data/activemq.log | grep -iE 'ssl|certificate|handshake'"
