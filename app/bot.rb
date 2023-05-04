require_relative 'token'
require 'telegram/bot'
require 'openai'

# Установка ключа API OpenAI
#OpenAI.api_key = @gpt_token
client = OpenAI::Client.new(access_token: @gpt_token)


# Инициализация телеграм-бота
Telegram::Bot::Client.run(@token) do |bot|
  bot.listen do |message|
    # Отправка сообщения на сервера OpenAI для получения ответа
    response = client.chat(
      parameters: {
          model: "gpt-3.5-turbo", # Required.
          messages: message.text, # Required.
          temperature: 0.7,
      })
    # Отправка ответа пользователю
    bot.api.send_message(chat_id: message.chat.id, text: response.dig("choices", 0, "message", "content"))
  end
end
