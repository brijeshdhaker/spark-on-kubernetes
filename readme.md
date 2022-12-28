#
#
#

az account set --subscription 7bdb83d3-c6c5-432a-9e5a-a43aa1237379

az aks get-credentials --resource-group dhakerb-aks-rg --name dhakerb-aks-cluster

#
## Create Spark Image
#

export REPO_NAME=docker.io

cd $SPARK_HOME

docker build -t brijeshdhaker/spark:3.1.2-k8s -f ./kubernetes/dockerfiles/spark/Dockerfile .
docker push brijeshdhaker/spark:3.1.2-k8s

./bin/docker-image-tool.sh -t 3.1.2 -p ./kubernetes/dockerfiles/spark/bindings/python/Dockerfile build

# To build additional PySpark docker image
$ ./bin/docker-image-tool.sh -r <repo> -t my-tag -p ./kubernetes/dockerfiles/spark/bindings/python/Dockerfile build

# To build additional SparkR docker image
$ ./bin/docker-image-tool.sh -r <repo> -t my-tag -R ./kubernetes/dockerfiles/spark/bindings/R/Dockerfile build

./bin/docker-image-tool.sh -r sptest.azurecr.io -t v1 -p ./Dockerfile build


kubectl -n k8s-spark delete cm spark-configs

kubectl -n k8s-spark create cm spark-configs  \
 --from-file=spark-defaults.conf=setup/local/history-server/spark-defaults.conf \
 --from-literal=workload=HistoryServer \
 --dry-run=client -o yaml

#
## With NFS Volume 
#

$SPARK_HOME/bin/spark-submit \
--master k8s://https://192.168.1.7:16443 \
--deploy-mode cluster \
--name spark-pi \
--class org.apache.spark.examples.SparkPi \
--conf spark.executor.instances=2 \
--conf spark.kubernetes.context=microk8s \
--conf spark.kubernetes.container.image=docker.io/brijeshdhaker/spark:3.1.2-k8s \
--conf "spark.kubernetes.namespace=k8s-spark" \
--conf "spark.eventLog.enabled=true" \
--conf "spark.eventLog.dir=file:///mnt/nfs_share/spark/history-server/logs/" \
--conf "spark.kubernetes.authenticate.serviceAccountName=spark" \
--conf "spark.kubernetes.authenticate.driver.serviceAccountName=spark" \
--conf "spark.kubernetes.driver.volumes.nfs.driver-pvc.mount.path=/mnt/nfs_share" \
--conf "spark.kubernetes.driver.volumes.nfs.driver-pvc.options.server=192.168.122.1" \
--conf "spark.kubernetes.driver.volumes.nfs.driver-pvc.options.path=/mnt/nfs_share" \
--conf "spark.kubernetes.driver.volumes.nfs.driver-pvc.options.readOnly=false" \
--conf "spark.kubernetes.executor.volumes.nfs.exec-pvc.mount.path=/mnt/nfs_share" \
--conf "spark.kubernetes.executor.volumes.nfs.exec-pvc.options.server=192.168.122.1" \
--conf "spark.kubernetes.executor.volumes.nfs.exec-pvc.options.path=/mnt/nfs_share" \
--conf "spark.kubernetes.executor.volumes.nfs.exec-pvc.options.readOnly=false" \
--conf "spark.driver.extraJavaOptions=-Divy.cache.dir=/tmp -Divy.home=/tmp" \
local:///opt/spark/examples/jars/spark-examples_2.12-3.1.2.jar  10000


#
## With NFS Volume
#

$SPARK_HOME/bin/spark-submit \
--master k8s://https://192.168.1.7:16443 \
--deploy-mode cluster \
--name spark-pi \
--class org.apache.spark.examples.SparkPi \
--conf spark.executor.instances=2 \
--conf spark.kubernetes.context=microk8s \
--conf spark.kubernetes.container.image=docker.io/brijeshdhaker/spark:3.1.2-k8s \
--conf "spark.kubernetes.namespace=k8s-spark" \
--conf "spark.eventLog.enabled=true" \
--conf "spark.eventLog.dir=file:///mnt/nfs_share/spark/history-server/logs/" \
--conf "spark.kubernetes.authenticate.serviceAccountName=spark" \
--conf "spark.kubernetes.authenticate.driver.serviceAccountName=spark" \
--conf "spark.kubernetes.driver.volumes.nfs.driver-pvc.mount.path=/mnt/nfs_share" \
--conf "spark.kubernetes.driver.volumes.nfs.driver-pvc.options.server=192.168.122.1" \
--conf "spark.kubernetes.driver.volumes.nfs.driver-pvc.options.path=/mnt/nfs_share" \
--conf "spark.kubernetes.driver.volumes.nfs.driver-pvc.options.readOnly=false" \
--conf "spark.kubernetes.executor.volumes.nfs.exec-pvc.mount.path=/mnt/nfs_share" \
--conf "spark.kubernetes.executor.volumes.nfs.exec-pvc.options.server=192.168.122.1" \
--conf "spark.kubernetes.executor.volumes.nfs.exec-pvc.options.path=/mnt/nfs_share" \
--conf "spark.kubernetes.executor.volumes.nfs.exec-pvc.options.readOnly=false" \
--conf "spark.driver.extraJavaOptions=-Divy.cache.dir=/tmp -Divy.home=/tmp" \
local:///opt/spark/examples/jars/spark-examples_2.12-3.1.2.jar  10000


#
# Run Spark Job
#

$SPARK_HOME/bin/spark-submit \
--master "k8s://https://raspberry:6443" \
--deploy-mode "cluster" \
--name "spark-pi" \
--conf "spark.executor.instances=2" \
--conf "spark.kubernetes.file.upload.path=/apps/hostpath/spark/cluster-uploads" \
--conf "spark.pyspark.python=python3" \
--conf "spark.pyspark.driver.python=./venv/bin/python" \
--conf "spark.kubernetes.container.image=spark-py:3.1.2" \
--conf "spark.kubernetes.authenticate.driver.serviceAccountName=spark" \
--conf "spark.kubernetes.driver.volumes.hostPath.hostpath-volume.mount.path=/apps/hostpath/spark" \
--conf "spark.kubernetes.driver.volumes.hostPath.hostpath-volume.mount.readOnly=false" \
--conf "spark.kubernetes.driver.volumes.hostPath.hostpath-volume.options.path=/apps/hostpath/spark" \
--conf "spark.kubernetes.driver.volumes.hostPath.hostpath-volume.options.type=Directory" \
--conf "spark.kubernetes.executor.volumes.hostPath.hostpath-volume.mount.path=/apps/hostpath/spark" \
--conf "spark.kubernetes.executor.volumes.hostPath.hostpath-volume.mount.readOnly=false" \
--conf "spark.kubernetes.executor.volumes.hostPath.hostpath-volume.options.path=/apps/hostpath/spark" \
--conf "spark.kubernetes.executor.volumes.hostPath.hostpath-volume.options.type=Directory" \
--conf "spark.driver.extraJavaOptions=-Divy.cache.dir=/tmp -Divy.home=/tmp" \
--archives "local:///apps/hostpath/spark/artifacts/py/venv.zip#venv" \
--py-files "local:///apps/hostpath/spark/artifacts/py/application.zip" \
local:///apps/hostpath/spark/artifacts/py/py-hello.py


#
#
#

Storage account name : csg100320025a786393

Key : QjhwrUQ1gcQhebsYoIPmQONO8s2vD/rJy4NNxwMfI4zz9ENeGusZNbZFIshgxEaCJ4QRJ3VqAShD+AStXMEfrw==

Connection String : QjhwrUQ1gcQhebsYoIPmQONO8s2vD/rJy4NNxwMfI4zz9ENeGusZNbZFIshgxEaCJ4QRJ3VqAShD+AStXMEfrw==

#
# File Share
#

azure-file-share


$accountName = "csg100320025a786393"
$accountNameBytes = [System.Text.Encoding]::UTF8.GetBytes($accountName)
$accountNameBase64 = [Convert]::ToBase64String($accountNameBytes)
Write-Host "Account Name Base 64: " $accountNameBase64

#
#
#

$accountKey = "QjhwrUQ1gcQhebsYoIPmQONO8s2vD/rJy4NNxwMfI4zz9ENeGusZNbZFIshgxEaCJ4QRJ3VqAShD+AStXMEfrw=="
$accountKeyBytes = [System.Text.Encoding]::UTF8.GetBytes($accountKey)
$accountKeyBase64 = [Convert]::ToBase64String($accountKeyBytes)
Write-Host "Account Name Key 64: " $accountKeyBase64

#
#
#

kubectl -n k8s-spark create secret generic az-storage-secret \
 --from-literal=azurestorageaccountname=csg100320025a786393 \
 --from-literal=azurestorageaccountkey="QjhwrUQ1gcQhebsYoIPmQONO8s2vD/rJy4NNxwMfI4zz9ENeGusZNbZFIshgxEaCJ4QRJ3VqAShD+AStXMEfrw==" \
 --dry-run=client -o yaml


accountName="csg100320025a786393"
account=`echo -n $accountName | base64`
echo $account

Y3NnMTAwMzIwMDI1YTc4NjM5Mw==

accountKey="QjhwrUQ1gcQhebsYoIPmQONO8s2vD/rJy4NNxwMfI4zz9ENeGusZNbZFIshgxEaCJ4QRJ3VqAShD+AStXMEfrw=="
account_key=`echo -n $accountKey | base64`
echo $account_key

account_key=UWpod3JVUTFnY1FoZWJzWW9JUG1RT05POHMydkQvckp5NE5OeHdNZkk0eno5RU5lR3VzWk5iWkZJc2hneEVhQ0o0UVJKM1ZxQVNoRCtBU3RYTUVmcnc9PQ==

echo $account_key | base64 --decode

#!/bin/bash
echo "Enter Some text to encode"
read text
etext=`echo -n $text | base64`
echo "Encoded text is : $etext"