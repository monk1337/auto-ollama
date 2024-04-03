import logging
import os
import json
from datetime import datetime
from telegram import Update
from telegram.ext import ApplicationBuilder, ContextTypes, CommandHandler, MessageHandler, filters
import aiohttp

logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)

# Function to ensure the user directory exists or create it
def ensure_user_dir(user_id):
    user_dir = os.path.join("sessions", str(user_id))
    if not os.path.exists(user_dir):
        os.makedirs(user_dir)
    return user_dir

# Function to save message and response in a JSON file
def save_conversation(user_dir, update, response_message):
    conversation_file = os.path.join(user_dir, "conversation.json")
    conversation_data = {
        "timestamp": datetime.now().isoformat(),
        "user_message": update.message.text,
        "bot_response": response_message
    }
    
    # Append to the conversation file if it exists, otherwise create a new one
    if os.path.exists(conversation_file):
        with open(conversation_file, "r+", encoding="utf-8") as file:
            data = json.load(file)
            data.append(conversation_data)
            file.seek(0)
            json.dump(data, file, indent=4, ensure_ascii=False)
    else:
        with open(conversation_file, "w", encoding="utf-8") as file:
            json.dump([conversation_data], file, indent=4, ensure_ascii=False)

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await context.bot.send_message(chat_id=update.effective_chat.id, text="""We appreciate your understanding and cooperation as we continue to improve and refine the model.""")

async def echo(update: Update, context: ContextTypes.DEFAULT_TYPE):
    message_text = update.message.text
    
    # Prepare the data to send
    data = {
        "model": "model_name",
        "stream": False,
        "messages": [{"role": "user", "content": message_text}]
    }
    
    user_id = update.effective_chat.id
    user_dir = ensure_user_dir(user_id)
    
    # Send the data to the external API
    async with aiohttp.ClientSession() as session:
        async with session.post('https://random_url.ngrok.app/api/chat', json=data) as response:
            if response.status == 200:
                response_data = await response.json()
                if 'message' in response_data:
                    await context.bot.send_message(chat_id=update.effective_chat.id, text=response_data['message']['content'])
                    save_conversation(user_dir, update, response_data['message']['content'])
                else:
                    await context.bot.send_message(chat_id=update.effective_chat.id, text="Unexpected response format from API")
            else:
                error_message = await response.text()
                await context.bot.send_message(chat_id=update.effective_chat.id, text=f"API Error: {error_message}")
                save_conversation(user_dir, update, error_message)


if __name__ == '__main__':
    application = ApplicationBuilder().token('telegram token').build()
    
    start_handler = CommandHandler('start', start)
    echo_handler = MessageHandler(filters.TEXT & (~filters.COMMAND), echo)
    
    application.add_handler(start_handler)
    application.add_handler(echo_handler)
    
    application.run_polling()
