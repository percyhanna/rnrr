class PlayerState
  def self.build_hash(values)
    values.each_with_index.reduce({}) { |hash, (value, i)| hash[i] = value if value != :_; hash }.freeze
  end

  def self.define_prop(name)
    getter = name.to_s.downcase.to_sym
    value_getter = "#{getter}_value"
    setter_name = "#{getter}="
    hash = PlayerState.const_get("#{name}_LOOKUP")

    define_method(getter) do
      @props[getter]
    end

    define_method(value_getter) do
      hash[@props[getter]]
    end

    define_method(setter_name) do |value|
      raise ArgumentError, "invalid #{getter} value: #{value.inspect}" unless hash.key?(value)

      @props[getter] = value
    end
  end

  # All constants defined in data order.
  DIFFICULTY_LEVEL = build_hash(%i(veteran rookie _ warrior))

  MONEY_HUNDREDS = {
    0x5 => 0,
    0x4 => 1,
    0x7 => 2,
    0x6 => 3,
    0x1 => 4,
    0x0 => 5,
    0x3 => 6,
    0x2 => 7,
    # 8 unknown
    # 9 unknown
  }.freeze
  MONEY_TENS = {
    0xa => 0,
    0xb => 1,
    0x8 => 2,
    0x9 => 3,
    0xe => 4,
    0xf => 5,
    0xc => 6,
    0xd => 7,
    0x2 => 8,
    0x3 => 9,
  }.freeze
  MONEY_ONES = {
    0xc => 0,
    0xd => 1,
    0xe => 2,
    0xf => 3,
    0x8 => 4,
    0x9 => 5,
    0xa => 6,
    0xb => 7,
    0x4 => 8,
    0x5 => 9,
  }.freeze

  CHARACTER = build_hash(%i(tarquinn jake _ _ cyberhawk snake katarina ivan))

  DIVISION = build_hash(%i(A B))
  PLANET = {
    0x6 => 0,
    0x7 => 1,
    0x4 => 2,
    0x5 => 3,
    0x2 => 4,
  }

  COLOR = build_hash(%i(red green black blue _ _ yellow _))
  VEHICLE = build_hash(%i(_ _ _ air_blade marauder dirt_devil havac battle_trak))

  ARMOR = build_hash(%i(B A D C))
  SHOCK = build_hash(%i(B A D C))
  TIRE = build_hash(%i(D C B A))
  ENGINE = build_hash(%i(B A D C))

  NITRO = build_hash(%w(4 5 6 7 _ 1 2 3).map(&:to_i))
  MINE = build_hash(%w(4 5 6 7 _ 1 2 3).map(&:to_i))
  GUN = build_hash(%w(_ 1 2 3 4 5 6 7).map(&:to_i))

  constants.each do |name|
    const = PlayerState.const_get(name)
    inverted = "#{name}_LOOKUP".to_sym

    PlayerState.const_set(inverted, const.invert)
    PlayerState.define_prop(name)
  end

  DEFAULT_VALUES = {
    difficulty_level: :rookie,
    money: 100,
    character: :snake,
    division: :A,
    planet: 0,
    color: :red,
    vehicle: :havac,
    armor: :D,
    shock: :D,
    tire: :D,
    engine: :D,
    nitro: 7,
    mine: 7,
    gun: 7,
  }.freeze

  CODEC = {
    hash: 16,
    difficulty_level: 2,
    money_hundreds: 4,
    money_tens: 4,
    money_ones: 4,
    character: 3,
    division: 1,
    planet: 3,
    color: 3,
    vehicle: 3,
    armor: 2,
    shock: 2,
    tire: 2,
    engine: 2,
    nitro: 3,
    mine: 3,
    gun: 3,
  }.freeze

  RNRR_BASE_32 = %w(B C D F G H J K L M N P Q R S T V W X Y Z 0 1 2 3 4 5 6 7 8 9 !).freeze

  def initialize
    @props = {}

    DEFAULT_VALUES.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def money
    money_hundreds * 100 + money_tens * 10 + money_ones
  end

  def money=(dollars)
    self.money_ones = dollars % 10
    self.money_tens = dollars % 100 / 10
    self.money_hundreds = dollars % 1_000 / 100
  end

  def hash_value
    0
  end

  def to_s
    binary = CODEC.map do |key, bits|
      method = "#{key}_value"
      value = self.send(method)

      value.to_s(2).rjust(bits, '0')
    end.join('')

    binary.chars.each_slice(5).map do |slice|
      RNRR_BASE_32[slice.join('').to_i(2)]
    end.each_slice(4).map(&:join).join(' ')
  end
end

p = PlayerState.new

p.difficulty_level = :warrior
puts p.difficulty_level

p.money = 123
puts p.money

puts p.inspect
puts p.to_s
