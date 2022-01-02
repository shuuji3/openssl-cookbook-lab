#!/usr/bin/env bash

set -x

# Generate a new RSA key
openssl genpkey \
  -algorithm rsa \
  -pkeyopt rsa_keygen_bits:2048 \
  -aes-256-cbc \
  -out fd.key

# Export the public information from the RSA private key
openssl pkey -in fd.key -pubout -out fd-public.pub
cat fd-public.pub

# Generate a new ECDSA key with the curve P-256
openssl genpkey -out fd-ecdsa.key -algorithm ec -pkeyopt ec_paramgen_curve:P-256 -aes-256-cbc
cat fd-ecdsa.key

# Generate and show information of ed25519 key
openssl genpkey -algorithm ed25519 | openssl pkey -text

# Create a CSR
openssl req -new -key fd-ecdsa.key -out fd-ecdsa.csr -subj '/C=JP/L=Bunkyo/O=TAKAHASHI Shuuji/CN=shuuji3.xyx'

# Show the CSR info
openssl req -in fd-ecdsa.csr -text

# Create a CSR with the config file
openssl req -new -config fd.cnf -key fd-ecdsa.key -out fd-ecdsa-with-config.csr

# Show the CSR created with the config file
openssl req -in fd-ecdsa-with-config.csr -text

# Sign the CSR
openssl x509 -req -days 90 -in fd-ecdsa.csr -signkey fd-ecdsa.key -out fd-ecdsa.crt

# Show the content of the certificates
openssl x509 -in fd-ecdsa.crt -text

# Using extension file
openssl x509 -req -days 90 -in fd-ecdsa-with-config.csr -signkey fd-ecdsa.key -extfile fd.ext | openssl x509 -text

# Convert the PEM format certificate to the DER format
openssl x509 -in fd-ecdsa.crt -outform der

# Convert the PEM format certificate to the PKCS12 format
openssl pkcs12 -in fd-ecdsa.p12

# Convert the PEM format to the PKCS #7
openssl crl2pkcs7 -nocrl -certfile fd-ecdsa.crt

# Convert back the PKCS #7 to the PEM format
openssl crl2pkcs7 -nocrl -certfile fd-ecdsa.crt | openssl pkcs7 -print_certs
