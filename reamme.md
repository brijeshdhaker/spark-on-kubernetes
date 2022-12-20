
#
#
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
