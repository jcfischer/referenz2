require File.dirname(__FILE__) + '/../spec_helper'

describe Chapter do
  before(:each) do
    @chapter = Chapter.new(:number => '2')
  end

  it "should have to_param method that returns chapter number" do
    @chapter.to_param.should == "2_"
  end
  it "should convert title to slug" do
    @chapter.slug.should_not be_nil
  end
  
end

describe Chapter, "slug" do
  before(:each) do
    @chapter = Chapter.new(:number => '2', :title => "Einführung ins Testen")
  end

  it "should convert title to slug" do
    @chapter.slug.should_not be_nil
  end
  
  it "should convert spaces to _" do
    @chapter.slug.should == "einführung_ins_testen"
  end
  
end