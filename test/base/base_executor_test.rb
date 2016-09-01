require 'test_helper'

class BaseExecutorTest < Minitest::Test
  
  def setup
    @dep1 = {
      'prod_key'  => "prod1",
      'outdated'  => true,
      :upgrade    => {dv_major: 1, dv_minor: 0, dv_patch: 0, dv_score: 1}
    }
    @dep2 = {
      'prod_key'  => 'prod2',
      'outdated'  => true,
      :upgrade    => {dv_major: 0, dv_minor: 1, dv_patch: 0, dv_score: 1}
    }
    @dep3 = {
      'prod_key'  => 'prod3',
      'outdated'  => true,
      :upgrade    => {dv_major: 0, dv_minor: 0, dv_patch: 1, dv_score: 1}
    }
    @dep4 = {
      'prod_key'  => 'prod4',
      'outdated'  => true,
      :upgrade    => {dv_major: 0, dv_minor: 1, dv_patch: 2, dv_score: 2}
    }

    @deps = [@dep1, @dep2, @dep3, @dep4]

  end

  def test_filter_dependencies_with_all_active
    #it should return all the dependencies
    res = BaseExecutor.filter_dependencies(@deps, {all: true})
    assert_equal false, res.empty?
    assert_equal 4, res.size
  end

  def test_filter_dependencies_without_options
    #it should return only outdated dep
    res = BaseExecutor.filter_dependencies(@deps, {patch: false})
    assert_equal false, res.empty?
    assert_equal 4, res.size
    assert_equal @dep1['prod_key'], res.first['prod_key']
  end

  def test_filter_dependencies_with_major_flag
    #it should return only dep1
    res = BaseExecutor.filter_dependencies(@deps, {major: true})
    assert_equal false, res.empty?
    assert_equal 1, res.size
    assert_equal @dep1['prod_key'], res.first['prod_key']
  end

  def test_filter_dependencies_with_minor_flag
    #it should return dep2 and dep4 and no duplications
    res = BaseExecutor.filter_dependencies(@deps, {minor: true})
    assert_equal false, res.empty?
    assert_equal 2, res.size
    assert_equal @dep2['prod_key'], res[0]['prod_key']
    assert_equal @dep4['prod_key'], res[1]['prod_key']
  end

  def test_filter_dependencies_with_patch_flag
    # it should return dep3 and dep4 and no duplications
    res =  BaseExecutor.filter_dependencies(@deps, {patch: true})
    assert_equal false, res.empty?
    assert_equal 1, res.size
    assert_equal @dep3['prod_key'], res[0]['prod_key']
  end

  def test_filter_dependencies_with_multiple_filter_flags
    # it shows all the dependencies which have minor and patch changes
    res = BaseExecutor.filter_dependencies(@deps, {minor: true, patch: true})
    assert_equal false, res.empty?
    assert_equal 3, res.size
    assert_equal @dep2['prod_key'], res[0]['prod_key']
    assert_equal @dep4['prod_key'], res[1]['prod_key']
    assert_equal @dep3['prod_key'], res[2]['prod_key']
  end

  def test_filter_dependencies_filters_out_all_the_duplicates
    res = BaseExecutor.filter_dependencies([@dep1, @dep1, @dep1], {major: true})
    assert_equal false, res.empty?
    assert_equal 1, res.size
    assert_equal @dep1['prod_key'], res[0]['prod_key']
  end
end
