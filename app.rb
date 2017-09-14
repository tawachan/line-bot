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
      input = event.message['text']
      messages = []
      case event.type
      when Line::Bot::Event::MessageType::Text
        if input.include?('クリエイティブ') || input.include?('くりえいてぃぶ')
          text = "加速していこう(　･ิω･ิ)"
          img = "https://s3-ap-northeast-1.amazonaws.com/yotawaapp/uploads/image/image/65/fccb8c38-56ec-4424-acc0-db65beff8bda.jpg"
          messages << {
            type: 'text',
            text: text
          }
          messages << {
            type: "image",
            originalContentUrl: img,
            previewImageUrl: img
          }
        end
        if input.include?('OTYM') || input.include?('otym') || input.include?('おたやま')
          text = "OTYMの詳細はこちら → https://we-love-otym.herokuapp.com/index.html"
          img = "https://s3-ap-northeast-1.amazonaws.com/yotawaapp/uploads/image/image/62/112b0fdf-4d53-4ac7-aae3-cf6acfee18ea.jpg"
          messages << {
            type: 'text',
            text: text
          }
          messages << {
            type: "image",
            originalContentUrl: img,
            previewImageUrl: img
          }
        end

        if input.include?('石原さとみ')
          text = "石原さとみ(　･ิω･ิ)"
          img = "https://s3-ap-northeast-1.amazonaws.com/yotawaapp/uploads/image/image/61/85a15ca2-20a2-4e53-a9ff-9892590046f4.jpg"
          messages << {
            type: 'text',
            text: text
          }
          messages << {
            type: "image",
            originalContentUrl: img,
            previewImageUrl: img
          }
        end

        if input.include?('?') || input.include?('？')
          text = "おけやま！"
          messages << {
            type: 'text',
            text: text
          }
        end
        if input.include?('おつやま')
          text = "おつやま〜"
          messages << {
            type: 'text',
            text: text
          }
        end

        if input.include?('てち')
          text = "てち"
          imgs = [
            "https://s3-ap-northeast-1.amazonaws.com/yotawaapp/uploads/image/image/67/75dbc927-42a3-4bc5-b41a-79555a8ab848.jpg",
            "https://s3-ap-northeast-1.amazonaws.com/yotawaapp/uploads/image/image/69/c7436979-8055-4f32-af2e-eae8eaeb155d.jpg",
            "https://s3-ap-northeast-1.amazonaws.com/yotawaapp/uploads/image/image/66/be6b7b2b-de98-40df-ab5a-fd164b72ba91.jpg"
          ]

          img = imgs[Random.new.rand(imgs.length)]

          messages << {
            type: 'text',
            text: text
          }
          messages << {
            type: "image",
            originalContentUrl: img,
            previewImageUrl: img
          }
        end

        if messages.empty?
          messages << {
            type: 'text',
            text: input
          }
        end
      when Line::Bot::Event::MessageType::Image
        text = "画像のお返し"
        img = "https://s3-ap-northeast-1.amazonaws.com/yotawaapp/uploads/image/image/64/df2339cd-379c-402c-af74-d8adc2443b89.jpg"

        messages << {
          type: 'text',
          text: text
        }
        messages << {
          type: "image",
          originalContentUrl: img,
          previewImageUrl: img
        }
      when Line::Bot::Event::MessageType::Sticker
        messages << {
          type: "sticker",
          packageId: "4",
          stickerId: "630"
        }
      end
      client.reply_message(event['replyToken'], messages)
    end
  }
  "OK"
end