# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  [
    {
     name: '太郎（管理者）',
     email: 'admin@ex.com',
     admin: true,
     password: 'pass',
     password_confirmation: 'pass',
    },
    {
      name: '山田 太郎',
      email: 'taro@ex.com',
      admin: false,
      password: 'pass',
      password_confirmation: 'pass',
     },
     {
      name: '鈴木 一郎',
      email: 'ichi@ex.com',
      admin: false,
      password: 'pass',
      password_confirmation: 'pass',
     },
  ]
)

Maker.create!(
  [
    {
     name: 'ホンダ',
     order: '1',
    },
    {
     name: 'スズキ',
     order: '2',
    },
    {
     name: 'ヤマハ',
     order: '3',
    },
    {
     name: 'カワサキ',
     order: '4',
    }
  ]
)

Vehicle.create!(
  [
    {
      name: 'CB400SF',
      maker_id: '1',
      movie: 'AOqqnkmxMcQ'
    },
    {
      name: 'CB1300SF',
      maker_id: '1',
      movie: 'E3vx7cAY4_M,KmEkJvVuElQ'
    },
    {
      name: 'CRF1000L Africa Twin',
      maker_id: '1',
      movie: 'SlxXbHhWcCs'
    },
    {
      name: 'CRF250 RALLY',
      maker_id: '1',
      movie: 'mvEDhVzdx-0'
    },
    {
      name: 'Gold Wing Tour',
      maker_id: '1',
      movie: 'sxo1bJ0kYXY'
    },
    {
      name: 'スーパーカブ110',
      maker_id: '1',
      movie: '',
    },
    {
      name: 'CBR1000RR',
      maker_id: '1',
      movie: '',
    },
    {
      name: 'CB1100',
      maker_id: '1',
      movie: 'on-V--niYzM,I28q8QLy_cQ'
    },
    {
      name: 'SV650',
      maker_id: '2',
      movie: 'qAzrVA1UDXY'
    },
    {
      name: 'GSX1300Rハヤブサ',
      maker_id: '2',
      movie: '',
    },
    {
      name: 'SR400',
      maker_id: '3',
      movie: '',
    },
    {
      name: 'MT-10',
      maker_id: '3',
      movie: '',
    },
    {
      name: 'Ninja H2',
      maker_id: '4',
      movie: '',
    },
    {
      name: 'Z900RS',
      maker_id: '4',
      movie: '',
    }
  ]
)
