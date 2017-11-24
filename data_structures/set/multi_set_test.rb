require 'minitest/autorun'
require_relative 'multi_set'
require_relative 'my_set'

class MultiSetTest < Minitest::Test

  # basic setup

  def test_initialize_and_to_a
    multi_set = MultiSet[1, 2, 3, 3]
    expected = [1, 2, 3, 3]
    assert_equal(expected, multi_set.to_a)
  end

  def test_size
    multi_set = MultiSet[1, 2, 3, 3]
    expected = 4
    assert_equal(expected, multi_set.size)
  end

  def test_include
    multi_set = MultiSet[1, 2, 3, 4]
    assert_includes(multi_set, 2)
  end

  def test_add_element
    multi_set = MultiSet[1, 2, 3, 3]
    multi_set.add(5)
    expected = [1, 2, 3, 3, 5]
    assert_equal(expected, multi_set.to_a)
  end

  def test_flatten
    set1 = MultiSet[1, 2, 3]
    set2 = MultiSet[set1, 4, 5]
    set3 = MultiSet[set2, 6, 7]
    expected = [1, 2, 3, 4, 5, 6, 7]
    assert_equal(expected, set3.flatten.to_a)
  end

  def test_flatten_with_elements_appearing_multiple_times
    set1 = MultiSet[1, 2, 3, 3]
    set2 = MultiSet[set1, 4, 5]
    set3 = MultiSet[set2, 6, 6, 7]
    expected = [1, 2, 3, 3, 4, 5, 6, 6, 7]
    assert_equal(expected, set3.flatten.to_a)
  end

  # operations with enum argument

  def test_sum!
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[2, 4]
    multi_set1.sum!(multi_set2)
    expected = [1, 2, 2, 3, 3, 4]
    assert_equal(expected, multi_set1.to_a)
  end

  def test_union!
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[2, 4]
    multi_set1.union!(multi_set2)
    expected = [1, 2, 3, 3, 4]
    assert_equal(expected, multi_set1.to_a)
  end

  def test_difference!
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[3, 3, 3]
    expected = [1, 2]
    assert_equal(expected, (multi_set1.difference(multi_set2)).to_a)
  end

  def test_sum
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[2, 4]
    summed_set = multi_set1.sum(multi_set2)
    expected = [1, 2, 2, 3, 3, 4]
    assert_equal(expected, summed_set.to_a)
  end

  def test_union
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[2, 4]
    the_union = multi_set1.union(multi_set2)
    expected = [1, 2, 3, 3, 4]
    assert_equal(expected, the_union.to_a)
  end

  def test_intersection
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[2, 4, 3, 3, 3]
    the_intersection = multi_set1.intersection(multi_set2)
    expected = [2, 3, 3]
    assert_equal(expected, the_intersection.to_a)
  end

  def test_difference
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[3, 3, 3]
    the_difference = multi_set1.difference(multi_set2)
    expected = [1, 2]
    assert_equal(expected, the_difference.to_a)
  end

  # predicates with multiset argument

  def test_subset
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[1, 2, 3, 3, 4, 5]
    multi_set3 = MultiSet[1, 2, 3]
    assert(multi_set1.subset?(multi_set2))
    refute(multi_set1.subset?(multi_set3))
  end

  def test_proper_subset
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[1, 2, 3, 3, 4, 5]
    multi_set3 = MultiSet[1, 2, 3]
    assert(multi_set1.proper_subset?(multi_set2))
    refute(multi_set1.proper_subset?(multi_set3))
  end

  def test_superset
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[1, 2, 3, 3, 4, 5]
    multi_set3 = MultiSet[1, 2, 3]
    assert(multi_set2.superset?(multi_set1))
    refute(multi_set3.superset?(multi_set1))
  end

  def test_proper_superset
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[1, 2, 3, 3, 4, 5]
    multi_set3 = MultiSet[1, 2, 3]
    assert(multi_set2.proper_superset?(multi_set1))
    refute(multi_set3.proper_superset?(multi_set3))
  end

  def test_equality
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[1, 2, 3, 3]
    multi_set3 = MultiSet[1, 2, 3]
    assert(multi_set1 == multi_set2)
    refute(multi_set1 == multi_set3)
  end

  def test_equality_with_nested_sets_for_multisets
    set1 = MultiSet.new([0, 1, 2])
    set2 = MultiSet.new([1, 2, 0])
    set3 = MultiSet.new([set1, 1, 2])
    set4 = MultiSet.new([set2, 1, 2])
    assert(set1 == set2)
    assert(set3 == set4)
  end

  # enum methods (each, select, map)

  def test_each_with_block
    multi_set = MultiSet[1, 2, 3, 3]
    array = []
    multi_set.each { |elem| array << elem }
    assert_equal(array, [1, 2, 3, 3])
  end

  def test_each_without_block
    MultiSet.new.each.instance_of?(Enumerator)
  end

  def test_map
    # todo
  end

  def test_select
    # todo
  end
end

# todo: following tests might need to be adapted.

class SetTest < Minitest::Test
  def test_elements_are_not_counted
    array = [1, 2, 3, 4, 4]
    set = Set[*array]
    expected = array.uniq
    assert_equal(expected, set.to_a)
  end

  def test_sum_is_union
    array1 = Set[1, 2, 3]
    array2 = Set[1, 2, 3]
    array1.sum!(array2)
    expected = [1, 2, 3]
    assert_equal(expected, array1.to_a)
  end

  def test_adding_element_already_present_does_not_affect_size
    set = Set.new([0, 1, 2])
    set.add(1)
    assert_equal(3, set.size)
    assert_equal([0, 1, 2], set.to_a)
  end

  def test_equality_is_order_independent
    set1 = Set.new([0, 1, 2])
    set2 = Set.new([1, 2, 0])
    assert(set1 == set2)
  end

  def test_equality_with_nested_sets
    set1 = Set.new([0, 1, 2])
    set2 = Set.new([1, 2, 0])
    set3 = Set.new([set1, 1, 2])
    set4 = Set.new([1, set2, 2])
    p set3
    p set4
    assert(set1 == set2)
    assert(set3 == set4)
  end

  def test_to_s
    skip
    set1 = Set[1, 2, 3]
    set2 = Set[set1, 4, 5]
    set3 = Set[set2, 6, 7]
    set4 = Set[set3, 1]
    set5 = Set[set4, 4, set1]
    expected = '{{{{{1, 2, 3}, 4, 5}, 6, 7}, 1}, 4, {1, 2, 3}}'
    assert_equal(expected, set5.to_s)
  end

  def test_proper_superset_is_not_equal
    skip
    set1 = Set.new([0, 1, 2])
    set2 = Set.new([0, 1, 2, 3])
    refute(set1 == set2)
  end

  def test_add_an_element
    skip
    set1 = Set.new([0, 1, 2])
    set1 << 3
    expected = Set.new([0, 1, 3, 2])
    assert_equal(expected, set1)
  end

  def test_delete_an_element
    skip
    set1 = Set.new([0, 1, 2])
    expected = Set.new([0, 1])
    assert_equal(expected, set1.delete(2))
  end

  def test_intersect
    skip
    set1 = Set.new([1, 2, 3, 4, 5])
    set2 = Set.new([3, 4, 5, 6, 7])
    expected = Set.new([3, 4, 5])
    assert_equal(expected, set1 & set2)
  end

  def test_subtract
    skip
    set1 = Set.new([1, 2, 3])
    set2 = Set.new([2, 3])
    expected = [1]
    set1.subtract(set2)
    assert_equal(expected, set1.to_a)
  end

  def test_merge
    skip
    set1 = Set.new([1, 2, 3])
    set2 = Set.new([4, 5, 6])
    set1.merge(set2)
    expected = [1, 2, 3, 4, 5, 6]
    assert_equal(expected, set1.to_a)
  end

  def test_cannot_intersect_set_with_non_enum
    skip
    set = Set.new
    assert_raises(ArgumentError) do
      set & 1
    end
  end

  def test_union
    skip
    set1 = Set.new([1, 2, 3])
    set2 = Set.new([4, 5, 6])
    expected = Set.new([1, 2, 3, 4, 5, 6])
    assert_equal(expected, set1 + set2)
  end

  def test_difference
    skip
    set1 = Set.new([1, 2, 3])
    array = [1, 4]
    expected = Set.new([2, 3])
    assert_equal(expected, set1 - array)
  end

  def test_each
    skip
    set = Set.new([0, 1, 2, 3])
    elems = []
    set.each { |elem| elems << elem }
    expected = [0, 1, 2, 3]
    assert_equal(expected, elems)
  end

  def test_select
    skip
    set1 = Set.new([0, 1, 2, 3])
    set2 = set1.select { |elem| elem.odd? }
    expected = Set.new([1, 3])
    assert_equal(expected, set2)
  end

  def test_map
    skip
    set1 = Set.new(['a', 'b', 'c', 'd'])
    set2 = set1.map { |elem| elem * 2 }
    expected = Set.new(['aa', 'bb', 'cc', 'dd'])
    assert_equal(expected, set2)
  end

  def test_flatten_with_duplicates_in_nested_sets
    skip
    set1 = Set[1, 2, 3]
    set2 = Set[set1, 4, 5]
    set3 = Set[set2, 6, 7]
    set4 = Set[set3, 1]
    set5 = Set[set4, 4, set1]
    expected = Set[1, 2, 3, 4, 5, 6, 7]
    assert_equal(expected, set5.flatten)
  end
end
