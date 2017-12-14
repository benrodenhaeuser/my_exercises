# requires client to implement
# :update, :retrieve, :insert, :delete, :each

module SetLike
  include Enumerable

  def keys
    each.map(&:first)
  end

  def values
    each.map(&:last)
  end

  def size
    values.sum
  end

  def include?(elem)
    keys.include?(elem)
  end

  def remove(key)
    self[key] = 0
  end

  def to_s
    '{' + map { |key, val| "(#{key}: #{val})" }.join(', ') + '}'
  end

  def inspect
    "#<#{self.class}: " +
      map { |key, val| "(#{key.inspect}: #{val})" }.join(', ') + ">"
  end

  def flatten(flat = self.class.new)
    each.with_object(flat) do |(key, val), _|
      if key.instance_of?(self.class)
        key.flatten(flat)
      else
        flat.insert(key, val)
      end
    end
  end

  def hash
    each.map(&:hash).sum
  end

  def dup
    duplicate = self.class.new
    duplicate.instance_variable_set(:@hash, @hash.dup)
    duplicate
  end

  # operations with other

  def sum!(other)
    do_with(other) { |key, val| insert(key, val) }
    self
  end

  def sum(other)
    dup.sum!(other)
  end
  alias + sum

  def union!(other)
    do_with(other) do |key, _|
      self[key] = [self[key], other[key]].max
    end
    self
  end

  def union(other)
    dup.union!(other)
  end
  alias | union

  def difference!(other)
    do_with(other) do |key, _|
      self[key] = [0, self[key] - other[key]].max
    end
    self
  end

  def difference(other)
    dup.difference!(other)
  end
  alias - difference

  def intersection!(other)
    each do |key, _|
      self[key] = intersection(other)[key]
    end
  end

  # TODO: improve on this
  def intersection(other)
    do_with(other).with_object(self.class.new) do |(key, _), the_intersection|
      the_intersection[key] = [self[key], other[key]].min
    end
  end
  alias & intersection

  def do_with(other)
    raise ArgumentError unless other.instance_of?(self.class)

    return other.each unless block_given?
    other.each { |key, val| yield([key, val]) }
  end
  private :do_with

  # comparison with other

  def subset?(other)
    return false unless other.instance_of?(self.class)

    all? do |key, _|
      self[key] <= other[key]
    end
  end
  alias <= subset?

  def proper_subset?(other)
    subset?(other) && self != other
  end
  alias < subset?

  def superset?(other)
    other.subset?(self)
  end
  alias >= superset?

  def proper_superset?(other)
    superset?(other) && self != other
  end
  alias > superset?

  def equivalent?(other)
    subset?(other) && other.subset?(self)
  end
  alias == equivalent?
  alias eql? equivalent?
end
