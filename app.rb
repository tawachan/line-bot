require 'sinatra'
require 'line/bot'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

get '/' do
  "OTYM"
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each { |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        text = event.message['text']
        if text.include?('クリエイティブ') || text.include?('くりえいてぃぶ')
          text = "加速していこう(　･ิω･ิ)"
        end

        if text.include?('OTYM') || text.include?('otym') || text.include?('おたやま')
          text = "OTYMの詳細はこちら → https://we-love-otym.herokuapp.com/index.html"
        end

        message = {
          type: 'text',
          text: text
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Image
        image = {
          type: "image",
          originalContentUrl: "https://s3-ap-northeast-1.amazonaws.com/yotawaapp/uploads/image/image/61/85a15ca2-20a2-4e53-a9ff-9892590046f4.jpg",
          previewImageUrl: "https://s3-ap-northeast-1.amazonaws.com/yotawaapp/uploads/image/image/61/85a15ca2-20a2-4e53-a9ff-9892590046f4.jpg"
        }
        client.reply_message(event['replyToken'], image)
      when Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
      end
    end
  }
  "OK"
end