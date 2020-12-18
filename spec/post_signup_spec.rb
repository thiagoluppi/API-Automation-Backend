describe "POST /signup" do
  context "novo usuario" do
    before (:all) do
      payload = { name: "Dhebora",
                  email: "dhebora@icloud.com",
                  password: "pwd123" }

      MongoDB.new.remove_user(payload[:email])
      @result = Signup.new.create(payload)
    end

    it "valida status code" do
      expect(@result.code).to eql 200
    end

    it "valida id do usuario" do
      expect(@result.parsed_response["_id"].length).to eql 24
    end
  end

  context "usuario duplicado" do
    before(:all) do
      payload = { name: "Joao Lucas",
                  email: "joao@icloud.com",
                  password: "pwd123" }

      MongoDB.new.remove_user(payload[:email])

      Signup.new.create(payload)
      @result = Signup.new.create(payload)
    end

    it "deve retornar 409" do
      expect(@result.code).to eql 409
    end

    it "valida mensagem de erro" do
      expect(@result.parsed_response["error"]).to eql "Email already exists :("
    end

    ############

    examples = Helpers::get_fixture("signup")

    examples.each do |e|
      context "#{e[:title]}" do
        before (:all) do
          @result = Signup.new.create(e[:payload])
        end

        it "valida status code #{e[:code]}" do
          expect(@result.code).to eql e[:code]
        end

        it "valida mensagem de erro" do
          expect(@result.parsed_response["error"]).to eql e[:error]
        end
      end
    end
  end
end
