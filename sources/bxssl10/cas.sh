#!/bin/bash
#
DHBITS=4096 # 2048 fast 4096 too long...
BITS=4096
PROT=sha256
RCA_DAYS=5840 # 16 years
ICA_DAYS=4380 # 12 years
DAYS=3650 # 10 years
#
SSL=/ssl
RCA=/ssl/root_ca
ICA=/ssl/intermediate_ca
SRV=/ssl/servers
#
CA_TXT='Certificate Authority'
RCA_TXT='Root CA'
ICA_TXT='Intermediate CA'
COUNTRY_NAME=${CA_COUNTRY_NAME:-RU}
STATE_OR_PROVINCE_NAME=${CA_STATE_OR_PROVINCE_NAME:-Kaliningrad Region}
LOCALITY_NAME=${CA_LOCALITY_NAME:-Kaliningrad}
ORGANIZATION_NAME=${CA_ORGANIZATION_NAME:-Dev Corporation Ltd}
ORGANIZATIONAL_UNIT_NAME=${CA_ORGANIZATIONAL_UNIT_NAME:-Dev Corporation Ltd Unit}
RCA_EMAIL_ADDRESS=${CA_EMAIL_ADDRESS:-info@devcorporation.ltd}
ICA_EMAIL_ADDRESS=${CA_EMAIL_ADDRESS:-info@devcorporation.ltd}
#
echo 'Create dirs...'
mkdir -p ${SSL}
mkdir -p ${RCA} && cd ${RCA} && mkdir certs crl newcerts private && touch index.txt && echo 1000 > serial
mkdir -p ${ICA} && cd ${ICA} && mkdir certs crl csr newcerts private && touch index.txt && echo 1000 > serial && echo 1000 > ${ICA}/crlnumber
mkdir -p ${SRV} && cd ${SRV} && mkdir certs crl csr newcerts private && touch index.txt && echo 1000 > serial && echo 1000 > ${SRV}/crlnumber
#
echo 'Create OpenSSL confs...'
echo '# OpenSSL Root CA configuration file.
# Copy to `'${RCA}'/openssl.cnf`.

[ ca ]
# `man ca`
default_ca = CA_default

[ CA_default ]
# Directory and file locations.
dir               = '${RCA}'
certs             = $dir/certs
crl_dir           = $dir/crl
new_certs_dir     = $dir/newcerts
database          = $dir/index.txt
serial            = $dir/serial
RANDFILE          = $dir/private/.rand

# The root key and root certificate.
private_key       = $dir/private/rootCA.key.pem
certificate       = $dir/certs/rootCA.cert.pem

# For certificate revocation lists.
crlnumber         = $dir/crlnumber
crl               = $dir/crl/ca.crl.pem
crl_extensions    = crl_ext
default_crl_days  = 30

# SHA-1 is deprecated, so use SHA-2 instead.
default_md        = '${PROT}'

name_opt          = ca_default
cert_opt          = ca_default
default_days      = '${RCA_DAYS}'
preserve          = no
policy            = policy_strict

[ policy_strict ]
# The root CA should only sign intermediate certificates that match.
# See the POLICY FORMAT section of `man ca`.
countryName             = match
stateOrProvinceName     = match
organizationName        = match
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ policy_loose ]
# Allow the intermediate CA to sign a more diverse range of certificates.
# See the POLICY FORMAT section of the `ca` man page.
countryName             = optional
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ req ]
# Options for the `req` tool (`man req`).
default_bits        = '${BITS}'
distinguished_name  = req_distinguished_name
string_mask         = utf8only

# SHA-1 is deprecated, so use SHA-2 instead.
default_md          = '${PROT}'

# Extension to add when the -x509 option is used.
x509_extensions     = v3_ca

[ req_distinguished_name ]
# See <https://en.wikipedia.org/wiki/Certificate_signing_request>.
countryName                     = '${COUNTRY_NAME}'
stateOrProvinceName             = '${STATE_OR_PROVINCE_NAME}'
localityName                    = '${LOCALITY_NAME}'
0.organizationName              = '${ORGANIZATION_NAME}'
organizationalUnitName          = '${ORGANIZATION_NAME}' '${CA_TXT}'
commonName                      = '${ORGANIZATION_NAME}' '${RCA_TXT}'
emailAddress                    = '${RCA_EMAIL_ADDRESS}'

# Optionally, specify some defaults.
countryName_default             = '${COUNTRY_NAME}'
stateOrProvinceName_default     = '${STATE_OR_PROVINCE_NAME}'
localityName_default            = '${LOCALITY_NAME}'
0.organizationName_default      = '${ORGANIZATION_NAME}'
organizationalUnitName_default  = '${ORGANIZATION_NAME}' '${CA_TXT}'
emailAddress_default            = '${RCA_EMAIL_ADDRESS}'

[ v3_ca ]
# Extensions for a typical CA (`man x509v3_config`).
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign

[ v3_intermediate_ca ]
# Extensions for a typical intermediate CA (`man x509v3_config`).
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true, pathlen:0
keyUsage = critical, digitalSignature, cRLSign, keyCertSign

[ usr_cert ]
# Extensions for client certificates (`man x509v3_config`).
basicConstraints = CA:FALSE
nsCertType = client, email
nsComment = "OpenSSL Generated Certificate for QA"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, emailProtection

[ server_cert ]
# Extensions for server certificates (`man x509v3_config`).
basicConstraints = CA:FALSE
nsCertType = server
nsComment = "OpenSSL Generated Certificate for QA"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer:always
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth

[ crl_ext ]
# Extension for CRLs (`man x509v3_config`).
authorityKeyIdentifier=keyid:always

[ ocsp ]
# Extension for OCSP signing certificates (`man ocsp`).
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, digitalSignature
extendedKeyUsage = critical, OCSPSigning

' >> ${RCA}/openssl.cnf
#
echo '# OpenSSL Intermediate CA configuration file.
# Copy to `'${ICA}'/openssl.cnf`.

[ ca ]
# `man ca`
default_ca = CA_default

[ CA_default ]
# Directory and file locations.
dir               = '${ICA}'
certs             = $dir/certs
crl_dir           = $dir/crl
new_certs_dir     = $dir/newcerts
database          = $dir/index.txt
serial            = $dir/serial
RANDFILE          = $dir/private/.rand

# The root key and root certificate.
private_key       = $dir/private/intermediateCA.key.pem
certificate       = $dir/certs/intermediateCA.cert.pem

# For certificate revocation lists.
crlnumber         = $dir/crlnumber
crl               = $dir/crl/intermediate.crl.pem
crl_extensions    = crl_ext
default_crl_days  = 30

# SHA-1 is deprecated, so use SHA-2 instead.
default_md        = '${PROT}'

name_opt          = ca_default
cert_opt          = ca_default
default_days      = '${ICA_DAYS}'
preserve          = no
policy            = policy_loose

[ policy_strict ]
# The root CA should only sign intermediate certificates that match.
# See the POLICY FORMAT section of `man ca`.
countryName             = match
stateOrProvinceName     = match
organizationName        = match
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ policy_loose ]
# Allow the intermediate CA to sign a more diverse range of certificates.
# See the POLICY FORMAT section of the `ca` man page.
countryName             = optional
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ req ]
# Options for the `req` tool (`man req`).
default_bits        = '${BITS}'
distinguished_name  = req_distinguished_name
string_mask         = utf8only

# SHA-1 is deprecated, so use SHA-2 instead.
default_md          = '${PROT}'

# Extension to add when the -x509 option is used.
x509_extensions     = v3_ca

[ req_distinguished_name ]
# See <https://en.wikipedia.org/wiki/Certificate_signing_request>.
countryName                     = '${COUNTRY_NAME}'
stateOrProvinceName             = '${STATE_OR_PROVINCE_NAME}'
localityName                    = '${LOCALITY_NAME}'
0.organizationName              = '${ORGANIZATION_NAME}'
organizationalUnitName          = '${ORGANIZATION_NAME}' '${CA_TXT}'
commonName                      = '${ORGANIZATION_NAME}' '${ICA_TXT}'
emailAddress                    = '${ICA_EMAIL_ADDRESS}'

# Optionally, specify some defaults.
countryName_default             = '${COUNTRY_NAME}'
stateOrProvinceName_default     = '${STATE_OR_PROVINCE_NAME}'
localityName_default            = '${LOCALITY_NAME}'
0.organizationName_default      = '${ORGANIZATION_NAME}'
organizationalUnitName_default  = '${ORGANIZATION_NAME}' '${CA_TXT}'
emailAddress_default            = '${ICA_EMAIL_ADDRESS}'

[ v3_ca ]
# Extensions for a typical CA (`man x509v3_config`).
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign

[ v3_intermediate_ca ]
# Extensions for a typical intermediate CA (`man x509v3_config`).
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true, pathlen:0
keyUsage = critical, digitalSignature, cRLSign, keyCertSign

[ usr_cert ]
# Extensions for client certificates (`man x509v3_config`).
basicConstraints = CA:FALSE
nsCertType = client, email
nsComment = "OpenSSL Generated Certificate for QA"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, emailProtection

[ server_cert ]
# Extensions for server certificates (`man x509v3_config`).
basicConstraints = CA:FALSE
nsCertType = server
nsComment = "OpenSSL Generated Certificate for QA"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer:always
keyUsage = critical, digitalSignature, nonRepudiation, keyEncipherment
extendedKeyUsage = serverAuth

[ crl_ext ]
# Extension for CRLs (`man x509v3_config`).
authorityKeyIdentifier=keyid:always

[ ocsp ]
# Extension for OCSP signing certificates (`man ocsp`).
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, digitalSignature
extendedKeyUsage = critical, OCSPSigning

' >> ${ICA}/openssl.cnf
#
# DHParams
#
###echo 'DHParams...'
###cd ${SSL}
###openssl dhparam -out dhparam.pem ${DHBITS}
#
# Root CA
#
echo 'Root CA...'
cd ${RCA}
openssl genrsa -out private/rootCA.key.pem ${BITS}
openssl req -config openssl.cnf -x509 -new -key private/rootCA.key.pem -days ${RCA_DAYS} -${PROT} -extensions v3_ca -out certs/rootCA.cert.pem -subj "/C=${COUNTRY_NAME}/ST=${STATE_OR_PROVINCE_NAME}/L=${LOCALITY_NAME}/O=${ORGANIZATION_NAME}/OU=${ORGANIZATION_NAME} ${CA_TXT}/CN=${ORGANIZATION_NAME} ${RCA_TXT}"
openssl x509 -noout -text -in certs/rootCA.cert.pem
cp certs/rootCA.cert.pem ${SSL}/rootCA.cert.pem
#
# Intermediate CA
#
echo 'Intermediate CA...'
cd ${ICA}
openssl genrsa -out private/intermediateCA.key.pem ${BITS}
openssl req -config openssl.cnf -new -key private/intermediateCA.key.pem -${PROT} -out csr/intermediateCA.csr.pem -subj "/C=${COUNTRY_NAME}/ST=${STATE_OR_PROVINCE_NAME}/L=${LOCALITY_NAME}/O=${ORGANIZATION_NAME}/OU=${ORGANIZATION_NAME} ${CA_TXT}/CN=${ORGANIZATION_NAME} ${ICA_TXT}"
cd ${RCA}
openssl ca -batch -config openssl.cnf -extensions v3_intermediate_ca -days ${ICA_DAYS} -notext -md ${PROT} -in ${ICA}/csr/intermediateCA.csr.pem -out ${ICA}/certs/intermediateCA.cert.pem
cd ${ICA}
openssl x509 -noout -text -in certs/intermediateCA.cert.pem
openssl verify -CAfile ${RCA}/certs/rootCA.cert.pem certs/intermediateCA.cert.pem
cp certs/intermediateCA.cert.pem ${SSL}/intermediateCA.cert.pem
#
# CA Chain
#
echo 'CA chain...'
cat certs/intermediateCA.cert.pem ${RCA}/certs/rootCA.cert.pem > certs/ca-chain.cert.pem
cp certs/ca-chain.cert.pem ${SSL}/ca-chain.cert.pem
#
