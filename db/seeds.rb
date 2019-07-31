# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

# => Users
alex = User.create!(name: "Alex Hennel", email: "straw@gmail.com", password: "fish", role: 0)
berry = User.create!(name: "Berry Blue", email: "blue@gmail.com", password: "bear", role: 1, merchant_id: megan.id)
jeff = User.create!(name: "Jeff Casimir", email: "jeff@gmail.com", password: "jeff", role: 2)

# => addresses
alex_work = Address.create!(nickname: "work", address: "123 Straw Lane", city: "Straw City", state: "CO", zip: 12345, user_id: alex.id)
berry_home = Address.create!(nickname: "home", address: "345 Blue Lane", city: "Blue City", state: "CA", zip: 56789, user_id: berry.id)
jeff_home = Address.create!(nickname: "home", address: "345 Blue Lane", city: "Blue City", state: "CA", zip: 56789, user_id: jeff.id)

# => coupons
hippo_coupon = brian.coupons.create!(name: 'Mega Saver', value: 5.00, merchant_id:brian.id, enabled: true)
hippo_coupon_2 = brian.coupons.create!(name: 'Save Big', value: 10.00, merchant_id: brian.id, enabled: true)
giant_coupon = megan.coupons.create!(name: 'Giant Discount', value: 5.00, merchant_id:megan.id, enabled: true)
giant_coupon_2 = megan.coupons.create!(name: 'Giant Savings', value: 10.00, merchant_id: megan.id, enabled: true)

# => orders
order_1 = alex.orders.create!(address_id: alex_work.id)
order_2 = berry.orders.create!(address_id: berry_home.id)
