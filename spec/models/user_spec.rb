require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(
    firstname: "Tom",
    lastname: "Ato",
    email: "tom@to.com",
    password: "secret",
    password_confirmation: "secret"
    )
  }
  describe "Validations" do 
    it "is valid with all valid attributes" do 
      expect(subject).to be_valid
      expect(subject.errors.full_messages).to be_empty
    end
    
    it "is invalid without a first name" do 
      subject.firstname = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Firstname can't be blank")
    end

    it "is invalid without a last name" do 
      subject.lastname = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Lastname can't be blank")
    end

    it "is invalid without an email" do 
      subject.email = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Email can't be blank")
    end

    it "is invalid without a password" do 
      subject.password = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Password can't be blank")
    end

    it "is invalid without a password confirmation" do 
      subject.password_confirmation = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Password confirmation can't be blank")
    end

    it "is invalid if password and password confirmation don't match" do 
      subject.password_confirmation = "totallynotsecret"
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it "is invalid if email isn't unique (case insensitive)" do
      same_as_subject = User.create(
        firstname: "Tom",
        lastname: "Ato",
        email: "TOM@TO.com",
        password: "secret",
        password_confirmation: "secret"
      )
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Email has already been taken")
    end

    it "is invalid if the password is shorter than 5 characters" do 
      subject.password = "oop"
      subject.password_confirmation = "oop"
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include("Password is too short (minimum is 5 characters)")
    end
  end

  describe '.authenticate_with_credentials' do
    it "authenticates when credentials are valid" do
      subject.save!
      auth = User.authenticate_with_credentials(subject.email, subject.password)
      expect(auth).to eq subject
    end

    it "doesn't authenticate with incorrect email" do
      subject.save!
      auth = User.authenticate_with_credentials("other@email.com", subject.password)
      expect(auth).to eq nil
    end

    it "doesn't authenticate with incorrect password" do
      subject.save!
      auth = User.authenticate_with_credentials(subject.email, "notasecret")
      expect(auth).to eq nil
    end

    it "authenticates with correct email even with whitespaces" do
      subject.save!
      auth = User.authenticate_with_credentials("     " + subject.email + "    ", subject.password)
      expect(auth).to eq subject
    end

    it "authenticates with correct email even with incorrect casing" do
      subject.save!
      auth = User.authenticate_with_credentials("tom@TO.com", subject.password)
      expect(auth).to eq subject
    end
  end
end
