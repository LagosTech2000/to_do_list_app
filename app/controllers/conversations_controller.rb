class ConversationsController < ApplicationController
  def modal
    @conversation = Conversation.find(params[:id])
    respond_to do |format|
      format.turbo_stream 
      format.html { render :modal }
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:id)
  end
end
