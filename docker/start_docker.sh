#!/usr/bin/env bash
WORKING_DIR=/home/{$USER}
CONTAINER=tools_dev_${USER}

[[ -z "$WORKING_DIR" ]] ||  OPTION_WORK="-v ${WORKING_DIR}:/workspace/tools/bsnn_dag_compiler/src"
echo "starting ${CONTAINER} container"
docker run --name ${CONTAINER} -d -it ${OPTION_WORK}  tool_dev
cat << EOF

tools docker container is up and running.
to start use tools, run the following command:
docker exec -it ${CONTAINER} /bin/bash
EOF


