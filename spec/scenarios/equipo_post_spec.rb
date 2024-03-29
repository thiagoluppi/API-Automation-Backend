describe "POST /equipos" do
  before(:all) do
    payload = { email: "thiago.luppi@icloud.com",
                password: "pwd123" }

    result = Sessions.new.login(payload)
    @user_id = result.parsed_response["_id"]
  end

  context "novo equipo" do
    before(:all) do
      payload = { thumbnail: Helpers::get_thumb("kramer.jpg"),
                  name: "Kramer Eddie Van Halen",
                  category: "Cordas",
                  price: 699 }

      MongoDB.new.remove_equipo(payload[:name], @user_id)

      @result = Equipos.new.create(payload, @user_id)
      puts @result
    end

    it "deve retornar 200" do
      expect(@result.code).to eql 200
    end
  end

  context "nao autorizado" do
    before(:all) do
      payload = { thumbnail: Helpers::get_thumb("mic.jpg"),
                  name: "Microfone do Freddy Mercury",
                  category: "Outros",
                  price: 999 }

      @result = Equipos.new.create(payload, nil)
    end

    it "deve retornar 401" do
      expect(@result.code).to eql 401
    end
  end
end
