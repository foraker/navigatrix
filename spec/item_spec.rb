require File.expand_path("../../lib/navigatrix/item", __FILE__)
require File.expand_path("../../lib/navigatrix/item_collection", __FILE__)
require File.expand_path("../../lib/navigatrix/configuration", __FILE__)

module Navigatrix
  describe Item do
    let(:context) { double({:current_path => "/"}) }

    it "knows its name" do
      Item.new("Item 1", {}, context).name.should == "Item 1"
    end

    describe "#path" do
      it "returns a file paths" do
        Item.new("Item 1", {"path" => "/a/standard/path"}).path.should == "/a/standard/path"
      end

      it "evaluates a Proc" do
        context.stub(:path_method => "/a/path/method")
        path_proc = Proc.new { |context| context.path_method }
        item      = Item.new("Item 1", {"path" => path_proc}, context)
        item.path.should == "/a/path/method"
      end
    end

    describe "#active?" do
      it "is true when the navigation is unlinked" do
        item = new_item({})
        item.stub(:unlinked? => true)
        item.should be_active
      end

      it "is false when the navigation is linked" do
        item = new_item({})
        item.stub(:unlinked? => false)
        item.should_not be_active
      end

      context "a controller is specified in the config" do
        let(:config) { {"active_states" => {"controller" => "controller_1"}} }

        it "is true if the specified controller is the current controller" do
          context.stub(:controller_name => "controller_1", :action_name => "index")
          new_item(config).should be_active
        end

        it "is true regardless of action name" do
          context.stub(:controller_name => "controller_1", :action_name => "edit")
          new_item(config).should be_active
        end
      end

      context "a controller and action are specified in the config" do
        let(:config) do
          {"active_states" => {"controller" => "controller_2", "actions" => "index"}}
        end

        it "is true if the specified controller/action combination is the current controller/action combination" do
          context.stub(:controller_name => "controller_2", :action_name => "index")
          new_item(config).should be_active
        end

        it "is false when the action name mismatches" do
          context.stub(:controller_name => "controller_2", :action_name => "edit")
          new_item(config).should_not be_active
        end

        it "is false when the controller name mismatches" do
          context.stub(:controller_name => "controller_1", :action_name => "index")
          new_item(config).should_not be_active
        end
      end

      context "multiple active states are specified" do
        let(:config) do
          {"active_states" => [
            {"controller" => "controller_3"},
            {"controller" => "controller_4", "actions" => "show"},
          ]}
        end

        it "is true if the first state is applicable" do
          context.stub(:controller_name => "controller_3", :action_name => "index")
          new_item(config).should be_active
        end

        it "is indifferent to action name in the first case" do
          context.stub(:controller_name => "controller_3", :action_name => "show")
          new_item(config).should be_active
        end

        it "is true if the second state is applicable" do
          context.stub(:controller_name => "controller_4", :action_name => "show")
          new_item(config).should be_active
        end

        it "is honors action name specifications" do
          context.stub(:controller_name => "controller_4", :action_name => "edit")
          new_item(config).should_not be_active
        end

        it "is false when neither apply" do
          context.stub(:controller_name => "controller_5", :action_name => "edit")
          new_item(config).should_not be_active
        end
      end
    end

    describe "#unlinked?" do
      context "no unlinked states are configured" do
        before { context.stub(:current_path => "/path_1") }

        it "is true when the current_path is the same as the item path" do
          item = new_item({})
          item.stub(:path => "/path_1")
          item.should be_unlinked
        end

        it "is false when the current_path is not the same the item path" do
          item = new_item({})
          item.stub(:path => "/path_2")
          item.should_not be_unlinked
        end
      end

      context "unlink states are configured" do
        context "a controller is specified" do
          let(:config) { {"unlinked_states" => {"controller" => "controller_1"}} }

          it "is true if the specified controller is the current controller" do
            context.stub(:controller_name => "controller_1", :action_name => "index")
            new_item(config).should be_unlinked
          end

          it "is true regardless of action name" do
            context.stub(:controller_name => "controller_1", :action_name => "edit")
            new_item(config).should be_unlinked
          end
        end

        context "a controller and action are specified config" do
          let(:config) do
            {"unlinked_states" => {"controller" => "controller_2", "actions" => "index"}}
          end

          it "is true if the specified controller/action combination is the current controller/action combination" do
            context.stub(:controller_name => "controller_2", :action_name => "index")
            new_item(config).should be_unlinked
          end

          it "is false when the action name mismatches" do
            context.stub(:controller_name => "controller_2", :action_name => "edit")
            new_item(config).should_not be_unlinked
          end

          it "is false when the controller name mismatches" do
            context.stub(:controller_name => "controller_1", :action_name => "index")
            new_item(config).should_not be_active
          end
        end

        context "multiple active states are specified" do
          let(:config) do
            {"unlinked_states" => [
              {"controller" => "controller_3"},
              {"controller" => "controller_4", "actions" => "show"},
            ]}
          end

          it "is true if the first state is applicable" do
            context.stub(:controller_name => "controller_3", :action_name => "index")
            new_item(config).should be_unlinked
          end

          it "is indifferent to action name in the first case" do
            context.stub(:controller_name => "controller_3", :action_name => "show")
            new_item(config).should be_unlinked
          end

          it "is true if the second state is applicable" do
            context.stub(:controller_name => "controller_4", :action_name => "show")
            new_item(config).should be_unlinked
          end

          it "is honors action name specifications" do
            context.stub(:controller_name => "controller_4", :action_name => "edit")
            new_item(config).should_not be_unlinked
          end

          it "is false when neither apply" do
            context.stub(:controller_name => "controller_5", :action_name => "edit")
            new_item(config).should_not be_unlinked
          end
        end
      end
    end

    describe "#children" do
      let(:item)  { new_item({"children" => {"Child 1" => {}}}) }
      let(:child) { item.children.first }

      it "creates the correct number of children" do
        item.children.count.should == 1
      end

      it "returns an array of items" do
        child.should be_instance_of(Item)
      end

      it "maps its children to items" do
        child.name.should == "Child 1"
      end

      it "can handle childless configurations" do
        expect { new_item({}) }.to_not raise_error
      end
    end
  end
end

def new_item(config)
  Navigatrix::Item.new("", config, context)
end
