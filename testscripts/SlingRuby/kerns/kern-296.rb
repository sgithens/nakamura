#!/usr/bin/env ruby


require 'nakamura/test'
require 'nakamura/search'
require 'test/unit.rb'
include SlingSearch

class TC_Kern296Test < Test::Unit::TestCase
  include SlingTest

  def test_move
    m = uniqueness()
    u1 = create_user("testuser#{m}")
    assert_not_nil(u1,"Expected User to be created ")
    g1 = create_group("g-testgroup#{m}")
    assert_not_nil(u1,"Expected Group to be created ")
    g1.add_member(@s, u1.name, "user")
    hasmember = g1.has_member(@s, u1.name)
    assert_equal(true,hasmember,"Expected user #{u1.name} to be a member of group #{g1.name} ")
    g1.remove_member(@s,u1.name,"user")
    hasmember = g1.has_member(@s, u1.name)
    assert_equal(false,hasmember,"Expected user #{u1.name} not to be a member of group #{g1.name} ")
    url = SlingUsers::Group.url_for(g1.name)
    res = @s.execute_post(@s.url_for("#{url}.delete.html"))
    assert_equal("200",res.code,"Expected delete group to be sucessful #{res.body}")
	res =  @s.execute_get(@s.url_for("#{url}.json"))
	assert_not_equal("200", res.code, "Expected group to be gone: #{res.body}")
  end

end


