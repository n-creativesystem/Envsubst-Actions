# Envsubst-Actions

このActionはenvsubstを使用して環境変数の値を書き換えます。

Linuxでのみ稼働することが出来ます。

## 使い方

`.github/workflows`ディレクトリに.yamlを作成します。

```yaml
name: Build and Deploy to IKS
on:
  push:
    baranch:
      - master

jobs:
  setup-build-publish-deploy:
    name: Setup, Build, Publish, and Deploy
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Install CLI Tools
        run: |
          curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
          ibmcloud config --check-version=false
          ibmcloud plugin install -f kubernetes-service
          ibmcloud plugin install -f container-registry

      - name: Authenticate with IBM Cloud CLI
        run: |
          ibmcloud login --apikey "${IBM_CLOUD_API_KEY}" -r "${IBM_CLOUD_REGION}"

      - name: Build with Docker
        run: |
          VERSION=$(echo ${{ github.ref }} | sed -e "s#refs/tags/##g")
          docker build -t "$REGISTRY_HOSTNAME"/"$REPOSITORY_NAMESPACE"/"$IMAGE_NAME":"$VERSION"

      - name: Push the image to Github Packages
        run: |
          VERSION=$(echo ${{ github.ref }} | sed -e "s#refs/tags/##g")
          echo "${DOCKER_PASSWORD}" | docker login $REGISTRY_HOSTNAME -u $DOCKER_USER_NAME --password-stdin
          docker push $REGISTRY_HOSTNAME/$REPOSITORY_NAMESPACE/$IMAGE_NAME:$VERSION

      - name: Deployment yaml
        uses: n-creativesystem/envsubst-action@v1
        with:
          input: ./kubernetes/deployment.yaml.tmpl
          output: ./kubernetes/deployment.yaml
        env:
          image_tag: gcr.io/myproject/app:${{ github.ref }}
      - name: Deploy to IKS
        run: |
          ibmcloud ks cluster config --cluster $IKS_CLUSTER
          kubectl config current-context
          kubectl apply -f kubernetes/deployment.yaml
```
