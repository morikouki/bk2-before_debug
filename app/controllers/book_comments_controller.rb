class BookCommentsController < ApplicationController
	before_action :authenticate_user!

	def create
		book = Book.find(params[:book_id])
	    @book_comment = current_user.book_comments.new(book_comment_params)
	    @book_comment.book_id = book.id
		@book_comment.save
	    flash[:notice] = "You have created book_comment successfully."
	end

	def destroy
		@book_comment = BookComment.find_by(id: params[:id], book_id: params[:book_id])
		BookComment.find_by(id: params[:id], book_id: params[:book_id]).destroy
	end

	private
	def book_comment_params
	  params.require(:book_comment).permit(:comment)
	end
end
