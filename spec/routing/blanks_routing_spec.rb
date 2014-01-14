require "spec_helper"

describe BlanksController do
  describe "routing" do

    it "routes to #index" do
      get("/blanks").should route_to("blanks#index")
    end

    it "routes to #new" do
      get("/blanks/new").should route_to("blanks#new")
    end

    it "routes to #show" do
      get("/blanks/1").should route_to("blanks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/blanks/1/edit").should route_to("blanks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/blanks").should route_to("blanks#create")
    end

    it "routes to #update" do
      put("/blanks/1").should route_to("blanks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/blanks/1").should route_to("blanks#destroy", :id => "1")
    end

  end
end
