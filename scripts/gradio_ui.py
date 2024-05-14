import re
import os
import ollama
import gradio as gr
import subprocess


def run_starter_shell_script(model_path, gguf_file_name):
    """Run autollama.sh shell script to download and server LLM

    Args:
        model_path (string): Hugging face model path.
        gguf_file_name (string): GGUF format model file name.

    Returns:
        None
    """
    script_path = [os.path.join(os.getcwd(), 'scripts', 'autollama.sh')]
    args = ['-m', f'{model_path}', '-g', f'{gguf_file_name}']
    command = script_path + args
    print("Model download in progress ...")

    # Run the shell script without waiting for it to complete
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    pattern = r"(.*)\.Q4.*"
    replacement = r"\1"

    global model_name
    model_name = re.sub(pattern, replacement, gguf_file_name)
    print("Model name : ", model_name)


def chatbot_response(input_model_nm, system_input, user_query):
    """Infer LLM using a chat like I/P and O/P.

    Args:
        system_input (string): LLM system I/P.
        user_query (string): Question being asked to LLM.

    Returns:
        String: Completion/Response of LLM.
    """
    if input_model_nm is not None or input_model_nm != "":
        pattern = r"(.*)\.Q4.*"
        replacement = r"\1"
        model_name = re.sub(pattern, replacement, input_model_nm)

    print("Model Inference In Progress ... ", model_name)
    response = ollama.chat(
    model=model_name,
    messages=[
        {'role': 'system', 'content': system_input},
        {'role': 'user', 'content': user_query} 
            ],
    )
    print("Response Received ..")
    return response['message']['content']




model_name = ""
# Model Installation Interface
model_installation_interface = gr.Interface(
    fn=run_starter_shell_script,
    inputs=[gr.Textbox(label="Hugging face model path"), gr.Textbox(label="GGUF format - file name")],
    outputs=None,
    title="Auto-Ollama UI",
    description="Download you desired LLM available in GGUF format. NOTE : PREREQUISITE - Download Ollama - https://ollama.com/download",
)

# Chat Interface
chat_interface = gr.Interface(
    fn=chatbot_response,
    inputs=[gr.Textbox(label="Enter GGUF file name - Optional ", placeholder="If model is downloaded just now leave empty else if using an already downloaded model enter GGUF file name"), 
            gr.Textbox(label="System input", placeholder="Ensure model is downloaded, check inside downloads/"), 
            gr.Textbox(label="User Input - Query", placeholder="Ensure model is downloaded, check inside downloads/")],
    outputs=gr.Textbox(label="Response"),
    title="Auto-Ollama UI",
    description="Interact with your local LLM"
)

tabbed_interface = gr.TabbedInterface(
    interface_list=[model_installation_interface, chat_interface],
    tab_names=["Model Installation", "Chat Inference"]
)

# Run the interface
tabbed_interface.launch()
