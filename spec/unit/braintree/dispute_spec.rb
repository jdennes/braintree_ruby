require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Braintree::Dispute do
  let(:attributes) do
    {
      :id => "open_dispute",
      :amount => "31.00",
      :amount_disputed => "500.00",
      :amount_won => "0.00",
      :chargeback_protection_level => nil,
      :created_at => Time.utc(2009, 3, 9, 10, 50, 39),
      :processor_comments => "forwarded comments",
      :date_opened => "2009-03-09",
      :date_won => "2009-04-15",
      :original_dispute_id => "original_dispute_id",
      :received_date => "2009-03-09",
      :reply_by_date => nil,
      :updated_at => Time.utc(2009, 3, 9, 10, 50, 39),
      :pre_dispute_program => Braintree::Dispute::PreDisputeProgram::None,
      :evidence => [
        {
          comment: nil,
          created_at: Time.utc(2009, 3, 10, 12, 5, 20),
          id: "evidence1",
          sent_to_processor_at: nil,
          url: "url_of_file_evidence",
        },
        {
          comment: "text evidence",
          created_at: Time.utc(2009, 3, 10, 12, 5, 21),
          id: "evidence2",
          sent_to_processor_at: "2009-03-13",
          url: nil,
        }
      ],
      :status_history => [
        {
          :effective_date => "2009-03-09",
          :status => "open",
          :timestamp => Time.utc(2009, 3, 9, 10, 50, 39),
        }
      ],
      :transaction => {
        :amount => "31.00",
        :id => "open_disputed_transaction",
        :created_at => Time.utc(2009, 2, 9, 12, 59, 59),
        :installment_count => nil,
        :order_id => nil,
        :purchase_order_number => "po",
        :payment_instrument_subtype => "Visa",
      },
      :paypal_messages => [
        {
          :message => "message",
          :sender => "seller",
          :sent_at => Time.utc(2009, 3, 9, 10, 50, 39),
        }
      ]
    }
  end

  [
    :accept,
    :finalize,
    :find
  ].each do |method_name|
    describe "self.#{method_name}" do
      it "raises an exception if the id is blank" do
        expect do
          Braintree::Dispute.public_send(method_name, "  ")
        end.to raise_error(ArgumentError)
      end

      it "raises an exception if the id is nil" do
        expect do
          Braintree::Dispute.public_send(method_name, nil)
        end.to raise_error(ArgumentError)
      end

      it "does not raise an exception if the id is a fixnum" do
        Braintree::Http.stub(:new).and_return double.as_null_object
        Braintree::Dispute.stub(:_new).and_return nil
        Braintree::ErrorResult.stub(:new).and_return nil

        expect do
          Braintree::Dispute.public_send(method_name, 8675309)
        end.to_not raise_error
      end
    end
  end

  describe "self.add_file_evidence" do
    it "raises an exception if the dispute_id is blank" do
      expect do
        Braintree::Dispute.add_file_evidence("  ", "doc_upload_id")
      end.to raise_error(ArgumentError)
    end

    it "raises an exception if the dispute_id is nil" do
      expect do
        Braintree::Dispute.add_file_evidence(nil, "doc_upload_id")
      end.to raise_error(ArgumentError)
    end

    it "raises an exception if the dispute_id contains invalid characters" do
      expect do
        Braintree::Dispute.add_file_evidence("@#$%", "doc_upload_id")
      end.to raise_error(ArgumentError)
    end

    it "does not raise an exception if the dispute_id is a fixnum" do
      Braintree::Http.stub(:new).and_return double.as_null_object
      Braintree::Dispute.stub(:_new).and_return nil
      expect do
        Braintree::Dispute.add_file_evidence(8675309, "doc_upload_id")
      end.to_not raise_error
    end

    it "raises an exception if the document_upload_id is blank" do
      expect do
        Braintree::Dispute.add_file_evidence("dispute_id", "  ")
      end.to raise_error(ArgumentError)
    end

    it "raises an exception if the document_upload_id is nil" do
      expect do
        Braintree::Dispute.add_file_evidence("dispute_id", nil)
      end.to raise_error(ArgumentError)
    end

    it "raises an exception if the document_upload_id contains invalid characters" do
      expect do
        Braintree::Dispute.add_file_evidence("dispute_id", "@#$%")
      end.to raise_error(ArgumentError)
    end

    it "does not raise an exception if the document_upload_id is a fixnum" do
      Braintree::Http.stub(:new).and_return double.as_null_object
      Braintree::Dispute.stub(:_new).and_return nil
      expect do
        Braintree::Dispute.add_file_evidence("dispute_id", 8675309)
      end.to_not raise_error
    end

    describe "with optional params" do
      it "does not raise an exception if the optional parameters are valid" do
        Braintree::Http.stub(:new).and_return double.as_null_object
        expect do
          Braintree::Dispute.add_file_evidence("dispute_id", {category: "GENERAL", document_id: "document_id"})
        end.to_not raise_error
      end

      it "raises an exception if the optional params contain invalid keys" do
        expect do
          Braintree::Dispute.add_file_evidence("dispute_id", {random_param: ""})
        end.to raise_error(ArgumentError)
      end

      it "raises an exception if the param tag is not a string" do
        Braintree::Http.stub(:new).and_return double.as_null_object

        expect do
          Braintree::Dispute.add_file_evidence("dispute_id", {category: 3, document_id: "document_id"})
        end.to raise_error(ArgumentError)
      end
    end
  end

  describe "self.add_text_evidence" do
    it "raises an exception if the id is blank" do
      expect do
        Braintree::Dispute.add_text_evidence("  ", "text evidence")
      end.to raise_error(ArgumentError)
    end

    it "raises an exception if the id is nil" do
      expect do
        Braintree::Dispute.add_text_evidence(nil, "text evidence")
      end.to raise_error(ArgumentError)
    end

    it "raises an exception if the id contains invalid characters" do
      expect do
        Braintree::Dispute.add_text_evidence("@#$%", "text evidence")
      end.to raise_error(ArgumentError)
    end

    it "does not raise an exception if the id is a fixnum" do
      Braintree::Http.stub(:new).and_return double.as_null_object
      Braintree::Dispute.stub(:_new).and_return nil
      expect do
        Braintree::Dispute.add_text_evidence(8675309, "text evidence")
      end.to_not raise_error
    end

    it "raises an exception if the content is blank" do
      expect do
        Braintree::Dispute.add_text_evidence("dispute_id", " ")
      end.to raise_error(ArgumentError)
    end

    it "raises an exception if the content is nil" do
      expect do
        Braintree::Dispute.add_text_evidence("dispute_id", nil)
      end.to raise_error(ArgumentError)
    end

    describe "with optional params" do
      it "does not raise an exception if the optional parameters are valid" do
        Braintree::Http.stub(:new).and_return double.as_null_object
        expect do
          Braintree::Dispute.add_text_evidence("dispute_id", {content: "a", category: "", sequence_number: 3})
        end.to_not raise_error
      end

      it "raises an exception if the optional params contain invalid keys" do
        expect do
          Braintree::Dispute.add_text_evidence("dispute_id", {random_param: ""})
        end.to raise_error(ArgumentError)
      end

      it "raises an exception if sequence_number is provided and not an integer" do
        expect do
          Braintree::Dispute.add_text_evidence("dispute_id", {sequence_number: "abc"})
        end.to raise_error(ArgumentError)
      end

      it "raises an exception if the param tag is not a string" do
        expect do
          Braintree::Dispute.add_text_evidence("dispute_id", {tag: 3})
        end.to raise_error(ArgumentError)
      end

      it "raises an exception if the param category is not a string" do
        expect do
          Braintree::Dispute.add_text_evidence("dispute_id", {category: 3})
        end.to raise_error(ArgumentError)
      end
    end
  end

  describe "self.remove_evidence" do
    it "raises an exception if the dispute_id is blank" do
      expect do
        Braintree::Dispute.remove_evidence("  ")
      end.to raise_error(ArgumentError)
    end

    it "raises an exception if the dispute_id is nil" do
      expect do
        Braintree::Dispute.remove_evidence(nil)
      end.to raise_error(ArgumentError)
    end

    it "raises an exception if the content is blank" do
      expect do
        Braintree::Dispute.remove_evidence("dispute_id", " ")
      end.to raise_error(ArgumentError)
    end

    it "raises an exception if the content is nil" do
      expect do
        Braintree::Dispute.remove_evidence("dispute_id", nil)
      end.to raise_error(ArgumentError)
    end

    it "raises an exception if the dispute_id contains invalid characters" do
      expect do
        Braintree::Dispute.remove_evidence("@#$%", "evidence_id")
      end.to raise_error(ArgumentError)
    end

    it "raises an exception if the evidence_id contains invalid characters" do
      expect do
        Braintree::Dispute.remove_evidence("dispute_id", "@#$%")
      end.to raise_error(ArgumentError)
    end
  end

  describe "initialize" do
    it "converts string amount_dispute and amount_won" do
      dispute = Braintree::Dispute._new(attributes)

      dispute.amount_disputed.should == 500.0
      dispute.amount_won.should == 0.0
    end

    it "returns 'Effortless Chargeback Protection tool' when initial chargeback_protection_level is effortless" do
      attributes.merge!(:chargeback_protection_level => Braintree::Dispute::ChargebackProtectionLevel::Effortless)
      dispute = Braintree::Dispute._new(attributes)

      expect(dispute.chargeback_protection_level).to eq(Braintree::Dispute::ChargebackProtectionLevel::Effortless)
      expect(dispute.protection_level).to eq(Braintree::Dispute::ProtectionLevel::EffortlessCBP)
    end

    it "returns 'Chargeback Protection tool' when initial chargeback_protection_level is standard" do
      attributes.merge!(:chargeback_protection_level => Braintree::Dispute::ChargebackProtectionLevel::Standard)
      dispute = Braintree::Dispute._new(attributes)

      expect(dispute.chargeback_protection_level).to eq(Braintree::Dispute::ChargebackProtectionLevel::Standard)
      expect(dispute.protection_level).to eq(Braintree::Dispute::ProtectionLevel::StandardCBP)
    end

    it "returns 'No Protection' when initial chargeback_protection_level is nil" do
      dispute = Braintree::Dispute._new(attributes)

      expect(dispute.chargeback_protection_level).to eq(nil)
      expect(dispute.protection_level).to eq(Braintree::Dispute::ProtectionLevel::NoProtection)
    end

    it "returns 'No Protection' when initial chargeback_protection_level is empty" do
      attributes.merge!(:chargeback_protection_level => "")
      dispute = Braintree::Dispute._new(attributes)

      expect(dispute.chargeback_protection_level).to eq("")
      expect(dispute.protection_level).to eq(Braintree::Dispute::ProtectionLevel::NoProtection)
    end

    it "returns 'No Protection' when initial chargeback_protection_level is not_protected" do
      attributes.merge!(:chargeback_protection_level => Braintree::Dispute::ChargebackProtectionLevel::NotProtected)
      dispute = Braintree::Dispute._new(attributes)

      expect(dispute.chargeback_protection_level).to eq(Braintree::Dispute::ChargebackProtectionLevel::NotProtected)
      expect(dispute.protection_level).to eq(Braintree::Dispute::ProtectionLevel::NoProtection)
    end

    [
      :reply_by_date,
      :amount,
      :date_opened,
      :date_won,
      :status_history,
    ].each do |field|
      it "handles nil #{field}" do
        attributes.delete(field)

        dispute = Braintree::Dispute._new(attributes)

        dispute.send(field).should == nil
      end
    end

    it "converts date_opened, date_won, reply_by_date, received_date from String to Date" do
      dispute = Braintree::Dispute._new(attributes.merge(:reply_by_date => "2009-03-14"))

      dispute.date_opened.should == Date.new(2009, 3, 9)
      dispute.date_won.should == Date.new(2009, 4, 15)
      dispute.received_date.should == Date.new(2009, 3, 9)
      dispute.reply_by_date.should == Date.new(2009, 3, 14)
    end

    it "converts transaction hash into a Dispute::TransactionDetails object first" do
      dispute = Braintree::Dispute._new(attributes)

      dispute.transaction_details.id.should == "open_disputed_transaction"
      dispute.transaction_details.amount.should == 31.00
    end

    it "converts transaction hash into a Dispute::Transaction object" do
      dispute = Braintree::Dispute._new(attributes)

      dispute.transaction.amount.should == 31.00
      dispute.transaction.id.should == "open_disputed_transaction"
      dispute.transaction.created_at.should == Time.utc(2009, 2, 9, 12, 59, 59)
      dispute.transaction.installment_count.should == nil
      dispute.transaction.order_id.should == nil
      dispute.transaction.purchase_order_number.should == "po"
      dispute.transaction.payment_instrument_subtype.should == "Visa"
    end

    it "converts status_history hash into an array of Dispute::StatusHistory objects" do
      dispute = Braintree::Dispute._new(attributes)

      dispute.status_history.length.should == 1
      status_history_1 = dispute.status_history.first
      status_history_1.status.should == Braintree::Dispute::Status::Open
      status_history_1.timestamp.should == Time.utc(2009, 3, 9, 10, 50, 39)
    end

    it "converts evidence hash into an array of Dispute::Evidence objects" do
      dispute = Braintree::Dispute._new(attributes)

      dispute.evidence.length.should ==2
      evidence1 = dispute.evidence.first
      evidence1.comment.should == nil
      evidence1.created_at.should == Time.utc(2009, 3, 10, 12, 5, 20)
      evidence1.id.should == "evidence1"
      evidence1.sent_to_processor_at.should == nil
      evidence1.url.should == "url_of_file_evidence"

      evidence2 = dispute.evidence.last
      evidence2.comment.should == "text evidence"
      evidence2.created_at.should == Time.utc(2009, 3, 10, 12, 5, 21)
      evidence2.id.should == "evidence2"
      evidence2.sent_to_processor_at.should == Date.new(2009, 3, 13)
      evidence2.url.should == nil
    end

    it "converts paypal_messages hash into an array of Dispute::PayPalMessage objects" do
      dispute = Braintree::Dispute._new(attributes)

      dispute.paypal_messages.length.should == 1
      paypal_message_1 = dispute.paypal_messages.first
      paypal_message_1.message.should == "message"
      paypal_message_1.sender.should == "seller"
      paypal_message_1.sent_at.should == Time.utc(2009, 3, 9, 10, 50, 39)
    end

    it "handles nil evidence" do
      attributes.delete(:evidence)

      dispute = Braintree::Dispute._new(attributes)

      dispute.evidence.should == nil
    end

    it "handles nil paypal_messages" do
      attributes.delete(:paypal_messages)

      dispute = Braintree::Dispute._new(attributes)

      dispute.paypal_messages.should == nil
    end

    it "sets the older webhook fields for backwards compatibility" do
      dispute = Braintree::Dispute._new(attributes)

      dispute.amount.should == 31.00
      dispute.date_opened.should == Date.new(2009, 3, 9)
      dispute.date_won.should == Date.new(2009, 4, 15)
    end

    it "returns pre_dispute_program value" do
      attributes.merge!(:pre_dispute_program => Braintree::Dispute::PreDisputeProgram::VisaRdr)
      dispute = Braintree::Dispute._new(attributes)

      expect(dispute.pre_dispute_program).to eq(Braintree::Dispute::PreDisputeProgram::VisaRdr)
    end
  end

  describe "==" do
    it "returns true when given a dispute with the same id" do
      first = Braintree::Dispute._new(attributes)
      second = Braintree::Dispute._new(attributes)

      first.should == second
      second.should == first
    end

    it "returns false when given a dispute with a different id" do
      first = Braintree::Dispute._new(attributes)
      second = Braintree::Dispute._new(attributes.merge(:id => "1234"))

      first.should_not == second
      second.should_not == first
    end

    it "returns false when not given a dispute" do
      dispute = Braintree::Dispute._new(attributes)
      dispute.should_not == "not a dispute"
    end
  end

  describe "comments" do
    let(:dispute) { Braintree::Dispute._new(attributes) }

    it "#processor_comments" do
      expect(dispute.processor_comments).to eq(attributes[:processor_comments])
    end
  end

  describe "new" do
    it "is protected" do
      expect do
        Braintree::Dispute.new
      end.to raise_error(NoMethodError, /protected method .new/)
    end
  end
end
