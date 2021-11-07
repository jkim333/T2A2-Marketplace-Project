# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create(email: "test1@test.com", username: "test1", password: "password", password_confirmation: "password")
user2 = User.create(email: "test2@test.com", username: "test2", password: "password", password_confirmation: "password")

category1 = Category.create(title: "Furniture")
category2 = Category.create(title: "Clothes")
category3 = Category.create(title: "Cars")
category4 = Category.create(title: "Garden")

category1_product1 = Product.create(title: "furniture1", description: "desc", price: 100, stock: 3, listed: true, category_id: category1.id)
category2_product1 = Product.create(title: "clothes1", description: "desc", price: 100, stock: 3, listed: true, category_id: category2.id)
category3_product1 = Product.create(title: "cars1", description: "desc", price: 100, stock: 3, listed: true, category_id: category3.id)
category4_product1 = Product.create(title: "garden1", description: "desc", price: 100, stock: 3, listed: true, category_id: category4.id)

transaction_sale = TransactionHistory.create(sort: "sale", user_id: user1.id)
transaction_sale.transaction_details.create(quantity: 3, product_id: category1_product1.id)
transaction_sale.transaction_details.create(quantity: 3, product_id: category2_product1.id)
transaction_sale.transaction_details.create(quantity: 3, product_id: category3_product1.id)
transaction_sale.transaction_details.create(quantity: 3, product_id: category4_product1.id)

transaction_purchase = TransactionHistory.create(sort: "purchase", user_id: user2.id)
transaction_purchase.transaction_details.create(quantity: 2, product_id: category1_product1.id)
transaction_purchase.transaction_details.create(quantity: 2, product_id: category2_product1.id)
transaction_purchase.transaction_details.create(quantity: 2, product_id: category3_product1.id)
transaction_purchase.transaction_details.create(quantity: 2, product_id: category4_product1.id)