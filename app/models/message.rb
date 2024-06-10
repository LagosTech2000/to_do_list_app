class Message < ApplicationRecord

    belongs_to :user
    belongs_to :conversation
    
    scope :unread, -> { where(read: false) }
  
    #after_create_commit :notify_receiver      
    
    # after_create_commit { broadcast_append_to "conversation_#{conversation.id}" }

      
      private
      
      def notify_receiver          
        
        broadcast_append_to "conversation_#{conversation.id}", 
        partial: "conversations/messages", 
        locals: { messages: @messages , conversation: @conversation}
        

        # broadcast_append_to "chat_messages_#{conversation.user.id}", target: "chat_messages", partial: "conversations/messages", locals: { message: self }    
       end
  
    def broadcast_new_message
      
      broadcast_append_to [current_user, :messages]
      
      @user = current_user

      @conversation_ids = @user.conversation_users.pluck(:conversation_id)

      @messages = Message.find_by(conversation_id: @conversation_ids).where.not(user_id: current_user.id)
      
      # Update and broadcast the unread messages count
      unread_count = @messages.count
      Turbo::StreamsChannel.broadcast_replace_to(
        "messages_unread_count_#{current_user.id}",
        target: 'messages_unread_count',
        partial: "messages/unread_count",
        locals: { unread_count: unread_count , messages: @messages }
      )
    end
  end
  