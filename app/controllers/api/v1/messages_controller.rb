class Api::V1::MessagesController < ApplicationController
    def create
        @room = Room.find(params[:room_id])
        @message = Message.new(
            room_id: params[:room_id],
            sender_id: current_user.id,
            content: params[:content],
            attachments: params[:attachments],
            status_data: @room.participants.map do |participant|
                if participant.user_id != current_user.id
                    {
                        participant_id: participant.id,
                        user_id: participant.user_id,
                        status: Message::STATUS[:SENT]
                    }
                end
            end
        )
        authorize @message, :create?, policy_class: Api::V1::MessagePolicy
        if @message.save
            payload = attach(@message)
            ActionCable.server.broadcast("Room_#{@message.room_id}", payload)
            succeed(message: I18n.t("success.message_sent"), data: payload)
        else
            error(message: I18n.t("errors.message_sent"), status: :unprocessable_entity)
        end
    end


    def show_by_room
        @messages = Message.where(room_id: params[:room_id])
        authorize @messages, :show_by_room?, policy_class: Api::V1::MessagePolicy
        if !@message
            error(message: I18n.t("errors.resource_not_found", resource: "Message"), status: :not_found)
        end
        payload = []
        @messages.each do |message|
            payload << attach(message)
        end
        succeed(message: I18n.t("success.messages_retrieved"), data: { messages: payload })
    end

    def read
        @message = Message.find(params[:message_id])
        authorize @message, :read?, policy_class: Api::V1::MessagePolicy
        if !@message
            error(message: I18n.t("errors.resource_not_found", resource: "Message"), status: :not_found)
        end
        @message.update(status: Message::STATUS[:READ])
        payload = attach(@message)
        succeed(message: I18n.t("success.message_read"), data: { message: payload })
    end

    private

    def attach(message)
        payload_attachments = []
        if message.attachments.attached?
            payload_attachments = message.attachments.map do |attachment|
                saved_metadata = message.attachment_data&.find { |data| data["blob_id"] == attachment.blob_id } || {}
                saved_metadata.merge(url: rails_blob_url(attachment, host: request.base_url))
            end
        end
        message.as_json(except: :attachment_data).merge(
            attachments: payload_attachments
        )
    end
end
