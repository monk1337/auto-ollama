<div align="center">
<h1>Auto-Ollama</h1>
<p>Seamlessly Inference Large Language Models (LLMs) Locally with a Single Command</p>
</div>

## Overview

Auto-Ollama is a toolkit designed to simplify the inference of Large Language Models (LLMs) directly on your local environment. With an emphasis on ease of use and flexibility, Auto-Ollama supports a wide range of models, providing tools for both direct usage and conversion of models into an efficient format for local deployment.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:
- Git (for cloning the repository)
- Bash environment (Linux/MacOS terminal or Windows Subsystem for Linux)
- Python 3.9 or newer

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
./scripts/autollama.sh [model name] [quantized file name]
# Example:
./scripts/autollama.sh TheBloke/MistralLite-7B-GGUF mistrallite.Q4_K_M.gguf
```


### Handling Non-Quantized Models with AutoGGUF
If your desired model is not available in a quantized format suitable for local deployment, Auto-Ollama offers the AutoGGUF utility. This tool can convert any Hugging Face model into the GGUF format and upload it to the Hugging Face model hub.

```bash
./scripts/autogguf.sh [MODEL_ID] [USERNAME] [TOKEN] [QUANTIZATION_METHODS (optional)]
# Example:
./scripts/autogguf.sh aaditya/some_sota_model user_name hf_token
```

### Support and Contributions
For issues, suggestions, or contributions, please open an issue or pull request in the GitHub repository. We welcome contributions from the community to make Auto-Ollama even better!
