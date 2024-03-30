#!/bin/bash

# Usage: ./script.sh <ModelPath> <GgufFileName>

MODEL_PATH="$1"
GGUF_FILE="$2"
MODEL_NAME=$(echo $GGUF_FILE | sed 's/\(.*\)Q4.*/\1/')

# Update and install dependencies
apt-get update
apt-get install -y screen
pip install huggingface-hub

# Download the model
huggingface-cli download $MODEL_PATH $GGUF_FILE --local-dir downloads --local-dir-use-symlinks False

# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Start Ollama in a detached screen
screen -dmS olla_run bash -c 'ollama serve; exec sh'

# Prepare Modelfile with the downloaded path
echo "FROM ./downloads/$GGUF_FILE" > Modelfile

# Create and run the model in Ollama
ollama create $MODEL_NAME -f Modelfile
echo "model name is > $MODEL_NAME"
ollama run $MODEL_NAME
