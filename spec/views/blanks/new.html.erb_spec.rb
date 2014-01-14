require 'spec_helper'

describe "blanks/new" do
  before(:each) do
    assign(:blank, stub_model(Blank,
      :type => 1,
      :number => 1,
      :details => "MyText"
    ).as_new_record)
  end

  it "renders new blank form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", blanks_path, "post" do
      assert_select "input#blank_type[name=?]", "blank[type]"
      assert_select "input#blank_number[name=?]", "blank[number]"
      assert_select "textarea#blank_details[name=?]", "blank[details]"
    end
  end
end
