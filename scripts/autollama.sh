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

# Check if huggingface-hub is installed, and install it if not
if ! pip show huggingface-hub > /dev/null; then
  echo "Installing huggingface-hub..."
  pip3 install huggingface-hub
else
  echo "huggingface-hub is already installed."
fi



# Download the model
huggingface-cli download $MODEL_PATH $GGUF_FILE --local-dir downloads --local-dir-use-symlinks False

# Check if Ollama is installed, and install it if not
if ! command -v ollama &> /dev/null; then
  echo "Installing Ollama..."
  curl -fsSL https://ollama.com/install.sh | sh
else
  echo "Ollama is already installed."
fi


# Start Ollama in a detached screen
screen -dmS olla_run bash -c 'ollama serve; exec sh'

# Prepare Modelfile with the downloaded path
echo "FROM ./downloads/$GGUF_FILE" > Modelfile

# Create and run the model in Ollama
ollama create $MODEL_NAME -f Modelfile
echo "model name is > $MODEL_NAME"
ollama run $MODEL_NAME
