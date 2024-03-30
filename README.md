# auto-ollama
run ollama easily


#### Quick run

```sh
wget -O autollama.sh "https://raw.githubusercontent.com/monk1337/auto-ollama/main/autollama.sh" && chmod +x autollama.sh
```

#### Now run the file with whatever model you want from hugginface
for example

```sh
./autollama.sh TheBloke/MistralLite-7B-GGUF mistrallite.Q4_K_M.gguf
```


# AutoGGUF

#### quick tour

convert any hf model into gguf and upload to hf model hub

```sh
wget -O autop.sh "https://raw.githubusercontent.com/monk1337/auto-ollama/main/autogguf.sh" && chmod +x autogguf.sh
```

#### now run the script
Provide MODEL_ID USERNAME TOKEN [QUANTIZATION_METHODS] args, where  QUANTIZATION_METHODS is optional
for example

```sh
./autop.sh aaditya/some_sota_model user_name hf_token
```

