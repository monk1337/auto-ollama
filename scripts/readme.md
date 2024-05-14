# RUN AUTO-OLLAMA USING GRADIO UI

## INSTALLATION
```bash
git clone https://github.com/monk1337/auto-ollama.git
cd auto-ollama
pip install ollama
pip install gradio
pip install subprocess
snap install ngrok
ngrok config add-authtoken <auth-token>
```
**NOTE** : To setup ngrok account use - https://ngrok.com/, To install ollama application use - https://ollama.com/download

## EXECUTION
```bash
python3 scripts/gradio_ui.py
```

1. In the **Model Installation** tab enter the model model path and GGUF file name, eg : https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/tree/main - model path(microsoft/Phi-3-mini-4k-instruct-gguf), GGUF file name(Phi-3-mini-4k-instruct-q4.gguf - Inside Files and versions in hugging face)
2. In the **Chat Interface** tab, if the model is downloaded post execution of gradio_ui.py entering GGUF file name is not needed, if not then GGUF file name needs to be entered.

## SAMPLE INPUT
**Enter GGUF file name - Optional**
```
Phi-3-mini-4k-instruct-q4.gguf
```

**System input**
```
you are a chef
```

**User Input - Query**
```
how to prepare soup
```

## EXPOSE GRADIO ENDPOINT USING NGROK
One gradio app is run you would see an endpoint displayed in terminal along with port eg: 7869
Open **new terminal** and run 
```bash
ngrok http 7869
```
You will find an url ending with **.ngrok-free.app**, you can use this URL in any other device, ngrok enables developers to expose a local development server to the internet.

### Support and Contributions
For issues, suggestions, or contributions, please open an issue or pull request in the GitHub repository. We welcome contributions from the community to make Auto-Ollama even better!






