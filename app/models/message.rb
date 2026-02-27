class Message < ApplicationRecord
  STATUS = { UNSENT: 0, SENT: 1, READ: 2 }

  belongs_to :room
  belongs_to :sender, class_name: "User"
  has_many_attached :attachments
  before_save :extract_attachments_metadata, if: -> { attachments.attached? }


  # ordinary messages are messages between general users
  enum :message_type, { ordinary: 1, system: 2 }

  private

  def extract_attachments_metadata
    metadata_array = attachments.map do |attachment|
      {
        blob_id: attachment.blob_id,
        filename: attachment.filename.to_s,
        mime_type: attachment.content_type,
        file_size: attachment.byte_size
      }
    end

    self.attachment_data = metadata_array
  end
end
