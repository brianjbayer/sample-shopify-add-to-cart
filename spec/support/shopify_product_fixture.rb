# frozen_string_literal: true

require 'shopify_api'

# Shopify Product Admin/Create Product Fixture
class ShopifyProductFixture
  attr_reader :shop_url, :product_id, :product_handle, :product_title, :shop_admin_version

  def initialize
    @shop_url = "https://#{ENV['SHOP_NAME']}.myshopify.com"
    @shop_admin_url = "https://#{ENV['ADMIN_API_KEY']}:#{ENV['ADMIN_API_SECRET']}@#{ENV['SHOP_NAME']}.myshopify.com"
    @shop_admin_version = ENV['ADMIN_API_VERSION']

    @product_id = nil
    @product_handle = nil
    @product_title = nil
  end

  def delete_product(product_id)
    ShopifyAPI::Base.site = @shop_admin_url
    ShopifyAPI::Base.api_version = @shop_admin_version

    product = ShopifyAPI::Product.find(product_id)
    product.destroy
    @product_id = nil
    @product_handle = nil
    @product_title = nil
  end

  def create_product
    ShopifyAPI::Base.site = @shop_admin_url
    ShopifyAPI::Base.api_version = @shop_admin_version

    new_product = ShopifyAPI::Product.new

    new_product.title = 'DELETE ME'
    new_product.product_type = 'Automated Test Product'
    new_product.vendor = 'Automated Test Inc.'
    new_product.body_html = '<strong>This is an automated test product!</strong>'
    new_product.save

    @product_id = new_product.id
    @product_handle = new_product.handle
    @product_title = new_product.title
  end
end
