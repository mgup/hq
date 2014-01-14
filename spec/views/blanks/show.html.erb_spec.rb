require 'spec_helper'

describe "blanks/show" do
  before(:each) do
    @blank = assign(:blank, stub_model(Blank,
      :type => 1,
      :number => 2,
      :details => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/MyText/)
  end
end
