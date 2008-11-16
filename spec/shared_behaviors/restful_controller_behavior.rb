include AuthenticatedTestHelper

shared_examples_for 'a RESTful controller with an index action' do
  before :each do
    path_name_setup
  end
    
  describe "handling GET /plural (index)" do
    before(:each) do
      @object = stub(@model_name)
      @objects = [@object]
      @model_class.stubs(:find).returns(@objects)
      do_login if needs_login?
      
      find_target_setup :plural
    end
    
    def do_get
      get :index, {}.merge(nesting_params)
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
    
    if has_parent?
      it 'should find the parent object' do
        @parent_class.expects(:find).with(parent_id).returns(@parent)
        do_get
      end
    end
    
    it "should find all the objects" do
      if finder
        @find_target.expects(finder[:method]).returns(@objects)
      else
        @find_target.expects(:find).returns(@objects)
      end
      do_get
    end
  
    it "should make the found objects available to the view" do
      do_get
      assigns[@model_plural.to_sym].should == @objects
    end
    
    if has_parent?
      it 'should make the parent object available to the view' do
        do_get
        assigns[@parent_name.to_sym].should == @parent
      end
    end
  end
end

shared_examples_for 'a RESTful controller with a show action' do
  before :each do
    path_name_setup
  end
    
  describe "handling GET /plural/1 (show)" do
    before(:each) do
      @obj_id = '1'
      @obj = stub(@model_name)
      @model_class.stubs(:find).returns(@obj)
      do_login if needs_login?
      
      find_target_setup
    end
  
    def do_get
      get :show, { :id => @obj_id }.merge(nesting_params)
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render the show template" do
      do_get
      response.should render_template('show')
    end
  
    if has_parent?
      it 'should find the parent object' do
        @parent_class.expects(:find).with(parent_id).returns(@parent)
        do_get
      end
    end
    
    it "should find the object requested" do
      @find_target.expects(:find).with(@obj_id).returns(@obj)
      do_get
    end
  
    it "should make the found object available to the view" do
      do_get
      assigns[@model_singular.to_sym].should equal(@obj)
    end

    if has_parent?
      it 'should make the parent object available to the view' do
        do_get
        assigns[@parent_name.to_sym].should == @parent
      end
    end
  end
end

shared_examples_for 'a RESTful controller with a new action' do
  before :each do
    path_name_setup
  end
    
  describe "handling GET /plural/new" do
    before(:each) do
      @obj = stub(@model_name)
      @model_class.stubs(:find).returns(@obj)
      @model_class.stubs(:new).returns(@obj)
      do_login if needs_login?
    end
  
    def do_get
      get :new, {}.merge(nesting_params)
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render the new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create a new object" do
      @model_class.expects(:new).returns(@obj)
      do_get
    end
  
    it "should not save the new object" do
      @obj.expects(:save).never
      do_get
    end
  
    it "should make the new object available to the view" do
      do_get
      assigns[@model_singular.to_sym].should equal(@obj)
    end
  end
end

shared_examples_for 'a RESTful controller with a create action' do
  before :each do
    path_name_setup
  end
    
  describe "handling POST /plural (create)" do
    before(:each) do
      @obj = @model_class.new
      @obj_id = 1
      @obj.stubs(:id).returns(@obj_id)
      @model_class.stubs(:new).returns(@obj)
      do_login if needs_login?
      
      if redirects_to_index
        object_path_setup :plural
      else
        object_path_setup
      end
    end
  
    def post_with_successful_save
      @obj.expects(:save).returns(true)
      post :create, { @model_singular.to_sym => {} }.merge(nesting_params)
    end
  
    def post_with_failed_save
      @obj.expects(:save).returns(false)
      post :create, { @model_singular.to_sym => {} }.merge(nesting_params)
    end
  
    it "should create a new object" do
      @model_class.expects(:new).with({}).returns(@obj)
      post_with_successful_save
    end

    it "should redirect to the new object or objects on a successful save" do
      post_with_successful_save
      response.should redirect_to(self.send("#{@object_path_method}_url".to_sym, *@url_args))
    end

    it "should re-render 'new' on a failed save" do
      post_with_failed_save
      response.should render_template('new')
    end
  end
end

shared_examples_for 'a RESTful controller with an edit action' do
  before :each do
    path_name_setup
  end
    
  describe "handling GET /plural/1/edit (edit)" do
    before(:each) do
      @obj = stub(@model_name)
      @model_class.stubs(:find).returns(@obj)
      do_login if needs_login?
    end
  
    def do_get
      get :edit, { :id => "1" }.merge(nesting_params)
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render the edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the object requested" do
      @model_class.expects(:find).returns(@obj)
      do_get
    end
  
    it "should make the found object available to the view" do
      do_get
      assigns[@model_singular.to_sym].should equal(@obj)
    end
  end
end

shared_examples_for 'a RESTful controller with an update action' do
  before :each do
    path_name_setup
  end
    
  describe "handling PUT /plural/1 (update)" do
    before(:each) do
      @obj_id = '1'
      @obj = stub(@model_name, :to_s => @obj_id, :attributes= => true, :save => true)
      @model_class.stubs(:find).returns(@obj)
      do_login if needs_login?
      
      if redirects_to_index
        object_path_setup :plural
      else
        object_path_setup
      end
      find_target_setup
    end
  
    def put_with_successful_update
      @obj.expects(:save).returns(true)
      put :update, { :id => @obj_id }.merge(nesting_params)
    end
  
    def put_with_failed_update
      @obj.expects(:save).returns(false)
      put :update, { :id => @obj_id }.merge(nesting_params)
    end
  
    if has_parent?
      it 'should find the parent object' do
        @parent_class.expects(:find).with(parent_id).returns(@parent)
        do_get
      end
    end
    
    it "should find the object requested" do
      @find_target.expects(:find).with(@obj_id).returns(@obj)
      put_with_successful_update
    end

    it "should update the found object" do
      put_with_successful_update
      assigns(@model_singular.to_sym).should equal(@obj)
    end

    it "should make the found object available to the view" do
      put_with_successful_update
      assigns(@model_singular.to_sym).should equal(@obj)
    end

    if has_parent?
      it 'should make the parent object available to the view' do
        do_get
        assigns[@parent_name.to_sym].should == @parent
      end
    end
    
    it "should redirect to the object on a successful update" do
      put_with_successful_update
      response.should redirect_to(self.send("#{@object_path_method}_url".to_sym, *@url_args))
    end

    it "should re-render 'edit' on a failed update" do
      put_with_failed_update
      response.should render_template('edit')
    end
  end
end

shared_examples_for 'a RESTful controller with a destroy action' do
  before :each do
    path_name_setup
  end
    
  describe "handling DELETE /plural/1 (destroy)" do
    before(:each) do
      @obj_id = '1'
      @obj = stub(@model_name, :destroy => true)
      @model_class.stubs(:find).returns(@obj)
      do_login if needs_login?
      
      object_path_setup :plural
      find_target_setup
    end
  
    def do_delete
      delete :destroy, { :id => @obj_id }.merge(nesting_params)
    end

    if has_parent?
      it 'should find the parent object' do
        @parent_class.expects(:find).with(parent_id).returns(@parent)
        do_get
      end
    end
    
    it "should find the object requested" do
      @find_target.expects(:find).with(@obj_id).returns(@obj)
      do_delete
    end
  
    it "should call destroy on the found object" do
      @obj.expects(:destroy).returns(true)
      do_delete
    end
  
    it "should redirect to the object list" do
      do_delete
      response.should redirect_to(self.send("#{@object_path_method}_url".to_sym, *@url_args))
    end
  end
end


shared_examples_for 'a RESTful controller' do
  
  it_should_behave_like 'a RESTful controller with an index action'
  it_should_behave_like 'a RESTful controller with a show action'
  it_should_behave_like 'a RESTful controller with a new action'
  it_should_behave_like 'a RESTful controller with a create action'
  it_should_behave_like 'a RESTful controller with an edit action'
  it_should_behave_like 'a RESTful controller with an update action'
  it_should_behave_like 'a RESTful controller with a destroy action'
      
end


#### helper methods for various setup or behavior needs

# declare a default predicate for whether we need to bother with login overhead for these examples
def needs_login?() 
  false 
end

def do_login
  login_as User.generate :admin => true   
end

unless defined? nesting_params
  def nesting_params
    {}
  end
end

def has_parent?
  parent_key
end

def parent_key
  nesting_params.keys.detect { |k|  k.to_s.ends_with?('_id') }
end

def parent_id
  nesting_params[parent_key]
end

def parent_type
  parent_key.to_s.sub(/_id$/, '')
end

def path_name_setup
  @name           ||= controller.class.name                         # => 'FoosController'
  @plural_path    ||= @name.sub('Controller', '').tableize          # => 'foos'
  @singular_path  ||= @plural_path.singularize                      # => 'foo'
  @model_name     ||= @name.to_s.sub('Controller', '').singularize  # => 'Foo'
  @model_plural   ||= @plural_path                                  # => 'foos'
  @model_singular ||= @singular_path                                # => 'foo'
  @model_class    ||= @model_name.constantize                       # => Foo
  
  if has_parent?
    @parent_name  = parent_type.camelize
    @parent_class = @parent_name.constantize
  end
end

def find_target_setup(arity = :singular)
  find_return = case arity
    when :plural
      @objects
    when :singular
      @obj
    else
      raise "Don't know what to make parent association return"
  end
  
  @find_target = @model_class
  if has_parent?
    @parent_association = stub("#{@parent_name} #{@model_plural}", :find => find_return)
    @parent = stub(@parent_name, @model_plural.to_sym => @parent_association, :to_param => parent_id)
    @parent_class.stubs(:find).returns(@parent)
    @find_target = @parent_association
  end
end

def object_path_setup(arity = :singular)
  @url_args = []
  @url_args.push(@obj_id) unless arity == :plural
  @url_args.compact!
  @object_path_method = instance_variable_get("@#{arity}_path")
  if has_parent?
    @object_path_method = "#{parent_type}_#{@object_path_method}"
    @url_args.unshift(parent_id)
  end
end
#### end of helper methods

__END__
