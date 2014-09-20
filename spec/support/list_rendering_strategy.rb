module ListRenderingStrategy
  def self.included(base)
    base.let(:item) { build_item }
  end

  def rendered_item(*args)
    rendered(*args).find("wrapper > ul > li")
  end

  def rendered(list_options = {}, item_options = {})
    Capybara.string("<wrapper>" + described_class.new([item], list_options, item_options).render + "</wrapper>")
  end

  def build_item(options = {})
    defaults = {
      :name            => "Item 1",
      :render?         => true,
      :linked?         => false,
      :active?         => false,
      :active_class    => nil,
      :inactive_class  => nil,
      :html_attributes => {},
      :has_children?   => false
    }

    OpenStruct.new(defaults.merge(options))
  end

  shared_examples_for("a list rendering strategy") do
    it "wraps the list in a <ul>" do
      rendered.should have_selector("ul")
    end

    it "accepts <ul> attributes" do
      list_attributes = {"id" => "my-list"}
      rendered(:html_attributes => list_attributes).should have_selector("ul#my-list")
    end

    context "the item should not be rendered" do
      it "does not render the item" do
        item.stub(:render? => false)
        expect { rendered_item }.to raise_error(Capybara::ElementNotFound)
      end
    end

    describe "a list item" do
      it "returns an <li>" do
        rendered.find("li").should be_present
      end

      it "contains the item name" do
        rendered_item.should have_content("Item 1")
      end

      it "incorporates HTML attributes" do
        item.stub(:html_attributes => {:id => "item-1"})
        rendered.find("li")["id"].should include("item-1")
      end

      it "it does include blank HTML attributes" do
        rendered.find("li")["class"].should be_nil
      end

      context "the item is linked" do
        before do
          item.stub(:linked? => true, :path => "/path")
        end

        it "contains an <a> and the item name" do
          rendered_item.find("a").should have_content("Item 1")
        end

        it "links to the correct path" do
          rendered_item.find("a")["href"].should == "/path"
        end
      end

      context "the item is active" do
        before do
          item.stub(:active? => true)
        end

        it "adds an 'active' class" do
          rendered_item["class"].should include("active")
        end

        it "allows the active class to be specified" do
          rendered_item({}, {:active_class => "alt-active"})["class"].should include("alt-active")
        end

        it "does not overwrite item attributes" do
          item.stub(:html_attributes => {:class => "preserved-class"})
          classes = rendered_item["class"].split(" ")
          classes.should include("active")
          classes.should include("preserved-class")
        end
      end

      context "an item with children" do
        before do
          item.stub(
            :has_children? => true,
            :children      => [build_item(:name => "Nested Item 1")]
          )
        end

        it "creates a nested <ul>" do
          rendered_item.should have_selector("ul")
        end

        it "creates list items within the nested list" do
          rendered_item.find("li").should have_content("Nested Item 1")
        end
      end
    end
  end
end