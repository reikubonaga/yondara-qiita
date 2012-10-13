class BooksController < ApplicationController
  #authorize_resource
  #skip_authorize_resource only: [:signin]

  def index
    @res = get_amazon_products(params[:q])
  end

  def new
    @item = get_amazon_product(params[:q], params[:item])
  end

  def create
    if !current_user
      redirect_to books_signin_path
      return
    end
    book = Book.new params[:book]
    item = get_amazon_product_detail(params[:q], book.amazon_item_id)
    book.title = item.get_element('ItemAttributes').get("Title")
    book.amazon_url = item.get('DetailPageURL')
    book.user_id = current_user.id
    book.save

    qiita = Qiita.new token: current_user.qiita_token
    item = qiita.post_item title: book.qiita_title, body: book.qiita_tips, tags: [{ name: params[:q] }], private: false

    redirect_to book_path(book.id)
  end

  def show
    @book = Book.find(params[:id])
  end

  def signin
  end

  private
  def get_amazon_products(query)
    if query
      res = Rails.cache.read(query)
      if not res
        res = Amazon::Ecs.item_search(query, :country => 'jp', :ResponseGroup => "Images")
        Rails.cache.write(query, res, :timeToLive => 1.hours)
        res_detail = Amazon::Ecs.item_search(query, :country => 'jp')
        Rails.cache.write(query + "_detail", res_detail, :timeToLive => 1.hours)
      end
      return res
    end
    return false
  end

  def get_amazon_product(query, id)
    res = get_amazon_products(params[:q])

    return_item = false
    res.items.each do |item|
      if item.get("ASIN") == id
        return_item = item
        break
      end
    end

    return return_item
  end

  def get_amazon_product_details(query)
    if query
      res = Rails.cache.read(query + "_detail")
      if not res
        res = Amazon::Ecs.item_search(query, :country => 'jp')
        Rails.cache.write(query, res, :timeToLive => 1.hours)
      end
      return res
    end
    return false
  end

  def get_amazon_product_detail(query, id)
    res = get_amazon_product_details(params[:q])

    return_item = false
    res.items.each do |item|
      if item.get("ASIN") == id
        return_item = item
        break
      end
    end

    return return_item
  end
end
