Example Secret:
```yaml
apiVersion: v1
type: kubernetes.io/tls
kind: Secret
metadata:
  name: oidc-forward-auth-cert
  annotations:
    waf-cert-uploader.iits.tech/waf-id: "123"
  labels:
    waf-cert-uploader.iits.tech/enabled: "true"
data:
  tls.crt: LS0tLS1CRUdJ
  tls.key: LS0tLS1CRUdJ
```
Example Cert:
```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: try.waf-cert-uploader.iits.tech
  namespace: waf
spec:
  secretTemplate:
    labels:
      waf-cert-uploader.iits.tech/enabled: "true"
    annotations:
      waf-cert-uploader.iits.tech/waf-domain-id: 419ace14a34946e8b8b022473d5eb1f9
  secretName: try.waf-cert-uploader.iits.tech
  duration: 2160h # 90d
  renewBefore: 360h # 15d
  subject:
    organizations:
      - jetstack
  isCA: false
  privateKey:
    algorithm: RSA
    encoding: PKCS1
    size: 2048
  usages:
    - server auth
    - client auth
  dnsNames:
    - try.waf-cert-uploader.iits.tech
  issuerRef:
    name: letsencrypt
    kind: ClusterIssuer
```

You can find more details in the [project documentation](https://github.com/iits-consulting/waf-cert-uploader/blob/main/README.md)