#!/bin/bash

PORT_RANGE=${PORT_RANGE:-${EG_PORT_RANGE:-0..0}}
RESPONSE_ADDRESS=${RESPONSE_ADDRESS:-${EG_RESPONSE_ADDRESS}}
PUBLIC_KEY=${PUBLIC_KEY:-${EG_PUBLIC_KEY}}
KERNEL_LAUNCHERS_DIR=${KERNEL_LAUNCHERS_DIR:-/usr/local/bin/kernel-launchers}
KERNEL_CLASS_NAME=${KERNEL_CLASS_NAME}

echo $0 env: `env`

launch_python_kernel() {
  # Launch the python kernel launcher - which embeds the IPython kernel and listens for interrupts
  # and shutdown requests from Enterprise Gateway.

  export JPY_PARENT_PID=$$  # Force reset of parent pid since we're detached

  if [ -z "${KERNEL_CLASS_NAME}" ]
  then
    kernel_class_option=""
  else
    kernel_class_option="--kernel-class-name ${KERNEL_CLASS_NAME}"
  fi

  set -x
  python ${KERNEL_LAUNCHERS_DIR}/python/scripts/launch_ipykernel.py --kernel-id ${KERNEL_ID} \
        --port-range ${PORT_RANGE} --response-address ${RESPONSE_ADDRESS} --public-key ${PUBLIC_KEY} \
        ${kernel_class_option}
  { set +x; } 2>/dev/null
}

# Ensure that required envs are present, check language before the dynamic values
if [ -z "${KERNEL_LANGUAGE+x}" ]
then
    echo "KERNEL_LANGUAGE is required.  Set this value in the image or when starting container."
    exit 1
fi
if [ -z "${KERNEL_ID+x}" ] || [ -z "${RESPONSE_ADDRESS+x}" ] || [ -z "${PUBLIC_KEY+x}" ]
then
    echo "Environment variables, KERNEL_ID, RESPONSE_ADDRESS, and PUBLIC_KEY are required."
    exit 1
fi

# Invoke the python kernel launcher since it's the only supported language now
if [[ "${KERNEL_LANGUAGE,,}" == "python" ]] then
    launch_python_kernel
else
    echo "Unrecognized value for KERNEL_LANGUAGE: '${KERNEL_LANGUAGE}'! Only 'python' is supported."
    exit 1
fi

exit 0
