#!/bin/bash
#
DOMAIN=$1 # example.com
WILD=$2 # *.example.com, use W for wildcard
#
DHBITS=4096 #4096 too long...
BITS=4096
PROT=sha256
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
COUNTRY_NAME=${CERT_COUNTRY_NAME:-RU}
STATE_OR_PROVINCE_NAME=${CERT_STATE_OR_PROVINCE_NAME:-Kaliningrad Region}
LOCALITY_NAME=${CERT_LOCALITY_NAME:-Kaliningrad}
ORGANIZATION_NAME=${CERT_ORGANIZATION_NAME:-Dev Corporation Ltd}
ORGANIZATIONAL_UNIT_NAME=${CERT_ORGANIZATIONAL_UNIT_NAME:-Dev Corporation Ltd Unit}
EMAIL_ADDRESS=${CERT_EMAIL_ADDRESS:-info@info@devcorporation.ltd}
# Wildcard option
if [ "$WILD" = "W" ]
then
    COMMON_NAME='*.'${DOMAIN}
    DNS1='DNS.1 = '${DOMAIN}
    DNS2='DNS.2 = *.'${DOMAIN}
else
    COMMON_NAME=${DOMAIN}
    DNS1='DNS = '${DOMAIN}
    DNS2=''
fi
#
echo 'Create OpenSSL confs...'
echo '# OpenSSL configuration file.
# Copy to `'${SRV}'/openssl_'${DOMAIN}'.cnf`.

[ ca ]
# `man ca`
default_ca = CA_default

[ CA_default ]
# Directory and file locations.
dir               = '${SRV}'
certs             = $dir/certs
crl_dir           = $dir/crl
new_certs_dir     = $dir/newcerts
database          = $dir/index.txt
serial            = $dir/serial
RANDFILE          = $dir/private/.rand

# The root key and root certificate.
private_key       = '${ICA}'/private/intermediateCA.key.pem
certificate       = '${ICA}'/certs/intermediateCA.cert.pem

# For certificate revocation lists.
crlnumber         = $dir/crlnumber
crl               = $dir/crl/intermediate.crl.pem
crl_extensions    = crl_ext
default_crl_days  = 30

# SHA-1 is deprecated, so use SHA-2 instead.
default_md        = '${PROT}'

name_opt          = ca_default
cert_opt          = ca_default
default_days      = '${DAYS}'
preserve          = no
policy            = policy_loose

[ policy_strict ]
# The root CA should only sign certificates that match.
# See the POLICY FORMAT section of `man ca`.
countryName             = match
stateOrProvinceName     = match
organizationName        = match
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ policy_loose ]
# Allow the CA to sign a more diverse range of certificates.
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
emailAddress                    = '${EMAIL_ADDRESS}'

# Optionally, specify some defaults.
countryName_default             = '${COUNTRY_NAME}'
stateOrProvinceName_default     = '${STATE_OR_PROVINCE_NAME}'
localityName_default            = '${LOCALITY_NAME}'
0.organizationName_default      = '${ORGANIZATION_NAME}'
organizationalUnitName_default  = '${ORGANIZATION_NAME}' '${CA_TXT}'
emailAddress_default            = '${EMAIL_ADDRESS}'

[ v3_ca ]
# Extensions for a typical CA (`man x509v3_config`).
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign

[ v3_intermediate_ca ]
# Extensions for a typical CA (`man x509v3_config`).
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
subjectAltName = @alternate_names

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

[ alternate_names ]
'${DNS1}'
'${DNS2}'

' >> ${SRV}'/openssl_'${DOMAIN}'.cnf'
#
# Server cert
#
echo 'Server cert...'
cd ${SRV}
openssl genrsa -out private/${DOMAIN}.key.pem ${BITS}
openssl req -config openssl_${DOMAIN}.cnf -key private/${DOMAIN}.key.pem -new -${PROT} -out csr/${DOMAIN}.csr.pem -subj "/C=${COUNTRY_NAME}/ST=${STATE_OR_PROVINCE_NAME}/L=${LOCALITY_NAME}/O=${ORGANIZATION_NAME}/OU=${ORGANIZATIONAL_UNIT_NAME} Web Services/CN=${COMMON_NAME}/emailAddress=${EMAIL_ADDRESS}"
openssl ca -batch -config openssl_${DOMAIN}.cnf -extensions server_cert -days ${DAYS} -notext -md ${PROT} -in csr/${DOMAIN}.csr.pem -out certs/${DOMAIN}.cert.pem
cp certs/${DOMAIN}.cert.pem ${SSL}/${DOMAIN}.cert.pem
cp private/${DOMAIN}.key.pem ${SSL}/${DOMAIN}.key.pem
openssl x509 -noout -text -in certs/${DOMAIN}.cert.pem
openssl verify -CAfile ${SSL}/ca-chain.cert.pem certs/${DOMAIN}.cert.pem
#
# Chain
#
echo 'Chain...'
cat ${SRV}/certs/${DOMAIN}.cert.pem ${ICA}/certs/intermediateCA.cert.pem > ${SSL}/${DOMAIN}.chain.cert.pem
#
# Fullchain
#
echo 'Full chain...'
cat ${SRV}/certs/${DOMAIN}.cert.pem ${ICA}/certs/intermediateCA.cert.pem ${RCA}/certs/rootCA.cert.pem > ${SSL}/${DOMAIN}.fullchain.cert.pem
#
# Fix key file rights
#
chmod 644 ${SSL}/${DOMAIN}.key.pem
#
