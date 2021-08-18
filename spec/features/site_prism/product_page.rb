# frozen_string_literal: true

class ProductPage < SitePrism::Page
  set_url '/products{/product_handle}'

  element :heading, 'h1'
  element :add_to_cart_button, 'button[name="add"]'

  def add_to_cart
    add_to_cart_button.click
  end
end
