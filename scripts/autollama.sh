#!/bin/bash

function show_art() {
    cat << "EOF"
 $$$$$$\  $$\   $$\ $$$$$$$$\  $$$$$$\           $$$$$$\  $$\       $$\        $$$$$$\  $$\      $$\  $$$$$$\  
$$  __$$\ $$ |  $$ |\__$$  __|$$  __$$\         $$  __$$\ $$ |      $$ |      $$  __$$\ $$$\    $$$ |$$  __$$\ 
$$ /  $$ |$$ |  $$ |   $$ |   $$ /  $$ |        $$ /  $$ |$$ |      $$ |      $$ /  $$ |$$$$\  $$$$ |$$ /  $$ |
$$$$$$$$ |$$ |  $$ |   $$ |   $$ |  $$ |$$$$$$\ $$ |  $$ |$$ |      $$ |      $$$$$$$$ |$$\$$\$$ $$ |$$$$$$$$ |
$$  __$$ |$$ |  $$ |   $$ |   $$ |  $$ |\______|$$ |  $$ |$$ |      $$ |      $$  __$$ |$$ \$$$  $$ |$$  __$$ |
$$ |  $$ |$$ |  $$ |   $$ |   $$ |  $$ |        $$ |  $$ |$$ |      $$ |      $$ |  $$ |$$ |\$  /$$ |$$ |  $$ |
$$ |  $$ |\$$$$$$  |   $$ |    $$$$$$  |         $$$$$$  |$$$$$$$$\ $$$$$$$$\ $$ |  $$ |$$ | \_/ $$ |$$ |  $$ |
\__|  \__| \______/    \__|    \______/          \______/ \________|\________|\__|  \__|\__|     \__|\__|  \__|
                                                                                                               
                                                                                                               
EOF
}

show_art

# Usage: ./script.sh <ModelPath> <GgufFileName>

# Initialize default values
MODEL_PATH=""
GGUF_FILE=""

# Display help/usage information
usage() {
  echo "Usage: $0 -m <model_path> -g <gguf_file>"
  echo
  echo "Options:"
  echo "  -m <model_path>    Set the path to the model"
  echo "  -g <gguf_file>     Set the GGUF file name"
  echo "  -h                 Display this help and exit"
  echo
}

# Parse command-line options
while getopts ":m:g:h" opt; do
  case ${opt} in
    m )
      MODEL_PATH=$OPTARG
      ;;
    g )
      GGUF_FILE=$OPTARG
      ;;
    h )
      usage
      exit 0
      ;;
    \? )
      echo "Invalid Option: -$OPTARG" 1>&2
      usage
      exit 1
      ;;
    : )
      echo "Invalid Option: -$OPTARG requires an argument" 1>&2
      usage
      exit 1
      ;;
  esac
done

# Check required parameters
if [ -z "$MODEL_PATH" ] || [ -z "$GGUF_FILE" ]; then
    echo "Error: -m (model_path) and -g (gguf_file) are required."
    usage
    exit 1
fi

# Derive MODEL_NAME
MODEL_NAME=$(echo $GGUF_FILE | sed 's/\(.*\)\.Q4.*/\1/')


# Check if 'screen' is installed
if ! command -v screen &> /dev/null; then
    echo "'screen' is not installed. Proceeding with installation..."
    # Update and install 'screen'
    apt-get update
    apt-get install -y screen
else
    echo "'screen' is already installed."
fi

# Log file where downloaded models are recorded
DOWNLOAD_LOG="downloaded_models.log"

# Composite logging name
LOGGING_NAME="${MODEL_PATH}_${MODEL_NAME}"

# Check if the model has been downloaded
function is_model_downloaded {
    grep -qxF "$LOGGING_NAME" "$DOWNLOAD_LOG" && return 0 || return 1
}

# Log the downloaded model
function log_downloaded_model {
    echo "$LOGGING_NAME" >> "$DOWNLOAD_LOG"
}

# Function to check if the model has already been created
function is_model_created {
    # 'ollama list' lists all models
    ollama list | grep -q "$MODEL_NAME" && return 0 || return 1
}

# Check if huggingface-hub is installed, and install it if not
if ! pip show huggingface-hub > /dev/null; then
  echo "Installing huggingface-hub..."
  pip3 install huggingface-hub
else
  echo "huggingface-hub is already installed."
fi

# Check if the model has already been downloaded
if is_model_downloaded; then
    echo "Model $LOGGING_NAME has already been downloaded. Skipping download."
else
    echo "Downloading model $LOGGING_NAME..."
    # Download the model
    huggingface-cli download $MODEL_PATH $GGUF_FILE --local-dir downloads --local-dir-use-symlinks False
    
    # Log the downloaded model
    log_downloaded_model
    echo "Model $LOGGING_NAME downloaded and logged."
fi


# Check if Ollama is installed, and install it if not
if ! command -v ollama &> /dev/null; then
  echo "Installing Ollama..."
  curl -fsSL https://ollama.com/install.sh | sh
else
  echo "Ollama is already installed."
fi

# Check if Ollama is already running
if pgrep -f 'ollama serve' > /dev/null; then
    echo "Ollama is already running. Skipping the start."
else
    echo "Starting Ollama..."
    # Start Ollama in a detached screen
    screen -dmS olla_run bash -c 'ollama serve; exec sh'

    # Wait for Ollama to start
    while true; do
        if pgrep -f 'ollama serve' > /dev/null; then
            echo "Ollama has started."
            break
        else
            echo "Waiting for Ollama to start..."
            sleep 1 # Wait for 1 second before checking again
        fi
    done
fi



# Check if the model has already been created
if is_model_created; then
    echo "Model $MODEL_NAME is already created. Skipping creation."
else
    echo "Creating model $MODEL_NAME..."
    # Create the model in Ollama
    # Prepare Modelfile with the downloaded path
    echo "FROM ./downloads/$GGUF_FILE" > Modelfile
    ollama create $MODEL_NAME -f Modelfile
    echo "Model $MODEL_NAME created."
fi

echo "model name is > $MODEL_NAME"
ollama run $MODEL_NAME
