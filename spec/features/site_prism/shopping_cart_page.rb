# frozen_string_literal: true

class ShoppingCartPage < SitePrism::Page
  TITLE = 'Your cart'
  set_url '/cart'

  element :heading, 'h1'
  element :check_out, 'input[name="checkout"]'
  # TODO: item_title be implemented as list of elements to support multiple items in cart
  element :item_title, 'div[class="list-view-item__title"]'
end
