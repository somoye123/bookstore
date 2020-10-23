class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :set_books, only: [:index]
  skip_before_action :verify_authenticity_token
  # before_action :restrict_access
  def index 
    render json: @books
  end
  def show
      render json: @book
  end
  def new
      @book = Book.new
    end
    def edit
    end
    def create
      @book = Book.new(book_params)
      if @book.save
        render json: @book, status: :created
      else
        render json: @book.errors, status: :unprocessable_entity
      end
    end
    def update
      respond_to do |format|
        if @book.update(book_params)
          format.json { render :show, status: :ok, location: @book }
        else
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end
    def destroy
      if @book.destroy
        render json: {}
      else
        render json: @book.errors, status: :unprocessable_entity
      end
    end
  private 
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
    end
  end
  def set_book
      @book = Book.find(params[:id])
  end
  def set_books
      @books = Book.all
  end
  def book_params
      params.require(:book).permit(:title, :category, :access_token)
  end
end