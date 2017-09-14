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
          img = "https://s3-ap-northeast-1.amazonaws.com/yotawaapp/uploads/image/image/62/112b0fdf-4d53-4ac7-aae3-cf6acfee18ea.jpg"
        end

        message = {
          type: 'text',
          text: text
        }
        image = {
          type: "image",
          originalContentUrl: img,
          previewImageUrl: img
        }
        client.reply_message(event['replyToken'], [message, image])
      when Line::Bot::Event::MessageType::Image
        text = "画像のお返し"
        img = "https://s3-ap-northeast-1.amazonaws.com/yotawaapp/uploads/image/image/64/df2339cd-379c-402c-af74-d8adc2443b89.jpg"
        message = {
          type: 'text',
          text: text
        }
        image = {
          type: "image",
          originalContentUrl: img,
          previewImageUrl: img
        }
        client.reply_message(event['replyToken'], [message, image])
      when Line::Bot::Event::MessageType::Sticker
        sticker = {
          type: "sticker",
          packageId: "4",
          stickerId: "630"
        }
        client.reply_message(event['replyToken'], sticker)
      end
    end
  }
  "OK"
end