require "rails_helper"

RSpec.describe ContactMailerMailer, type: :mailer do
  describe "contact_elliot" do
    let(:mail) { ContactMailerMailer.contact_elliot }

    it "renders the headers" do
      expect(mail.subject).to eq("Contact elliot")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end