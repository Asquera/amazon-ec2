# Amazon Web Services EC2 Query API Ruby Library
# This library has been packaged as a Ruby Gem 
# by Glenn Rempe ( grempe @nospam@ rubyforge.org ).
# 
# Source code and gem hosted on RubyForge
# under the Ruby License as of 12/14/2006:
# http://amazon-ec2.rubyforge.org

module EC2
  
  class AWSAuthConnection
    
    # The ModifyImageAttribute operation modifies an attribute of an AMI.
    #
    # Currently the only attribute supported is launchPermission. By 
    # modifying this attribute it is possible to make an AMI public or 
    # to grant specific users launch permissions for the AMI. To make the 
    # AMI public add the group=all attribute item. To grant launch permissions 
    # for a specific user add a userId=<userid> attribute item.
    def modify_image_attribute(options = {:image_id => "", :attribute => "launchPermission", :operation_type => "add", :user_ids => [], :groups => []})
      
      raise ArgumentError, "No ':image_id' provided" if options[:image_id].nil? || options[:image_id].empty?
      raise ArgumentError, "No ':attribute' provided" if options[:attribute].nil? || options[:attribute].empty?
      raise ArgumentError, "No ':operation_type' provided" if options[:operation_type].nil? || options[:operation_type].empty?
      
      params = {
        "ImageId" => options[:image_id],
        "Attribute" => options[:attribute],
        "OperationType" => options[:operation_type]
      }
      
      # test options provided and make sure they are valid
      case options[:attribute]
      when "launchPermission"
        if options[:user_ids].nil? && options[:groups].nil?
          raise ArgumentError, "Option :attribute=>'launchPermission' requires ':user_ids' or ':groups' options to also be specified"
        end
        
        params.merge!(pathlist("UserId", options[:user_ids])) unless options[:user_ids].nil?
        params.merge!(pathlist("Group", options[:groups])) unless options[:groups].nil?
      else
        raise ArgumentError, "attribute : #{options[:attribute].to_s} is not an known option."
      end
      
      # test options provided and make sure they are valid
      case options[:operation_type]
      when "add", "remove"
        # these args are ok
      else
        raise ArgumentError, ":operation_type was #{options[:operation_type].to_s} but must be 'add' or 'remove'"
      end
      
      make_request("ModifyImageAttribute", params)
      return response = ModifyImageAttributeResponse.new
    end
    
    # The DescribeImageAttribute operation returns information about an attribute of an AMI.
    def describe_image_attribute(imageId, attribute)
      params = { "ImageId" => imageId, "Attribute" => attribute }
      DescribeImageAttributeResponse.new(make_request("DescribeImageAttribute", params))
    end
    
    # The ResetImageAttribute operation resets an attribute of an AMI to its default value.
    def reset_image_attribute(options = {:image_id => "", :attribute => "launchPermission"})
      
      raise ArgumentError, "No ':image_id' provided" if options[:image_id].nil? || options[:image_id].empty?
      raise ArgumentError, "No ':attribute' provided" if options[:attribute].nil? || options[:attribute].empty?
      
      params = {"ImageId" => options[:image_id], 
                "Attribute" => options[:attribute] }
      
      # test options provided and make sure they are valid
      case options[:attribute]
      when "launchPermission"
        # these args are ok
      else
        raise ArgumentError, "attribute : #{options[:attribute].to_s} is not an known option."
      end
      
      make_request("ResetImageAttribute", params)
      return response = ResetImageAttributeResponse.new
    end
    
  end
  
end
