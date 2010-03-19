require File.dirname(__FILE__) + "/../spec_helper"

describe Braintree::Configuration do

  before do
    @original_merchant_id = Braintree::Configuration.merchant_id
    @original_public_key = Braintree::Configuration.public_key
    @original_private_key = Braintree::Configuration.private_key
    @original_environment = Braintree::Configuration.environment
  end

  after do
    Braintree::Configuration.merchant_id = @original_merchant_id
    Braintree::Configuration.public_key  = @original_public_key
    Braintree::Configuration.private_key = @original_private_key
    Braintree::Configuration.environment = @original_environment
  end

  describe "self.base_merchant_path" do
    it "returns /merchants/{merchant_id}" do
      Braintree::Configuration.base_merchant_path.should == "/merchants/integration_merchant_id"
    end
  end

  describe "self.base_merchant_url" do
    it "returns the expected url for the development env" do
      Braintree::Configuration.environment = :development
      port = Braintree::Configuration.port
      Braintree::Configuration.base_merchant_url.should == "http://localhost:#{port}/merchants/integration_merchant_id"
    end

    it "returns the expected url for the sandbox env" do
      Braintree::Configuration.environment = :sandbox
      Braintree::Configuration.base_merchant_url.should == "https://sandbox.braintreegateway.com:443/merchants/integration_merchant_id"
    end

    it "returns the expected url for the production env" do
      Braintree::Configuration.environment = :production
      Braintree::Configuration.base_merchant_url.should == "https://www.braintreegateway.com:443/merchants/integration_merchant_id"
    end
  end

  describe "self.ca_file" do
    it "qa" do
      Braintree::Configuration.environment = :qa
      ca_file = Braintree::Configuration.ca_file
      ca_file.should match(/valicert_ca.crt$/)
      File.exists?(ca_file).should == true
    end

    it "sandbox" do
      Braintree::Configuration.environment = :sandbox
      ca_file = Braintree::Configuration.ca_file
      ca_file.should match(/valicert_ca.crt$/)
      File.exists?(ca_file).should == true
    end

    it "production" do
      Braintree::Configuration.environment = :production
      ca_file = Braintree::Configuration.ca_file
      ca_file.should match(/securetrust_ca.crt$/)
      File.exists?(ca_file).should == true
    end
  end

  describe "self.environment" do
    it "raises an exception if it hasn't been set yet" do
      Braintree::Configuration.instance_variable_set(:@environment, nil)
      expect do
        Braintree::Configuration.environment
      end.to raise_error(Braintree::ConfigurationError, "Braintree::Configuration.environment needs to be set")
    end
  end

  describe "self.environment=" do
    it "raises an exception if the environment is invalid" do
      expect do
        Braintree::Configuration.environment = :invalid_environment
      end.to raise_error(ArgumentError, ":invalid_environment is not a valid environment")
    end
  end

  describe "self.logger" do
    it "defaults to logging to stdout with log_level info" do
      begin
        old_logger = Braintree::Configuration.logger
        Braintree::Configuration.logger = nil
        Braintree::Configuration.logger.level.should == Logger::INFO
      ensure
        Braintree::Configuration.logger = old_logger
      end
    end
  end

  describe "self.merchant_id" do
    it "raises an exception if it hasn't been set yet" do
      Braintree::Configuration.instance_variable_set(:@merchant_id, nil)
      expect do
        Braintree::Configuration.merchant_id
      end.to raise_error(Braintree::ConfigurationError, "Braintree::Configuration.merchant_id needs to be set")
    end
  end

  describe "self.public_key" do
    it "raises an exception if it hasn't been set yet" do
      Braintree::Configuration.instance_variable_set(:@public_key, nil)
      expect do
        Braintree::Configuration.public_key
      end.to raise_error(Braintree::ConfigurationError, "Braintree::Configuration.public_key needs to be set")
    end
  end

  describe "self.private_key" do
    it "raises an exception if it hasn't been set yet" do
      Braintree::Configuration.instance_variable_set(:@private_key, nil)
      expect do
        Braintree::Configuration.private_key
      end.to raise_error(Braintree::ConfigurationError, "Braintree::Configuration.private_key needs to be set")
    end
  end

  describe "self.port" do
    it "is 443 for production" do
      Braintree::Configuration.environment = :production
      Braintree::Configuration.port.should == 443
    end

    it "is 443 for sandbox" do
      Braintree::Configuration.environment = :sandbox
      Braintree::Configuration.port.should == 443
    end

    it "is 3000 or GATEWAY_PORT environment variable for development" do
      Braintree::Configuration.environment = :development
      old_gateway_port = ENV['GATEWAY_PORT']
      begin
        ENV['GATEWAY_PORT'] = nil
        Braintree::Configuration.port.should == 3000

        ENV['GATEWAY_PORT'] = '1234'
        Braintree::Configuration.port.should == '1234'
      ensure
        ENV['GATEWAY_PORT'] = old_gateway_port
      end
    end
  end

  describe "self.protocol" do
    it "is http for development" do
      Braintree::Configuration.environment = :development
      Braintree::Configuration.protocol.should == "http"
    end

    it "is https for production" do
      Braintree::Configuration.environment = :production
      Braintree::Configuration.protocol.should == "https"
    end

    it "is https for sandbox" do
      Braintree::Configuration.environment = :sandbox
      Braintree::Configuration.protocol.should == "https"
    end

  end

  describe "self.server" do
    it "is localhost for development" do
      Braintree::Configuration.environment = :development
      Braintree::Configuration.server.should == "localhost"
    end

    it "is www.braintreegateway.com for production" do
      Braintree::Configuration.environment = :production
      Braintree::Configuration.server.should == "www.braintreegateway.com"
    end

    it "is sandbox.braintreegateway.com for sandbox" do
      Braintree::Configuration.environment = :sandbox
      Braintree::Configuration.server.should == "sandbox.braintreegateway.com"
    end
  end

  describe "self.ssl?" do
    it "returns false for development" do
      Braintree::Configuration.environment = :development
      Braintree::Configuration.ssl?.should == false
    end

    it "returns true for production" do
      Braintree::Configuration.environment = :production
      Braintree::Configuration.ssl?.should == true
    end

    it "returns true for sandbox" do
      Braintree::Configuration.environment = :sandbox
      Braintree::Configuration.ssl?.should == true
    end
  end

end
