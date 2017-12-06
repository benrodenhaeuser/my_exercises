require 'minitest/autorun'
require_relative 'sets'

class BasicSetTest < Minitest::Test
  def test_initialize
    # skip
    set = BasicSet.new(1 => 1, 2 => 1, 3 => 2)
    actual = set.to_h
    expected = { 1 => 1, 2 => 1, 3 => 2 }
    assert_equal(expected, actual)
  end

  def test_class_method_calls_constructo
    # skip
    set = BasicSet[1 => 1, 2 => 1, 3 => 2]
    actual = set.to_h
    expected = { 1 => 1, 2 => 1, 3 => 2 }
    assert_equal(expected, actual)
  end

  def test_element_setter
    set = BasicSet.new
    set[3] = 4
    actual = set.to_h
    expected = { 3 => 4 }
    assert_equal(expected, actual)
  end

  def test_element_getter
    set = BasicSet[3 => 4]
    actual = set[3]
    expected = 4
    assert_equal(expected, actual)
  end

  def test_each
    set = BasicSet[1 => 1, 2 => 1, 3 => 2]
    actual = set.each.to_a
    expected = [[1, 1], [2, 1], [3, 2]]
    assert_equal(expected, actual)
  end
end

class MultiSetTest < Minitest::Test

  def test_initialize_and_to_a
    skip
    multi_set = MultiSet[1, 2, 3, 3]
    expected = [1, 2, 3, 3]
    assert_equal(expected, multi_set.to_a)
  end

  def test_size
    skip
    multi_set = MultiSet[1, 2, 3, 3]
    expected = 4
    assert_equal(expected, multi_set.size)
  end

  def test_include
    skip
    multi_set = MultiSet[1, 2, 3, 4]
    assert_includes(multi_set, 2)
  end

  def test_add_element
    skip
    multi_set = MultiSet[1, 2, 3, 3]
    multi_set.add(5)
    expected = [1, 2, 3, 3, 5]
    assert_equal(expected, multi_set.to_a)
  end

  def test_delete_one_occurence
    skip
    multi_set = MultiSet[1, 2, 3, 3]
    multi_set.delete(3)
    assert_equal(multi_set, MultiSet[1, 2, 3])
  end

  def test_delete_all
    skip
    multi_set = MultiSet[1, 2, 3, 3]
    multi_set.delete_all(3)
    assert_equal(multi_set, MultiSet[1, 2])
  end

  def test_flatten
    skip
    set1 = MultiSet[1, 2, 3]
    set2 = MultiSet[set1, 4, 5]
    set3 = MultiSet[set2, 6, 7]
    expected = [1, 2, 3, 4, 5, 6, 7]
    assert_equal(expected, set3.flatten.to_a)
  end

  def test_flatten_with_elements_appearing_multiple_times
    skip
    set1 = MultiSet[1, 2, 3, 3]
    set2 = MultiSet[set1, 4, 5]
    set3 = MultiSet[set2, 6, 6, 7]
    expected = [1, 2, 3, 3, 4, 5, 6, 6, 7]
    assert_equal(expected, set3.flatten.to_a)
  end

  def test_flatten_with_complicated_set
    skip
    set1 = MultiSet[1, 2, 3]
    set2 = MultiSet[set1, 4, 5]
    set3 = MultiSet[set2, 6, 7]
    set4 = MultiSet[set3, 1]
    set5 = MultiSet[set4, 4, set1]
    expected = MultiSet[1, 2, 3, 4, 5, 6, 7, 1, 4, 1, 2, 3]
    assert_equal(expected, set5.flatten)
  end

  def test_to_s
    skip
    set1 = MultiSet[1, 2, 3]
    set2 = MultiSet[set1, 4, 5]
    set3 = MultiSet[set2, 6, 7]
    set4 = MultiSet[set3, 1]
    set5 = MultiSet[set4, 4, set1]
    expected = '{{{{{1, 2, 3}, 4, 5}, 6, 7}, 1}, 4, {1, 2, 3}}'
    assert_equal(expected, set5.to_s)
  end

  def test_sum!
    skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[2, 4]
    multi_set1.sum!(multi_set2)
    expected = [1, 2, 2, 3, 3, 4]
    assert_equal(expected, multi_set1.to_a)
  end

  def test_union!
    skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[2, 4]
    multi_set1.union!(multi_set2)
    expected = [1, 2, 3, 3, 4]
    assert_equal(expected, multi_set1.to_a)
  end

  def test_difference!
    skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[3, 3, 3]
    expected = [1, 2]
    assert_equal(expected, (multi_set1.difference(multi_set2)).to_a)
  end

  def test_sum
    skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[2, 4]
    summed_set = multi_set1.sum(multi_set2)
    expected = [1, 2, 2, 3, 3, 4]
    assert_equal(expected, summed_set.to_a)
  end

  def test_union
    skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[2, 4]
    the_union = multi_set1.union(multi_set2)
    expected = [1, 2, 3, 3, 4]
    assert_equal(expected, the_union.to_a)
  end

  def test_intersection
    skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[2, 4, 3, 3, 3]
    the_intersection = multi_set1.intersection(multi_set2)
    expected = [2, 3, 3]
    assert_equal(expected, the_intersection.to_a)
  end

  def test_difference
    skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[3, 3, 3]
    the_difference = multi_set1.difference(multi_set2)
    expected = [1, 2]
    assert_equal(expected, the_difference.to_a)
  end

  def test_sub
    skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[1, 2, 3, 3, 4, 5]
    multi_set3 = MultiSet[1, 2, 3]
    assert(multi_set1.subset?(multi_set2))
    refute(multi_set1.subset?(multi_set3))
  end

  def test_proper_sub
    skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[1, 2, 3, 3, 4, 5]
    multi_set3 = MultiSet[1, 2, 3]
    assert(multi_set1.proper_subset?(multi_set2))
    refute(multi_set1.proper_subset?(multi_set3))
  end

  def test_super
    skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[1, 2, 3, 3, 4, 5]
    multi_set3 = MultiSet[1, 2, 3]
    assert(multi_set2.superset?(multi_set1))
    refute(multi_set3.superset?(multi_set1))
  end

  def test_proper_super
    skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[1, 2, 3, 3, 4, 5]
    multi_set3 = MultiSet[1, 2, 3]
    assert(multi_set2.proper_superset?(multi_set1))
    refute(multi_set3.proper_superset?(multi_set3))
  end

  def test_equivalence
    skip
    multi_set1 = MultiSet[1, 2, 3, 3]
    multi_set2 = MultiSet[1, 2, 3, 3]
    multi_set3 = MultiSet[1, 2, 3]
    assert(multi_set1.equivalent?(multi_set2))
    refute(multi_set1.equivalent?(multi_set3))
  end

  def test_equality_with_nested_sets_for_MultiSets
    skip
    set1 = MultiSet.new([0, 1, 2])
    set2 = MultiSet.new([1, 2, 0])
    set3 = MultiSet.new([set1, 1, 2])
    set4 = MultiSet.new([set2, 1, 2])
    assert(set1.equivalent?(set2))
    assert(set3.equivalent?(set4))
  end

  def test_equality_with_double_nesting
    skip
    set1 = MultiSet.new([0, 1, 2])
    set2 = MultiSet.new([1, 2, 0])
    set3 = MultiSet.new([set1, 1, 2])
    set4 = MultiSet.new([set2, 1, 2])
    set5 = MultiSet.new([set3])
    set6 = MultiSet.new([set4])
    assert(set5.equivalent?(set6))
  end

  def test_each_with_block
    skip
    multi_set = MultiSet[1, 2, 3, 3]
    array = []
    multi_set.each { |elem| array << elem }
    assert_equal(array, [1, 2, 3, 3])
  end

  def test_each_without_block
    skip
    MultiSet.new.each.instance_of?(Enumerator)
  end

  # def test_map
  #   set = MultiSet[0, 1, 2, 3, 4, 4]
  #   mapped = set.map { |elem| elem * 2 }
  #   assert_equal(MultiSet[0, 2, 4, 6, 8, 8], mapped)
  # end

  # def test_select
  #   set = MultiSet[0, 1, 2, 3, 4, 4]
  #   selected = set.select { |elem| elem.even? }
  #   assert_equal(MultiSet[0, 2, 4, 4], selected)
  # end

  def test_delete_decrements_elem_count
    skip
    set = MultiSet[1, 2, 3, 3]
    set.delete(3)
    assert(set.count(3) == 1)
  end

  def test_negative_elem_counts_do_not_occur
    skip
    set = MultiSet[1, 2, 3]
    set.delete(1)
    set.delete(1)
    expected = 0
    assert_equal(0, set.count(1))
  end

  def test_destructive_intersection
    skip
    set = MultiSet[1, 2, 3]
    array = [2, 3, 4]
    set.intersection!(array)
    expected = MultiSet[2, 3]
    assert_equal(expected, set)
  end
end

class SetTest < Minitest::Test

  def test_elements_are_not_counted
    skip
    array = [1, 2, 3, 4, 4]
    set = Set[*array]
    expected = array.uniq
    assert_equal(expected, set.to_a)
  end

  def test_adding_element_already_present_does_not_affect_size
    skip
    set = Set.new([0, 1, 2])
    set.add(1)
    assert_equal(3, set.size)
    assert_equal([0, 1, 2], set.to_a)
  end

  def test_sum_is_union
    skip
    array1 = Set[1, 2, 3]
    array2 = Set[1, 2, 3]
    array1.sum!(array2)
    expected = [1, 2, 3]
    assert_equal(expected, array1.to_a)
  end

  def test_equality_is_order_independent
    skip
    set1 = Set.new([0, 1, 2])
    set2 = Set.new([1, 2, 0])
    assert(set1.equivalent?(set2))
  end

  def test_equality_with_nested_sets
    skip
    set1 = Set.new([0, 1, 2])
    set2 = Set.new([1, 2, 0])
    set3 = Set.new([set1, 1, 2])
    set4 = Set.new([1, set2, 2])
    assert(set1.equivalent?(set2))
    assert(set3.equivalent?(set4))
  end

  def test_equality_despite_repetitions
    skip
    set1 = Set.new([0, 1, 2, 2])
    set2 = Set.new([0, 1, 2])
    assert(set1.equivalent?(set2))

    set3 = Set.new([set1])
    set4 = Set.new([set2])
    assert(set3.equivalent?(set4))
  end

  def test_equality_with_double_nesting_for_ordinary_sets
    skip
    set1 = Set.new([0, 1, 2])
    set2 = Set.new([1, 2, 0])
    set3 = Set.new([set1, 1, 2])
    set4 = Set.new([set2, 1, 2])
    set5 = Set.new([set3])
    set6 = Set.new([set4])
    assert(set5.equivalent?(set6))
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

  def test_proper_super_is_not_equal
    skip
    set1 = Set.new([0, 1, 2])
    set2 = Set.new([0, 1, 2, 3])
    refute(set1.equivalent?(set2))
  end

  def test_add_an_element
    skip
    set1 = Set.new([0, 1, 2])
    set1.add(3)
    expected = Set.new([0, 1, 3, 2])
    assert_equal(expected, set1)
  end

  def test_delete_an_element
    skip
    set1 = Set.new([0, 1, 2])
    set1.delete(2)
    assert_equal(Set[0, 1], set1)
  end

  def test_delete_all_is_like_delete_for_sets
    skip
    set1 = Set.new([0, 1, 2, 2])
    set1.delete_all(2)
    assert_equal(Set[0, 1], set1)
  end

  def test_intersect
    skip
    set1 = Set.new([1, 2, 3, 4, 5])
    set2 = Set.new([3, 4, 5, 6, 7])
    expected = Set.new([3, 4, 5])
    assert_equal(expected, set1.intersection(set2))
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
      set.intersection(1)
    end
  end

  def test_union
    skip
    set1 = Set.new([1, 2, 3])
    set2 = Set.new([4, 5, 6])
    expected = Set.new([1, 2, 3, 4, 5, 6])
    assert_equal(expected, set1.union(set2))
  end

  def test_difference
    skip
    set1 = Set.new([1, 2, 3])
    array = [1, 4]
    expected = Set.new([2, 3])
    assert_equal(expected, set1.difference(array))
  end

  def test_each
    skip
    set = Set.new([0, 1, 2, 3])
    elems = []
    set.each { |elem| elems << elem }
    expected = [0, 1, 2, 3]
    assert_equal(expected, elems)
  end

  # def test_select
  #   set1 = Set.new([0, 1, 2, 3])
  #   set2 = set1.select { |elem| elem.odd? }
  #   expected = Set.new([1, 3])
  #   assert_equal(expected, set2)
  # end

  # def test_map
  #   set1 = Set.new(['a', 'b', 'c', 'd'])
  #   set2 = set1.map { |elem| elem * 2 }
  #   expected = Set.new(['aa', 'bb', 'cc', 'dd'])
  #   assert_equal(expected, set2)
  # end

  def test_flatten_with_complicated_set
    skip
    set1 = Set[1, 2, 3]
    set2 = Set[set1, 4, 5]
    set3 = Set[set2, 6, 7]
    set4 = Set[set3, 1]
    set5 = Set[set4, 4, set1]
    expected = Set[1, 2, 3, 4, 5, 6, 7]
    assert_equal(expected, set5.flatten)
  end

  def test_delete_makes_elem_count_zero
    skip
    set = Set[1, 2, 3, 3]
    set.delete(3)
    assert(set.count(3) == 0)
  end
end
