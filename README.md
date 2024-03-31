<div align="center">
<h1>Auto-Ollama</h1>
<p>Inference Large Language Models (LLMs) Locally with a Single Command</p>
</div>

## Overview

Auto-Ollama is a toolkit designed to simplify the inference of Large Language Models (LLMs) directly on your local environment. With an emphasis on ease of use and flexibility, Auto-Ollama supports both direct usage and conversion of models into an efficient format for local deployment.

## Getting Started

### Installation

Clone the repository to get started with Auto-Ollama:

### Quick Tour
Running Auto-Ollama
Use the autollama.sh script to quickly inference LLMs. This script requires the model name and the quantized file name as arguments.

```bash
# Deploy Large Language Models (LLMs) locally with Auto-Ollama
# Usage:
# ./scripts/autollama.sh <model name> <quantized file name>


# Example command:
./scripts/autollama.sh TheBloke/MistralLite-7B-GGUF mistrallite.Q4_K_M.gguf
```


### Handling Non-Quantized Models with AutoGGUF
If your desired model is not available in a quantized format suitable for local deployment, Auto-Ollama offers the AutoGGUF utility. This tool can convert any Hugging Face model into the GGUF format and upload it to the Hugging Face model hub.

```bash
# Convert your Hugging Face model to GGUF format for local deployment
# Usage:
# ./scripts/autogguf.sh <MODEL_ID> <USERNAME> <TOKEN> [QUANTIZATION_METHODS (optional)]
#     |                |         |          |              |
#     |                |         |          |              └─➤ Optional: Specify quantization methods (e.g., Q4_K_M)
#     |                |         |          └─➤ Your Hugging Face API Token for authentication
#     |                |         └─➤ Your Hugging Face username
#     |                └─➤ The model ID on Hugging Face (e.g., aaditya/some_sota_model)
#     └─➤ Script to run

# Example command:
./scripts/autogguf.sh aaditya/some_sota_model user_name hf_token
```

## Quantization Recommendations
- Use Q5_K_M for the best performance-resource balance.
- Q4_K_M is a good choice if you need to save memory.
- K_M versions generally perform better than K_S.

### Support and Contributions
For issues, suggestions, or contributions, please open an issue or pull request in the GitHub repository. We welcome contributions from the community to make Auto-Ollama even better!
