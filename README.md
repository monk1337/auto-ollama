<div align="center">
<h1>Auto-Ollama</h1>
<p>Inference or Quantize Large Language Models (LLMs) Locally with a Single Command</p>
</div>

## Overview

Auto-Ollama is a toolkit designed to simplify the inference or Quantization of Large Language Models (LLMs) directly on your local environment. With an emphasis on ease of use and flexibility, Auto-Ollama supports both direct usage and conversion of models into an efficient format for local deployment.

## Getting Started

### Installation

Clone the repository to get started with Auto-Ollama:

```bash
git clone https://github.com/monk1337/auto-ollama.git
cd auto-ollama
```

### Quick Tour
Running Auto-Ollama
Use the autollama.sh script to quickly inference LLMs. This script requires the model name and the quantized file name as arguments.

```bash
# Deploy Large Language Models (LLMs) locally with Auto-Ollama
# Usage:
# ./scripts/autollama.sh -m <model path> -g <gguf file name>


# Example command:
./scripts/autollama.sh -m TheBloke/MistralLite-7B-GGUF -g mistrallite.Q4_K_M.gguf
```



### Handling Non-Quantized Models with AutoGGUF
If your desired model is not available in a quantized format suitable for local deployment, Auto-Ollama offers the AutoGGUF utility. This tool can convert any Hugging Face model into the GGUF format and upload it to the Hugging Face model hub.

```bash
# Convert your Hugging Face model to GGUF format for local deployment
# Usage:
# ./scripts/autogguf.sh -m <MODEL_ID> [-u USERNAME] [-t TOKEN] [-q QUANTIZATION_METHODS]


# Example command:
./scripts/autogguf.sh -m unsloth/gemma-2b


# if want to upload the gguf model to hub after the conversion, provide the user and token
./scripts/autogguf.sh -m unsloth/gemma-2b -u user_name -t hf_token
```

## Quantization Recommendations
- **Use Q5_K_M** for the best performance-resource balance.
- **Q4_K_M** is a good choice if you need to save memory.
- **K_M** versions generally perform better than K_S.

### Support and Contributions
For issues, suggestions, or contributions, please open an issue or pull request in the GitHub repository. We welcome contributions from the community to make Auto-Ollama even better!
