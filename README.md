<div align="center">
<h1>Auto-Ollama</h1>
</div>

Easily run the LLMs locally with a single line of command

# Quick Tour

#### clone the repo
```
https://github.com/monk1337/auto-ollama.git
```


#### Quick run

```sh
./scripts/autollama.sh TheBloke/MistralLite-7B-GGUF mistrallite.Q4_K_M.gguf
                        [model name]                [quantized file name]
```


# AutoGGUF

#### If the quantized model is not available on hugginface?

convert any hf model into gguf and upload to hf model hub


#### now run the script
Provide MODEL_ID USERNAME TOKEN [QUANTIZATION_METHODS] args, where  QUANTIZATION_METHODS is optional
for example

```sh
./scripts/autogguf.sh aaditya/some_sota_model user_name hf_token
```

