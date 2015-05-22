require 'rails_helper'

describe Category do

  #test model validations
  it 'is valid with a category_name' do
    expect(build(:category)).to be_valid
  end

  it 'is invalid without category_name' do
    category = build(:category, category_name: nil)
    category.valid?

    expect(category.errors[:category_name]).to include("can't be blank")
  end

  it 'is invalid if category_name has just multiple whitespaces' do
    category = build(:category, category_name: '   ')
    category.valid?

    expect(category.errors[:category_name]).to include("can't be blank")
  end

  it 'is invalid with a duplicate category_name' do
    create(:category, category_name: 'Category 1')
    category = build(:category, category_name: 'Category 1')
    category.valid?

    expect(category.errors[:category_name]).to include('has already been taken')
  end

  it 'is invalid with length less than 5' do
    category = build(:category, category_name: 'a'*4)
    category.valid?

    expect(category.errors[:category_name]).to include('is too short (minimum is 5 characters)')
  end

  it 'is invalid with length greater than 40' do
    category = build(:category, category_name: 'a'*41)
    category.valid?

    expect(category.errors[:category_name]).to include('is too long (maximum is 40 characters)')
  end

  it 'is invalid with INVALID category format' do
    invalid_name1 = 'category_1'
    invalid_name2 = '/cate?gory-5'
    invalid_name3 = "<script>alert('hello')</script>"
    invalid_name4 = 'cate\gory + name'

    [invalid_name1, invalid_name2, invalid_name3, invalid_name4].each do |invalid_name|
      category = build(:category, category_name: invalid_name)
      category.valid?

      expect(category.errors[:category_name]).to include('Just accept letters, numbers and spaces')
    end
  end

  #test instance methods
  it 'returns a category name as string when calling to.s' do
    category = build(:category)

    expect(category.to_s).to eq category.category_name
  end

  #test class methods
  it 'returns a list of results that match search' do
    search_fields = [:category_name, :active]
    category1 = create(:category, category_name: 'category 1', active: true)
    category2 = create(:category, category_name: 'new category', active: false)
    category3 = create(:category, category_name: 'not this one', active: true)

    expect( Category.search('act',      search_fields) ).to eq [category1, category2, category3]
    expect( Category.search('deactive', search_fields) ).to eq [category2]
    expect( Category.search('not',      search_fields) ).to eq [category3]
    expect( Category.search('category', search_fields) ).to eq [category1, category2]
  end

end
