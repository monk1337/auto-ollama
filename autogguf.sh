#!/bin/bash

# Check if less than 3 arguments are provided
if [ $# -lt 3 ]; then
  echo "Usage: $0 MODEL_ID USERNAME TOKEN [QUANTIZATION_METHODS]"
  exit 1
fi

# Assign arguments to variables
MODEL_ID="$1"
USERNAME="$2"
TOKEN="$3"
QUANTIZATION_METHODS="${4:-q4_k_m,q5_k_m}" # Default to "q4_k_m,q5_k_m" if not provided

# Splitting string into an array
IFS=',' read -r -a QUANTIZATION_METHOD_ARRAY <<< "$QUANTIZATION_METHODS"

# Login to Hugging Face
echo "Logging in to Hugging Face..."
huggingface-cli login --token "$TOKEN"

# Extract MODEL_NAME
MODEL_NAME=$(echo "$MODEL_ID" | awk -F'/' '{print $NF}') # Using awk for simplicity

echo "Model ID: $MODEL_ID"
echo "Username: $USERNAME"
echo "Quantization Methods: ${QUANTIZATION_METHOD_ARRAY[@]}"
echo "Model Name: $MODEL_NAME"

# Check if llama.cpp is already installed and skip the build step if it is
if [ ! -d "llama.cpp" ]; then
    echo "llama.cpp not found. Cloning and setting up..."
    git clone https://github.com/ggerganov/llama.cpp
    cd llama.cpp && git pull
    # Build llama.cpp as it's freshly cloned
    make clean && LLAMA_CUBLAS=1 make
    pip3 install -r requirements.txt
    cd ..
else
    echo "llama.cpp found. Assuming it's already built and up to date."
    # Optionally, still update dependencies
    # cd llama.cpp && pip3 install -r requirements.txt && cd ..
fi

# Download model
echo "Downloading the model..."
huggingface-cli download "$MODEL_ID" --local-dir "./${MODEL_NAME}" --local-dir-use-symlinks False --revision main

# Convert to fp16
FP16="${MODEL_NAME}/${MODEL_NAME,,}.fp16.bin"
echo "Converting the model to fp16..."
python3 llama.cpp/convert.py "$MODEL_NAME" --outtype f16 --outfile "$FP16"

# Quantize the model
echo "Quantizing the model..."
for METHOD in "${QUANTIZATION_METHOD_ARRAY[@]}"; do
    QTYPE="${MODEL_NAME}/${MODEL_NAME,,}.${METHOD^^}.gguf"
    ./llama.cpp/quantize "$FP16" "$QTYPE" "$METHOD"
done

# Upload all "*.gguf" and "*.md" files
echo "Uploading files..."
huggingface-cli upload "${USERNAME}/${MODEL_NAME}-GGUF" "./${MODEL_NAME}"

echo "Script completed."
