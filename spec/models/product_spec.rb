require 'rails_helper'

describe Product do

  #test validation methods
  it 'is valid with product_name and price' do
    expect(build(:product)).to be_valid
  end

  it 'is invalid without product_name' do
    product = build(:product, product_name: nil)
    product.valid?

    expect(product.errors[:product_name]).to include("can't be blank")
  end

  it 'is invalid if product_name has just multiple whitespaces' do
    product = build(:product, product_name: '   ')
    product.valid?

    expect(product.errors[:product_name]).to include("can't be blank")
  end

  it 'is invalid with product_name length less than 5' do
    product = build(:product, product_name: 'a'*4)
    product.valid?

    expect(product.errors[:product_name]).to include("is too short (minimum is 5 characters)")
  end

  it 'is invalid with product_name length greater than 40' do
    product = build(:product, product_name: 'a'*41)
    product.valid?

    expect(product.errors[:product_name]).to include("is too long (maximum is 40 characters)")
  end


  describe 'is invalid with INVALID product_name format' do
    before :each do
      @invalid_name1 = 'product-name'
      @invalid_name2 = 'prod+uct nam\e'
      @invalid_name3 = '?product_name'
      @invalid_name4 = "<script>alert('hello')</script>"
    end

    it 'is invalid because have -' do
      product = build(:product, product_name: @invalid_name1)
      product.valid?

      expect(product.errors[:product_name]).to include('Just accept letters, numbers and spaces')
    end

    it 'is invalid because have \ and +' do
      product = build(:product, product_name: @invalid_name2)
      product.valid?

      expect(product.errors[:product_name]).to include('Just accept letters, numbers and spaces')
    end

    it 'is invalid because have ? and _' do
      product = build(:product, product_name: @invalid_name3)
      product.valid?

      expect(product.errors[:product_name]).to include('Just accept letters, numbers and spaces')
    end

    it 'is invalid because have script tag' do
      product = build(:product, product_name: @invalid_name4)
      product.valid?

      expect(product.errors[:product_name]).to include('Just accept letters, numbers and spaces')
    end
  end

  it 'is invalid with a duplicate product_name' do
    category = create(:category)

    create(:product, category: category, product_name: 'Product 1')
    product = build(:product, category: category, product_name: 'Product 1')
    product.valid?

    expect(product.errors[:product_name]).to include('has already been taken')
  end

  it 'is invalid with a float price number' do
    product = build(:product, price: 11.22)
    product.valid?

    expect(product.errors[:price]).to include('must be an integer')
  end

  it 'is invalid with a price less than 0' do
    product = build(:product, price: -11)
    product.valid?

    expect(product.errors[:price]).to include('must be greater than or equal to 0')
  end

  #test class methods
  describe 'returns a list of results that matches search term' do
    before :each do
      category = create(:category)
      @search_fields = [:product_name, :price, :active]

      @product1 = create(:product, category: category, product_name: 'find product', active: true,  price: 152)
      @product2 = create(:product, category: category, product_name: 'test product', active: false, price: 452)
      @product3 = create(:product, category: category, product_name: 'product new',  active: true,  price: 540)
    end

    it " returns a list that maches search_term 'act' " do
      expect( Product.search('act', @search_fields) ).to eq [@product1, @product2, @product3]
    end
    it " returns a list that maches search_term 'deactive' " do
      expect( Product.search('deactive', @search_fields) ).to eq [@product2]
    end
    it " returns a list that maches search_term 'test' " do
      expect( Product.search('test', @search_fields) ).to eq [@product2]
    end

    it " returns a list that maches search_term 'ne' " do
      expect( Product.search('ne', @search_fields) ).to eq [@product3]
    end
  end

end
