#! /bin/bash

# copy files from SAM definitions
# sdporzio


############
# Function #
############

copyFilesFromDefinition(){
  PREFIX='enstore:';
  SUFFIX='(.*)';
  for i in `seq 1 ${N}`;
  do
    FILENAME=$(samweb list-definition-files ${DEFINITION}  | sed -n ${i}p);
    DIR_TO_FILE=$(samweb locate-file ${FILENAME} | sed -e "s@${PREFIX}@@" -e "s@${SUFFIX}@@");
    echo -e "Copying $FILENAME..."
    if [[ ! -e ${DEFINITION} ]]; then
    mkdir ${DEFINITION}
    fi
    rsync -avh --progress ${DIR_TO_FILE}/${FILENAME} ./${DEFINITION}/${FILENAME}
  done
}



##########################
# Wrapping and execution #
##########################

# Default arguments
HELP_FLAG='false'
DEFINITION='false'
N='1'

# Take in options
while [[ $* ]]
do
    OPTIND=1
    # echo $1
    if [[ $1 =~ ^- ]]
    then
        getopts hn: parameter
        case $parameter in
            h)  HELP_FLAG='true'
                echo -e "-> Help mode"
                ;;
            n)  N=${OPTARG}
                echo -e "-> Specified number of files: ${N}"
                shift
                ;;
            *) echo -e "This is an invalid argument: $parameter" ;;
        esac
    else
        DEFINITION=${1}
    fi
    shift
done


# Check if mandatory variables have been provided
# If not, complain and send to help documentation
if [ ${HELP_FLAG} == false ] && [ ${DEFINITION} == false ]; then
  echo
  echo -e "ERROR: \033[4m\033[1mInput definition not provided \033[0m"
  HELP_FLAG='true'
fi

# Either print help or execute function
if [ ${HELP_FLAG} == true ]; then
    echo -e "\n\033[1m${0}\033[0m copy files from SAM definitions."
    echo -e "\n\033[1mUsage:\033[0m ${0} [ -hn ] [ \033[4mdefinition\033[0m ]"
    echo -e "* \033[1m-h\033[0m: Help mode"
    echo -e "* \033[1m-n\033[0m: Number of files to copy (default: '1')"
    echo -e "* \033[1mdefinition\033[0m: SAM definition of the files to copy"
    echo
else
  copyFilesFromDefinition
fi
