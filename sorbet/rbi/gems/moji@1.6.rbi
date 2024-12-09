# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `moji` gem.
# Please instead update this file by running `bin/tapioca gem moji`.


# source://moji//lib/flag_set_maker.rb#4
module FlagSetMaker
  # source://moji//lib/flag_set_maker.rb#104
  def make_flag_set(*args); end
end

# source://moji//lib/flag_set_maker.rb#7
class FlagSetMaker::FlagSet
  # @return [FlagSet] a new instance of FlagSet
  #
  # source://moji//lib/flag_set_maker.rb#9
  def initialize(mod, names, zero = T.unsafe(nil)); end

  # source://moji//lib/flag_set_maker.rb#31
  def inspect(v = T.unsafe(nil)); end

  # source://moji//lib/flag_set_maker.rb#19
  def to_s(v); end

  # source://moji//lib/flag_set_maker.rb#35
  def validate(v); end
end

# source://moji//lib/flag_set_maker.rb#42
class FlagSetMaker::Flags
  extend ::Forwardable

  # @return [Flags] a new instance of Flags
  #
  # source://moji//lib/flag_set_maker.rb#46
  def initialize(v, fs); end

  # source://moji//lib/flag_set_maker.rb#71
  def &(rhs); end

  # source://moji//lib/flag_set_maker.rb#63
  def ==(rhs); end

  # @return [Boolean]
  #
  # source://moji//lib/flag_set_maker.rb#87
  def empty?; end

  # source://moji//lib/flag_set_maker.rb#63
  def eql?(rhs); end

  # source://forwardable/1.3.2/forwardable.rb#229
  def hash(*args, **_arg1, &block); end

  # @return [Boolean]
  #
  # source://moji//lib/flag_set_maker.rb#83
  def include?(flags); end

  # source://moji//lib/flag_set_maker.rb#59
  def inspect; end

  # source://moji//lib/flag_set_maker.rb#51
  def to_i; end

  # source://moji//lib/flag_set_maker.rb#55
  def to_s; end

  # source://moji//lib/flag_set_maker.rb#75
  def |(rhs); end

  # source://moji//lib/flag_set_maker.rb#79
  def ~; end

  protected

  # Returns the value of attribute flag_set.
  #
  # source://moji//lib/flag_set_maker.rb#93
  def flag_set; end

  private

  # source://moji//lib/flag_set_maker.rb#97
  def new_flag(v); end
end