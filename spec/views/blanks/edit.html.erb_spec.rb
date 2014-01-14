require 'spec_helper'

describe "blanks/edit" do
  before(:each) do
    @blank = assign(:blank, stub_model(Blank,
      :type => 1,
      :number => 1,
      :details => "MyText"
    ))
  end

  it "renders the edit blank form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", blank_path(@blank), "post" do
      assert_select "input#blank_type[name=?]", "blank[type]"
      assert_select "input#blank_number[name=?]", "blank[number]"
      assert_select "textarea#blank_details[name=?]", "blank[details]"
    end
  end
end
