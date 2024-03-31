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

MODEL_PATH="$1"
GGUF_FILE="$2"
MODEL_NAME=$(echo $GGUF_FILE | sed 's/\(.*\)Q4.*/\1/')

# Update and install dependencies
apt-get update
apt-get install -y screen

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


# Start Ollama in a detached screen
screen -dmS olla_run bash -c 'ollama serve; exec sh'

# # Add a sleep delay here for a specified number of seconds, e.g., 5 seconds
# sleep 60

# Check if Ollama has started and echo a message
while true; do
    # Check if Ollama process is running
    if pgrep -f 'ollama serve' > /dev/null; then
        echo "Ollama has started."
        break
    else
        echo "Waiting for Ollama to start..."
        sleep 1 # Wait for 1 second before checking again
    fi
done

# Prepare Modelfile with the downloaded path
echo "FROM ./downloads/$GGUF_FILE" > Modelfile

# Create and run the model in Ollama
ollama create $MODEL_NAME -f Modelfile
echo "model name is > $MODEL_NAME"
ollama run $MODEL_NAME
