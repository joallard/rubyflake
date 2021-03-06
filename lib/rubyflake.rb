class Rubyflake
  # 01/01/2011
  EPOCH = 1293858000

  FLAKE_TIMESTAMP_LENGTH = 41

  FLAKE_RANDOM_MAX = 0b1111111111111111111111111
  FLAKE_TIMESTAMP_SHIFT = 23

  def initialize(epoch = EPOCH)
    @epoch = epoch
  end

  def generate
    # Figure out how many milliseconds have occurred since epoch.
    milliseconds = ((Time.now().to_f - @epoch) * 1000).to_i

    # Generate 23 random bits.
    random_bits = Random.new.rand(0..Rubyflake::FLAKE_RANDOM_MAX)

    # Shift our timestamp over 23 bits to make room for the random bits,
    # and then add the two together.
    (milliseconds << Rubyflake::FLAKE_TIMESTAMP_SHIFT) + random_bits.to_i

  end

  # Extract the time from an ID.
  #
  def time(id)
    Time.at(((id >> Rubyflake::FLAKE_TIMESTAMP_SHIFT) / 1000) + @epoch)
  end

  class << self
    def generate(epoch = Rubyflake::EPOCH)
      Rubyflake.new(epoch).generate()
    end

    def time(id, epoch = Rubyflake::EPOCH)
      Rubyflake.new(epoch).time(id)
    end
  end

end
