class PlayerState
  def self.build_hash(values)
    values.each_with_index.reduce({}) do |hash, (value, i)|
      hash[value] = i if value != :_
      hash
    end.freeze
  end

  def self.build_numeric_hash(values)
    build_hash(values.map { |n| n ? n.to_i : n })
  end

  def self.define_prop(name)
    getter = name.to_s.downcase.to_sym
    ivar_name = "@#{getter}".to_sym
    value_getter = "#{getter}_value".to_sym
    hash = PlayerState.const_get(name)

    attr_accessor(getter)

    define_method(value_getter) do
      value = self.send(getter)

      raise ArgumentError, "invalid #{value_getter} value: #{value.inspect}" unless hash.key?(value)

      hash[value]
    end
  end

  # All constants defined in data order.
  DIFFICULTY_LEVEL = build_hash(%i(veteran rookie _ warrior))

  MONEY_HUNDREDS = {
    0 => 0x5,
    1 => 0x4,
    2 => 0x7,
    3 => 0x6,
    4 => 0x1,
    5 => 0x0,
    6 => 0x3,
    7 => 0x2,
    # 8 unknown
    # 9 unknown
  }.freeze
  MONEY_TENS = {
    0 => 0xa,
    1 => 0xb,
    2 => 0x8,
    3 => 0x9,
    4 => 0xe,
    5 => 0xf,
    6 => 0xc,
    7 => 0xd,
    8 => 0x2,
    9 => 0x3,
  }.freeze
  MONEY_ONES = {
    0 => 0xc,
    1 => 0xd,
    2 => 0xe,
    3 => 0xf,
    4 => 0x8,
    5 => 0x9,
    6 => 0xa,
    7 => 0xb,
    8 => 0x4,
    9 => 0x5,
  }.freeze

  CHARACTER = build_hash(%i(tarquinn jake _ olaf cyberhawk snake katarina ivan))

  DIVISION = build_hash(%i(A B))
  PLANET = {
    0 => 0x6,
    1 => 0x7,
    2 => 0x4,
    3 => 0x5,
    4 => 0x2,
  }

  COLOR = build_hash(%i(red green black blue _ _ yellow _))
  VEHICLE = build_hash(%i(_ _ _ air_blade marauder dirt_devil havac battle_trak))

  ARMOR = build_hash(%i(B A D C))
  SHOCK = build_hash(%i(B A D C))
  TIRE = build_hash(%i(D C B A))
  ENGINE = build_hash(%i(B A D C))

  NITRO = build_numeric_hash(%w(4 5 6 7 _ 1 2 3))
  MINE = build_numeric_hash(%w(4 5 6 7 _ 1 2 3))
  GUN = build_numeric_hash(%w(_ 1 2 3 4 5 6 7))

  constants.each do |name|
    const = PlayerState.const_get(name)
    inverted = "#{name}_LOOKUP".to_sym

    PlayerState.const_set(inverted, const.invert)
    PlayerState.define_prop(name)
  end

  DEFAULT_VALUES = {
    difficulty_level: :warrior,
    money: 100,
    character: :cyberhawk,
    division: :B,
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
  HASH_INITIAL = '1000000110110000'.chars.map { |c| c.to_i(2) }.freeze

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

  def to_s
    encoded.each_slice(4).map(&:join).join(' ')
  end

  private

  def encoded
    data = player_data
    hash = generate_hash(data)
    bits = hash + data

    bits.map(&:to_s).each_slice(5).map do |slice|
      index = slice.join('').to_i(2)

      RNRR_BASE_32[index]
    end
  end

  def generate_hash(data)
    slices = data.each_slice(16).to_a
    tuples = HASH_INITIAL.zip(*slices)

    tuples.map do |tuple|
      tuple.map(&:to_i).inject(&:^)
    end
  end

  def player_data
    CODEC.map do |key, bits|
      method = "#{key}_value"
      value = self.send(method)

      value.to_s(2).rjust(bits, '0').chars.map { |c| c.to_i(2) }
    end.flatten
  end
end
