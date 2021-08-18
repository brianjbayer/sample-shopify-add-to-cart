# frozen_string_literal: true

#----------------------------------------------------------
# This test is an example of a functional browser-based
# acceptance test against a shopify storefront and its
# associated Shopify Admin API.
#
# Specifically, this test demonstrates that a new product
# can be created in the shopify storefront and added to
# the Shopping Cart.
#
# This sample uses Capybara and its RSpec aliases:
#   - `feature` is an alias for `describe`/`context`
#   - `scenario` is an alias for `it`/`example`
#   - `background` is an alias of `before`
#----------------------------------------------------------

require_relative 'site_prism/product_page'
require_relative 'site_prism/shopping_cart_page'
require_relative '../support/shopify_product_fixture'

feature 'Add New Product to Shopping Cart' do
  # Set the base URL (SitePrism uses Capybara's)
  shop_url = "https://#{ENV['SHOP_NAME']}.myshopify.com"
  Capybara.app_host = shop_url

  let(:product_page) { ProductPage.new }
  let(:shopping_cart_page) { ShoppingCartPage.new }

  scenario 'New Product Can Be Added To Shopping Cart' do
    # GIVEN a new product is created
    # TODO: Refactor this fixture handling
    fixture = ShopifyProductFixture.new
    fixture.create_product
    expect(fixture.product_id).not_to be_nil
    @new_product_id = fixture.product_id
    new_product_title = fixture.product_title
    new_product_handle = fixture.product_handle

    # AND I visit the new product's page in the storefront
    product_page.load(product_handle: new_product_handle)
    expect(product_page.current_url).to end_with(new_product_handle)
    expect(product_page).to be_displayed
    expect(product_page.heading.text).to include(new_product_title)

    # WHEN I add the new product to my shopping cart
    product_page.add_to_cart

    # THEN the new product is in my shopping cart
    expect(shopping_cart_page.current_url).to end_with shopping_cart_page.url
    expect(shopping_cart_page).to be_displayed
    expect(shopping_cart_page.heading.text).to include(ShoppingCartPage::TITLE)
    # TODO: This assumes single item in cart, make items and search through
    expect(shopping_cart_page.item_title.text).to include(new_product_title)
  end

  after(:each) do
    ShopifyProductFixture.new.delete_product(@new_product_id)
  end
end
