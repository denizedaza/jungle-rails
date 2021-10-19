require 'rails_helper'

RSpec.describe Product, type: :model do

  let(:category) {
    Category.create(name: "testCategory")
  }
  subject(:product) {
    category.products.create(
      name: "testProduct",
      price_cents: 999,
      quantity: 12
    )
  }
  describe 'Validations' do 
    it 'is valid with all fields valid' do 
      expect(product).to be_valid
      expect(product.errors.full_messages).to be_empty
    end

    it 'is not valid without a name' do 
      product.name = nil
      expect(product).to_not be_valid
      expect(product).errors.full_messages.to include "Name can't be blank"
    end

    it 'is not valid without a price' do
      product.price_cents = nil
      expect(product).to_not be_valid
      expect(product).errors.full_messages.to include "Price can't be blank"
    end

    it 'is not valid without a quantity' do
      product.quantity = nil
      expect(product).to_not be_valid
      expect(product).errors.full_messages.to include "Quantity can't be blank"
    end

    it 'is not valid without a category' do 
      newProduct = Product.create(
        name: "testyMcTestProduct",
        price_cents: 1888,
        quantity: 42
      )
      expect(newProduct).to_not be_valid
      expect(product).errors.full_messages.to include "Category can't be blank"
    end

  end
end
