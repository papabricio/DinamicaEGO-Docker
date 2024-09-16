#!/bin/bash

# Algumas variáveis de ambiente usadas aqui são especificadas do AppImage.
# APPDIR: Path of mountpoint of the SquashFS image contained in the AppImage.
# OWD:    Path to working directory at the time the AppImage is called.

DINAMICA_HOME="${HOME}/Dinamica EGO 7"
REGISTRY_FILE="${HOME}/.dinamica_ego_7.conf"
SYSTEM_REGISTRY_FILE="${HOME}/.dinamica_ego_7_system.conf"

BIN_PATH=`dirname "$0"`

#DINAMICA_GUI_COMMAND="${BIN_PATH}/jre/bin/java -Djava.library.path=${BIN_PATH}/../lib/ -DrPluginFilename=Dinamica_1.0.7.tar.gz -Xss1m -Xms64m -Xmx8192m -server -Dawt.useSystemAAFontSettings=lcd -ea -Djava.util.Arrays.useLegacyMergeSort=true -Dsun.java2d.noddraw=false -Dsun.java2d.d3d=false -Dprism.order=sw -splash:$APPDIR/Splash.png -jar ${BIN_PATH}/DinamicaNUI.jar"

DINAMICA_CONSOLE_COMMAND=bin/DinamicaConsole

export DINAMICA_EGO_7_INSTALLATION_DIRECTORY=${BIN_PATH}

# Cria os arquivos de registro, se eles não existirem
if [ ! -e "${REGISTRY_FILE}" ]; then
  touch ${REGISTRY_FILE}
fi
if [ ! -e "${SYSTEM_REGISTRY_FILE}" ]; then
  touch ${SYSTEM_REGISTRY_FILE}
fi

if [ $# -eq 0 ]; then
  echo "No model filename was given"

  #Define o folder do usuário como folder de log
  export DINAMICA_EGO_7_LOG_PATH=${DINAMICA_HOME}
  exec ${DINAMICA_CONSOLE_COMMAND} -help

else
  # Caso o nome de arquivo do script não seja passado e seja passada opção, define o folder padrão do usuário como
  # folder de log. Caso contrário, o folder de log será o folder contendo o arquivo do script sendo executado.
  # Além disso, o nome do arquivo do script é completado, caso ele seja relativo.

  if [[ "${!#}" = -* ]]; then
    # Argumento é opção.
    export DINAMICA_EGO_7_LOG_PATH=${DINAMICA_HOME}
    exec ${DINAMICA_CONSOLE_COMMAND} "$@"

  elif [[ "${!#}" = /* ]]; then
    # Argumento é nome de script com caminho absoluto: não é necessário completar o caminho.
    export DINAMICA_EGO_7_LOG_PATH=${DINAMICA_HOME}
    exec ${DINAMICA_CONSOLE_COMMAND} "$@"

  else
    # Argumento é nome de script com caminho relativo: é necessário completar o caminho.
    export DINAMICA_EGO_7_LOG_PATH=${DINAMICA_HOME}
    exec ${DINAMICA_CONSOLE_COMMAND} "${@:1:$#-1}" "$OWD/${!#}"
  fi
fi

