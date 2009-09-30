require File.dirname(__FILE__) + '/test_helper.rb'

context "autoscaling " do
  before do
    @as = AWS::Autoscaling::Base.new( :access_key_id => "not a key", :secret_access_key => "not a secret" )

    @valid_create_launch_configuration_params = {
      :image_id => "ami-ed46a784", 
      :launch_configuration_name => "TestAutoscalingGroupName", 
      :instance_type => "m1.small"
    }
    
    @error_response_for_creation = <<-RESPONSE
<ErrorResponse xmlns="http://autoscaling.amazonaws.com/doc/2009-05-15/">
  <Error>
    <Type>Sender</Type>
    <Code>AlreadyExists</Code>
    <Message>Launch Configuration by this name already exists - A launch configuration already exists with the name TestAutoscalingGroupName</Message>
  </Error>
  <RequestId>31d00b03-ad6a-11de-a47f-a5c562feca13</RequestId>
</ErrorResponse>
    RESPONSE
  
    @delete_launch_configuration_response = <<-RESPONSE
  <DeleteLaunchConfigurationResponse xmlns="http://autoscaling.amazonaws.com/doc/2009-05-15/">
    <ResponseMetadata>
      <RequestId>5f5717d3-ad6c-11de-b1c0-1b00aadc5f72</RequestId>
    </ResponseMetadata>
  </DeleteLaunchConfigurationResponse>
    RESPONSE
    
    @create_launch_configuration_response = "<CreateLaunchConfigurationResponse xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">\n  <ResponseMetadata>\n    <RequestId>6062466f-ad6c-11de-b82f-996c936914c5</RequestId>\n  </ResponseMetadata>\n</CreateLaunchConfigurationResponse>\n"
    
    @create_autoscaling_group_response = "<CreateAutoScalingGroupResponse xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">\n  <ResponseMetadata>\n    <RequestId>cc4f9960-ad6e-11de-b82f-996c936914c5</RequestId>\n  </ResponseMetadata>\n</CreateAutoScalingGroupResponse>\n"
    
    @delete_autoscaling_group = "<DeleteAutoScalingGroupResponse  xmlns=\"http://autoscaling.amazonaws.com/doc/2009-05-15/\">
<ResponseMetadata><RequestId>e64fc4c3-e10b-11dd-a73e-2d774d6aee71</RequestId></ResponseMetadata></DeleteAutoScalingGroupResponse>"
  end
  
  specify "AWS::Autoscaling::Base should give back a nice response if there is an error" do
    @as.stubs(:make_request).with('CreateLaunchConfiguration', {
      'ImageId' => 'ami-ed46a784',
      'LaunchConfigurationName' => 'TestAutoscalingGroupName',
      'InstanceType' => "m1.small"
    }).returns stub(:body => @error_response_for_creation, :is_a? => true)
    
    response = @as.create_launch_configuration( :image_id => "ami-ed46a784", :launch_configuration_name => "TestAutoscalingGroupName", :instance_type => "m1.small")
    response.should.be.an.instance_of Hash
    response["Error"]["Message"].should.equal "Launch Configuration by this name already exists - A launch configuration already exists with the name TestAutoscalingGroupName"
  end
  
  specify "AWS::Autoscaling::Base should destroy a launch configuration just fine" do
    @as.stubs(:make_request).with('DeleteLaunchConfiguration', {
      'LaunchConfigurationName' => 'TestAutoscalingGroupName1'
    }).returns stub(:body => @delete_launch_configuration_response, :is_a? => true)
    
    response = @as.delete_launch_configuration( :launch_configuration_name => "TestAutoscalingGroupName1" )
    response.should.be.an.instance_of Hash
  end
  
  specify "AWS::Autoscaling::Base should create a launch configuration" do
    @as.stubs(:make_request).with('CreateLaunchConfiguration', {
      'ImageId' => 'ami-ed46a784',
      'LaunchConfigurationName' => 'CustomTestAutoscalingGroupName',
      'InstanceType' => "m1.small"
    }).returns stub(:body => @create_launch_configuration_response, :is_a? => true)
    
    response = @as.create_launch_configuration( :image_id => "ami-ed46a784", :launch_configuration_name => "CustomTestAutoscalingGroupName", :instance_type => "m1.small")
    response.should.be.an.instance_of Hash
  end
  
  specify "AWS::Autoscaling::Base should be able to create a new autoscaling group" do
    @as.stubs(:make_request).with("CreateAutoScalingGroup", {
      'AutoScalingGroupName' => 'CloudteamTestAutoscalingGroup1',
      'AvailabilityZones.member.1' => 'us-east-1a',
      'LoadBalancerNames' => 'TestLoadBalancerName',
      'LaunchConfigurationName' => 'CloudteamTestAutoscaling',
      'MinSize' => "1", 'MaxSize' => "3"
    }).returns stub(:body => @create_autoscaling_group_response, :is_a? => true)
    response = @as.create_autoscaling_group(:autoscaling_group_name => "CloudteamTestAutoscalingGroup1", :availability_zones => "us-east-1a", :load_balancer_names => "TestLoadBalancerName", :launch_configuration_name => "CloudteamTestAutoscaling", :min_size => 1, :max_size => 3)
    response.should.be.an.instance_of Hash
  end
  
  specify "AWS::Autoscaling::Base should destroy an autoscaling group" do
    @as.stubs(:make_request).with('DeleteAutoScalingGroup', {
      'AutoScalingGroupName' => 'TestAutoscalingGroupName1'
    }).returns stub(:body => @delete_autoscaling_group, :is_a? => true)
    
    response = @as.delete_autoscaling_group( :autoscaling_group_name => "TestAutoscalingGroupName1" )
    response.should.be.an.instance_of Hash
  end
  
end